FROM debian:buster-20191224

LABEL maintainer=fisxoj@gmail.com

ARG SBCL_VERSION

ARG QUICKLISP_PATH="/quicklisp"

ARG QUICKLISP_VERSION

RUN apt-get update && \
    apt-get install -y -qq --no-install-recommends \
    	    curl \
	    ca-certificates \
	    bzip2 \
	    make && \
    apt-get -y autoremove --purge && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN curl -O -L https://downloads.sourceforge.net/project/sbcl/sbcl/${SBCL_VERSION}/sbcl-${SBCL_VERSION}-x86-64-linux-binary.tar.bz2 && \
    bzip2 -cd sbcl-${SBCL_VERSION}-x86-64-linux-binary.tar.bz2 | tar xvf - && \
    cd sbcl-${SBCL_VERSION}-x86-64-linux && \
    sh install.sh && \
    cd .. && \
    rm -rf sbcl-${SBCL_VERSION}-x86-64-linux &&\
    rm sbcl-${SBCL_VERSION}-x86-64-linux-binary.tar.bz2

RUN mkdir /build

# Install Quicklisp
RUN mkdir -p "$QUICKLISP_PATH"

RUN curl -O https://beta.quicklisp.org/quicklisp.lisp && \
    sbcl --non-interactive --load quicklisp.lisp \
         --eval "(quicklisp-quickstart:install :path \"${QUICKLISP_PATH}\")" \
	 --eval "(ql-util:without-prompting (ql:add-to-init-file))" && \
    rm quicklisp.lisp

COPY install-quicklisp-version.lisp /build/

RUN sbcl --non-interactive --load /build/install-quicklisp-version.lisp
