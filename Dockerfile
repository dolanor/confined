FROM golang:1.14 AS deps

# We only copy the module files
COPY go.mod .

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


FROM gcr.io/distroless/base

COPY --from=build /go/bin/confined /

CMD [ "/confined" ]
