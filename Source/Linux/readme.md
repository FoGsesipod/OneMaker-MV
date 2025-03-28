# OneMaker MV's injector on linux
Contained in this directory are the following:
- Modified `qtbase/src/corelib/io/qresource.cpp`
- Docker configuration
- Automation script `(run.sh)`

The dockerfile is built to expect a copy of Qt 5.5.1 source in .tar.xz format as `qt.tar.gz`

The run.sh script can automatically download the source code and run the docker commands properly.

Once done, the compiled binary will be in `output/`