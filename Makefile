QUICKLISP_DIST=2018-12-11
SBCL_VERSION=1.4.14
export QUICKLISP_DIST
export SBCL_VERSION

HELPER=./scripts/build-image.sh

build: build-base build-prove build-rove build-slynk

build-base: base/Dockerfile
	$(HELPER) build base

build-prove: prove/Dockerfile
	$(HELPER) build prove

build-rove: rove/Dockerfile
	$(HELPER) build rove

build-slynk:
	$(HELPER) build slynk

push: push-base push-prove push-rove push-slynk

push-base: build-base
	$(HELPER) push base

push-prove: build-prove
	$(HELPER) push prove

push-rove: build-rove
	$(HELPER) push rove

push-slynk: build-slynk
	$(HELPER) push slynk
