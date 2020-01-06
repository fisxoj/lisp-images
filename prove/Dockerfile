ARG TAG
FROM parentheticalenterprises/sbcl-quicklisp-base:${TAG}

RUN sbcl --non-interactive --eval "(ql:quickload '(:prove :mockingbird))"
