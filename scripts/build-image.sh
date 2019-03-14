#!/bin/bash

# This file will only work when called by the Makefile, which sets some variables

function tag () {
    echo "${SBCL_VERSION}-${QUICKLISP_DIST}"
}

VARIANT=$2

cd ${VARIANT}

ORGANIZATION=parentheticalenterprises

BASE_NAME=${BASE_NAME:-sbcl-quicklisp}

VERSIONED_TAG="${ORGANIZATION}/${BASE_NAME}-${VARIANT}:$(tag)"
LATEST_TAG="${ORGANIZATION}/$BASE_NAME-${VARIANT}:latest"
CI_TAG="${ORGANIZATION}/${BASE_NAME}-${VARIANT}:${TRAVIS_COMMIT}"

# https://stackoverflow.com/a/13864829
if [ ! -z ${TRAVIS_COMMIT+x} ]; then
    # Login in a script to obscure credentials in CI
    echo "Logging into docker repo"

    echo "$DOCKER_PASSWORD" | docker login -u $DOCKER_USER --password-stdin

    TAG=$CI_TAG
else
    echo "Not logging into docker repo because we aren't in CI."

    TAG=$LATEST_TAG
fi

case "$1" in
    build)
	docker build --build-arg SBCL_VERSION=${SBCL_VERSION} --build-arg QUICKLISP_DIST=${QUICKLISP_DIST} . -t "${TAG}"

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
        docker tag "${TAG}" "${VERSIONED_TAG}"
	docker push "${VERSIONED_TAG}"
        docker tag "${TAG}" "${LATEST_TAG}"
	docker push "${LATEST_TAG}"
esac
