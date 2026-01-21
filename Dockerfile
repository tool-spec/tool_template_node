FROM node:latest

# Install spec binary
RUN apt-get update && apt-get install -y curl && \
    curl -L -o /usr/local/bin/spec https://github.com/hydrocode-de/gotap/releases/download/v0.2.3.1/spec && \
    chmod +x /usr/local/bin/spec && \
    apt-get remove -y curl && apt-get autoremove -y && apt-get clean

# create the tool input structure
RUN mkdir /in
COPY ./in /in
RUN mkdir /out
RUN mkdir /src
COPY ./src /src

WORKDIR /src

# install dependencies:  js2args
RUN npm install js2args

# run command
CMD ["spec", "run", "foobar", "--input-file", "/in/parameters.json"]