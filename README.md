# AVR-LLVM examples

**NOTE**: Before running the examples, make sure the built AVR-LLVM directory is inside the `$PATH` environment variable.
It must also preceed the location any other LLVM installation (such as in `/usr/bin`), otherwise that one will be used instead.

To do this:
``` bash
export PATH=~/projects/builds/llvm/bin:$PATH
```

A collection of AVR-LLVM examples.

There exists a base file in each subdirectory - it may be a C/C++ source (.c/.cpp), an LLVM IR (.ll) source,
or an AVR assembly file (.s).

## Using the examples

Inside each example subdirectory, run `make`.

* If an example consists of a C header file, an LLVM IR file will be generated from it.
* If an example consists of an LLVM IR file, or one was just generated from a C file, an AVR
assembly file will be generated from it.

For some examples, compiler options such as the target CPU and the clock speed may need to be changed.
You can modify these settings by opening `Makefile.config`.

## More examples

There are more examples in `llvm/test/*/AVR` directories inside AVR-LLVM. They are not as user-friendly however.

