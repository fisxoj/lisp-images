# Lisp Images for Docker

Here are a couple of images for using lisp in containerized environments!  There are a few variations that build on the `quicklisp-sbcl-base` image, which is Debian stretch with [sbcl](http://www.sbcl.org/) and [quicklisp](https://www.quicklisp.org/beta/) installed.

I'll try to keep the [ChangeLog](./ChangeLog) updated as new releases roll out!

## Base

[`parentheticalenterprises/sbcl-quicklisp-base`](https://hub.docker.com/r/parentheticalenterprises/sbcl-quicklisp-base/)

The image others build off of.  Some interesting things for you, the user:

* quicklisp in installed in `/quicklisp`.  That means you can add local projects to `/quicklisp/local-projects` much as you would without docker to add codebases that aren't downloadable via quicklisp.


## (p?)rove

[`parentheticalenterprises/sbcl-quicklisp-prove`](https://hub.docker.com/r/parentheticalenterprises/sbcl-quicklisp-prove/)
[`parentheticalenterprises/sbcl-quicklisp-rove`](https://hub.docker.com/r/parentheticalenterprises/sbcl-quicklisp-rove/)


The [`prove`](https://github.com/fukamachi/prove) and [`rove`](https://github.com/fukamachi/rove) images are just the base with prove or rove, the testing packages by [Eitaro Fukamachi](https://github.com/fukamachi) as well as [`mockingbird`](https://github.com/Chream/mockingbird) by [Christopher Eames](https://github.com/Chream).  Thanks for the code, guys!


## Slynk

[`parentheticalenterprises/sbcl-quicklisp-slynk`](https://hub.docker.com/r/parentheticalenterprises/sbcl-quicklisp-slynk/)


This image contains the backend for [`sly`](https://github.com/joaotavora/sly) by [João Távora](https://github.com/joaotavora).  It starts up a slynk server inside the container for you, so you should be able to run the container with port `4008` exposed to your host machine and then run `sly-connect RET 127.0.0.1 RET 4008` in emacs to connect.  Dockerized lisp dev environment!
