# QLT

QLT is for testing systems. It consists of a number of test files and
support files.

A test file starts off with a header form that specifies its
prerequisites. It looks like this:

    '(:requires ("foo" "bar"))

The `:requires` value is a list of system names to load (via ASDF)
before attempting to load the rest of the file.

The remainder of the file has forms to run, as though with the
[load](http://l1sp.org/cl/load) function.

If any of the forms in the test file signals an error, the test is
considered failed and evaluation stops.

## Loading environment

When loading the file, the `*package*` is set to the `qlt-user`
package, which uses only the `cl` package and nothing else.

The value of `*default-pathname-defaults*` is the directory in which
the test file is found. Non-code files related to the test file can be
referenced with relative pathnames.

The variable `qlt-user:*scratch-directory*` is bound to a pathname to
which the script can write files, if necessary for testing. All files
in the scratch directory are deleted after the test completes
successfully.

FASLs for supporting libraries are always compiled fresh each time the
test file is loaded.

## Directory structure

Test files should go in the tests/ subdirectory of this repo. Multiple
related tests, or tests that require non-code support files, should go
in a subdirectory.

## Running tests

These tests are currently run from the Quicklisp dist construction
system. The goal is to reduce the number of runtime errors in released
Quicklisp dists.

Easily running tests separately from the Quicklisp dist system is a
goal, but not yet implemented.

## Feedback

If you have any questions or comments, feel free to email
zach@quicklisp.org or open a [github
issue](https://github.com/quicklisp/qlt/issues).


