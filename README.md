# C Template with Meson

This repository contains an example C library build with Meson, useful as a
template for starting new projects, with all the nice "quality of life" tools
set up.

This project also includes a GitHub Action continuous integration (CI) workflow
to run each tool, including publishing code coverage on GitHub pages.

### Tools

We run the following tools to help ensure our code is well-behaved, standards
conforming, and well-formatted. If the tools aren't installed, running them
will be skipped.

- clang-tidy - Static analyzer to catch common C/C++ mistakes
- Include What You Use (IWYU) - Static analyzer to prevent including files you
  don't need, and that you include ones you do need (without getting them
  included transitively, i.e. through another header file)
- clang-format - Automatic code formatter to help ensure consistently formatted
  code
- valgrind - Run-time analyzer to catch memory errors (like use-after-free,
  forgetting to free, or out-of-bounds accesses)
- Memory Sanitizer (memsan) - Run-time instrumentation to catch memory errors
- lcov - To generate html reports of code coverage
