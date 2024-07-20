APP=$(shell basename $(shell git remote get-url origin))
TARGETARCH=$(shell dpkg --print-architecture)
REGISTRY=ekasyan
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
IMAGE_ID=${VERSION}-${TARGETARCH}
IMAGE_TAG=${REGISTRY}/${APP}:${IMAGE_ID}

format:
	gofmt -s -w ./

lint:
	golint

test:
	go test -v

get:
	go get

build: format get
	CGO_ENABLED=0 GOOS=${OS} GOARCH=${TARGETARCH} go build -v -o go-makefile -ldflags "-X="github.com/JKasyan/cmd.appVersion=${VERSION}

linux:
	$(MAKE) build OS=linux

arm:
	$(MAKE) build OS=arm

macos:
	$(MAKE) build OS=macos

windows:
	$(MAKE) build OS=windows

image:
	@echo "tag: ${IMAGE_TAG}"
	docker build -t ${IMAGE_TAG} .

push:
	docker push ${IMAGE_TAG}

clean:
	@echo "remove image with tag: ${IMAGE_ID}"
	docker rmi $(shell docker images | grep ${IMAGE_ID} | awk '{print $$3}')