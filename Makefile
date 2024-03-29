export QUICKLISP_DIST=2023-10-21
export SBCL_VERSION=2.3.10

HELPER=./scripts/build-image.sh

.PHONY: build-base build-prove build-rove build-slynk

build: build-base build-prove build-rove build-slynk

build-base: base/Dockerfile
	$(HELPER) build base

build-prove: prove/Dockerfile
	$(HELPER) build prove

build-rove: rove/Dockerfile
	$(HELPER) build rove

build-slynk:
	$(HELPER) build slynk

test: test-base test-prove test-rove test-slynk

test-base:
	$(HELPER) smoke-test base "(ql:dist-version \"quicklisp\")"

test-prove:
	$(HELPER) smoke-test prove "(ql:quickload '(:prove :mockingbird))"

test-rove:
	$(HELPER) smoke-test rove "(ql:quickload '(:rove :mockingbird))"

test-slynk:
	$(HELPER) smoke-test slynk "(ql:quickload :slynk)"

publish: publish-base publish-prove publish-rove publish-slynk

publish-base:
	$(HELPER) publish base

publish-prove:
	$(HELPER) publish prove

publish-rove:
	$(HELPER) publish rove

publish-slynk:
	$(HELPER) publish slynk
