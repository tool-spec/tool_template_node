# Build gotap from source, then discard Go
FROM golang:1.25-alpine AS gotap-builder
RUN apk add --no-cache git
ARG GOTAP_VERSION=main
RUN git clone --depth 1 --branch ${GOTAP_VERSION} https://github.com/tool-spec/gotap.git /gotap && \
    cd /gotap && go build -o gotap .

FROM node:18.12.1-buster
COPY --from=gotap-builder /gotap/gotap /usr/local/bin/gotap
RUN chmod +x /usr/local/bin/gotap

# create the tool input structure
RUN mkdir /in
COPY ./in /in
RUN mkdir /out
RUN mkdir /src
COPY ./src /src
COPY ./package.json /src/package.json

WORKDIR /src

# Generate parameter bindings from tool.yml at build time
RUN gotap generate --spec-file=tool.yml --target=node-js --output=parameters.js

# copy the citation file - looks funny to make COPY not fail if the file is not there
COPY ./CITATION.cf[f] /src/CITATION.cff

WORKDIR /src
CMD ["gotap", "run", "foobar", "--input-file", "/in/input.json"]
