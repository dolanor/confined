FROM golang:1.14 AS deps

WORKDIR /go/src/confined

# We only copy the module files
COPY go.mod .
COPY go.sum .

# We download all dependencies and bake them into the temporary deps image
RUN go mod download -x \
# We delete the module files to avoid having them in the layer
&&  rm go.mod go.sum

# We build from the deps image
FROM deps AS build

COPY . .

# Let's run test so we never forget
RUN go test -v ./...
# Let's build the binaries and move them to $GOPATH/bin
RUN go get -v ./...


# We use a minimalist image to minimize size for pushing to registry and storing
FROM gcr.io/distroless/base

# We copy the binary built in the built stage into the / of the final image
COPY --from=build /go/bin/confined /

# We define the default command when running the image
CMD [ "/confined" ]
