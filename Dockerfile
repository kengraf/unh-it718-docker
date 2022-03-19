FROM golang:1.13 golang_build

WORKDIR /go/src/github.com/alexellis/href-counter/

COPY vendor vendor
COPY app.go	.

RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o app .

FROM alpine:3.10
RUN apk --no-cache add ca-certificates

WORKDIR /root/

COPY --from=golang_build /go/src/github.com/alexellis/href-counter/app    .

CMD ["./app"]
