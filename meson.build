project('c_template_meson', 'c',
  version: '0.1',
  default_options: ['warning_level=3', 'c_std=c89'])

# Add project arguments before declaring targets
if meson.get_compiler('c').get_id() == 'clang'
  add_project_arguments('-fno-common', language: 'c')
endif

inc = include_directories('include')

src = ['src/main.c', 'src/lib.c']
headers = ['include/lib/lib.h']
exe = executable('example', src,
  include_directories: inc,
  c_args: ['-Wall', '-Wextra', '-Wpedantic'],
  install: true)

lib = library('example_lib', 'src/lib.c',
  include_directories: inc,
  c_args: ['-fPIC'],
  install: true)

test_src = ['test/test_lib.c']
test_exe = executable('test_example', test_src,
  include_directories: inc,
  c_args: ['-Wall', '-Wextra', '-Wpedantic', '-Werror'],
  link_with: lib,
  install: false)
test('unit-tests', test_exe)

# Static analyzers, formatters, and sanitizers

# clang-tidy
# Note on FreeBSD, clang-tidy may be found as clang-tidy18 or clang-tidy15
clang_tidy = find_program(['clang-tidy18', 'clang-tidy15', 'clang-tidy'],
  required: false)
if clang_tidy.found()
  test('clang-tidy', clang_tidy,
      args: ['-p', meson.current_build_dir(), '-checks=*'] + src + test_src + headers,
      workdir: meson.current_source_dir())
endif

# Include What You Use
iwyu = find_program(['include-what-you-use', 'iwyu'], required: false)
if iwyu.found()
  iwyu_args = [
    #'-Xiwyu', '--mapping_file=iwyu.imp',
    '-Xiwyu', '--no_fwd_decls',
    '-Xiwyu', '--transitive_includes_only',
    ]
  test('iwyu', iwyu,
    args: iwyu_args + src + test_src + headers,
    workdir: meson.current_source_dir())
endif

# clang-format
# Note on FreeBSD, clang-format may be found as clang-format18 or
# clang-format15
clang_format = find_program(
  ['clang-format18', 'clang-format15', 'clang-format'],
  required: false)
if clang_format.found()
  run_target('format',
    command: ['scripts/run.sh', clang_format, '--verbose', '-i', '-style=file'] + src + test_src + headers,
    depends: [exe, test_exe])
endif

# Code coverage
lcov = find_program('lcov', required: false)
genhtml = find_program('genhtml', required: false)
if lcov.found() and genhtml.found()
  cov_exe = executable('coverage_example', test_src,
    include_directories: inc,
    c_args: ['-fprofile-arcs', '-ftest-coverage', '-fPIC'],
    link_args: ['-fprofile-arcs', '-ftest-coverage'],
    link_with: lib,
    install: false)
  test('coverage', cov_exe)

  run_target('coverage_report',
    command: [
      'sh', '-c',
      'lcov --capture --directory . --output-file coverage.info --exclude "*/test_*"' +
      ' && genhtml coverage.info --output-directory coverage_report',
    ])
endif

# Valgrind
valgrind = find_program('valgrind', required: false)
if valgrind.found()
  test('valgrind', valgrind,
    args: ['--leak-check=full', '--error-exitcode=1', test_exe],
    timeout: 300)
endif

# Memory sanitizer
if meson.get_compiler('c').has_argument('-fsanitize=memory')
  test_memsan_exe = executable('test_memsan_example', test_src,
  include_directories: inc,
    c_args: ['-fsanitize=memory', '-fno-omit-frame-pointer'],
    link_args: ['-fsanitize=memory'],
    pie: true,
    link_with: lib,
    install: false)
  test('memsan', test_memsan_exe)
endif

# Doxygen
doxygen = find_program('doxygen', required: false)
if doxygen.found()
  doxygen_conf = configuration_data()
  doxygen_conf.set('PROJECT_NAME', meson.project_name())
  doxygen_conf.set('PROJECT_NUMBER', meson.project_version())
  doxygen_conf.set('INPUT', ''.join(headers))
  doxygen_conf.set('OUTPUT_DIRECTORY', meson.current_build_dir() / 'docs')
  doxygen_conf.set('RECURSIVE', 'YES')
  doxygen_conf.set('EXCLUDE_PATTERNS', '*/test_*')

  doxyfile = configure_file(
    input: 'docs/Doxyfile.in',
    output: 'Doxyfile',
    configuration: doxygen_conf
  )

  custom_target('doxygen',
    input: doxyfile,
    output: 'doxygen',
    command: [doxygen, doxyfile],
    install: false,
    build_by_default: true
  )
endif
