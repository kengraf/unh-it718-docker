# Developer needs tools for compiling Go code
FROM golang:1.13 AS golang_build

WORKDIR /go/src/

COPY http.go	.

RUN go build -o http .

# Deployer needs only enough to run statically linked http application
FROM scratch

WORKDIR /root/

COPY --from=golang_build /go/src/http  .

EXPOSE 8090

CMD ["/root/http"]
