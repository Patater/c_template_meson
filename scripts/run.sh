#!/bin/sh

# Run the first argument passed to this program after going to the source root
# directory.
# Note that if meson's run_target() had a "workdir" kwarg, like test(), we
# wouldn't need this script anymore.

cd "${MESON_SOURCE_ROOT}"

# This line is a bit funny looking. What's going on is we expect meson to pass
# us whatever program it found using find_program() as the first argument so
# that we can run it. We don't duplicate the program finding logic in our shell
# script.
"$@"
