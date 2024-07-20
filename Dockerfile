FROM quay.io/projectquay/golang:1.20 AS builder
COPY main.go .
RUN make build OS="linux"

FROM scratch
WORKDIR /
COPY --from=builder go-makefile .
ENTRYPOINT [ "./go-makefile"]