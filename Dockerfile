FROM python:2.7-slim

# Adding Golang based on 
# https://github.com/docker-library/golang/blob/1eab0db63794152b4516dbcb70270eb9dced4cbd/1.5/Dockerfile
RUN apt-get update && apt-get install -y --no-install-recommends \
	make \
	curl \
	git \
    && rm -rf /var/lib/apt/lists/*

ENV GOLANG_VERSION 1.5.3
ENV GOLANG_DOWNLOAD_URL https://golang.org/dl/go$GOLANG_VERSION.linux-amd64.tar.gz
ENV GOLANG_DOWNLOAD_SHA256 43afe0c5017e502630b1aea4d44b8a7f059bf60d7f29dfd58db454d4e4e0ae53

RUN curl -fsSL "$GOLANG_DOWNLOAD_URL" -o golang.tar.gz \
    && echo "$GOLANG_DOWNLOAD_SHA256  golang.tar.gz" | sha256sum -c - \
    && tar -C /usr/local -xzf golang.tar.gz \
    && rm golang.tar.gz

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"

# Add this toolchain
ENV SRCLIBPATH $GOPATH/src
ADD . $GOPATH/src/sourcegraph.com/sourcegraph/srclib-python
RUN cd $GOPATH/src/sourcegraph.com/sourcegraph/srclib-python && make install

# Cleanup
RUN rm -rf /usr/local/go 
