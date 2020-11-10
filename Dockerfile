FROM centos:7 as builder

ARG PYTHON_VERSION=3.9.0
ARG PYTHON_MAJOR=3
RUN yum-builddep -y python python-libs && yum install -y make libffi-devel sqlite-devel zlib zlib-devel
RUN curl -O https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz
RUN tar -xvzf Python-${PYTHON_VERSION}.tgz
WORKDIR Python-${PYTHON_VERSION}
RUN ./configure --prefix=/opt/python/${PYTHON_VERSION} --enable-shared --enable-optimizations --enable-ipv6 LDFLAGS=-Wl,-rpath=/opt/python/${PYTHON_VERSION}/lib,--disable-new-dtags
RUN make && make install


FROM centos:7
ARG PYTHON_VERSION=3.9.0
ARG PYTHON_MAJOR=3
WORKDIR /app
COPY --from=builder /opt/python/${PYTHON_VERSION}/ /opt/python/${PYTHON_VERSION}/

ENV PATH=/opt/python/${PYTHON_VERSION}/bin/:$PATH

ENTRYPOINT [ "python3" ]
CMD ["--version"]
