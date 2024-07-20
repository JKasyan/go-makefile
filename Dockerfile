FROM quay.io/projectquay/golang:1.20 AS builder
WORKDIR /go/src/app
COPY main.go .
COPY Makefile .
COPY go.mod .
RUN make linux

FROM scratch
WORKDIR /
COPY --from=builder /go/src/app/go-makefile .
ENTRYPOINT [ "./go-makefile"]