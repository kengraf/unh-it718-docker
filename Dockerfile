# Developer needs tools for compiling Go code
FROM golang:1.13 AS golang_build

WORKDIR /go/src/

# COPY vendor vendor
COPY http.go	.

RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o app .

# Deployer needs only enough to run statically linked app
FROM scratch
# alpine:3.10
# RUN apk --no-cache add ca-certificates

WORKDIR /root/

COPY --from=golang_build /go/src/http  .

CMD ["./app"]
