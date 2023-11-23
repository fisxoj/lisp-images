#!/bin/bash

# This file will only work when called by the Makefile, which sets some variables

function release_tag () {
    echo "${SBCL_VERSION}-${QUICKLISP_DIST}"
}

VARIANT=$2

cd ${VARIANT}

ORGANIZATION=parentheticalenterprises

BASE_NAME=${BASE_NAME:-sbcl-quicklisp}
IMAGE_NAME="${ORGANIZATION}/${BASE_NAME}-${VARIANT}"
VERSION=$(git rev-parse --short HEAD 2>/dev/null)

# For me, locally!
shopt -s expand_aliases
alias docker=podman

# https://stackoverflow.com/a/13864829
if [ ! -z ${TRAVIS_COMMIT+x} ]; then
    # Login in a script to obscure credentials in CI
    echo "Logging into docker repo"

    echo "$DOCKER_PASSWORD" | docker login -u $DOCKER_USER --password-stdin

    TAG=$CI_TAG
    BASE_TAG="$(release_tag)"
else
    echo "Not logging into docker repo because we aren't in CI."

    TAG=$LATEST_TAG
    BASE_TAG="${VERSION}"
fi

case "$1" in
    build)
	docker build \
               --build-arg SBCL_VERSION=${SBCL_VERSION} \
               --build-arg QUICKLISP_DIST=${QUICKLISP_DIST} \
               --build-arg BASE_TAG=${BASE_TAG} \
               . \
               -t "${IMAGE_NAME}:${VERSION}" \
               -t "${IMAGE_NAME}:latest"


        if [ ! -z ${TRAVIS_COMMIT+x} ]; then
            echo "Pushing CI version of image"
            docker push "${CI_TAG}"
        fi
	;;
    smoke-test)
        docker pull "${TAG}"
        echo "Testing ${TAG} loading $3"
        docker run --rm "$TAG" sbcl --non-interactive --eval "${3}"
        ;;
    publish)
        docker pull "${TAG}"
        docker tag "${TAG}" "${IMAGE_NAME}:$(release_tag)"
	docker push "${IMAGE_NAME}:$(release_tag)"
        docker tag "${TAG}" "${IMAGE_NAME}:LATEST"
	docker push "${IMAGE_NAME}:LATEST"
esac
