ARG BASE_TAG
FROM parentheticalenterprises/sbcl-quicklisp-base:${BASE_TAG}

RUN apt-get update && \
    apt-get install -y -qq --no-install-recommends \
    	build-essential \
	git && \
    apt-get -y autoremove --purge && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


RUN git clone https://github.com/joaotavora/sly.git /quicklisp/local-projects/sly

RUN git clone https://github.com/joaotavora/sly-named-readtables.git /quicklisp/local-projects/sly-named-readtables

RUN git clone https://github.com/joaotavora/sly-macrostep.git /quicklisp/local-projects/sly-macrostep

RUN git clone https://github.com/joaotavora/sly-company.git /quicklisp/local-projects/sly-company

RUN git clone https://github.com/joaotavora/sly-repl-ansi-color.git /quicklisp/local-projects/sly-repl-ansi-color

RUN git clone https://github.com/joaotavora/sly-quicklisp.git /quicklisp/local-projects/sly-quicklisp

RUN sbcl --non-interactive --eval "(ql:quickload '(:slynk :trivial-signal))"

COPY ./scripts/start-slynk.lisp /build/start-slynk.lisp

EXPOSE 4008 4009

CMD ["sbcl", "--load", "/build/start-slynk.lisp"]
