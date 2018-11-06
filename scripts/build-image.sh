#!/bin/bash

function tag () {
    echo "${SBCL_VERSION}-${QUICKLISP_DIST}"
}

VARIANT=$2

cd ${VARIANT}

ORGANIZATION=parentheticalenterprises

BASE_NAME=${BASE_NAME:-sbcl-quicklisp}

VERSIONED_TAG="${ORGANIZATION}/${BASE_NAME}-${VARIANT}:$(tag)"
LATEST_TAG="${ORGANIZATION}/$BASE_NAME-${VARIANT}:latest"

case "$1" in
    build)
	docker build --build-arg SBCL_VERSION=${SBCL_VERSION} --build-arg QUICKLISP_DIST=${QUICKLISP_DIST} . -t "${VERSIONED_TAG}" -t "${LATEST_TAG}"
	;;
    push)
	docker push "${VERSIONED_TAG}"
	docker push "${LATEST_TAG}"
esac
