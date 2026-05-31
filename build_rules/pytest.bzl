"""Rules for converting py.test tests into bazel targets."""

load("@rules_python//python:defs.bzl", "py_test")


def _sanitize_name(filename):
    """Sanitize name to be a valid bazel target"""
    return filename.replace('/', '__').replace('.', '_')


def _remove_leading_slash(filename):
    # We don't have .removeprefix here
    if filename and filename[0] == '/':
        filename = filename[1:]
    return filename


def _pytest_runner_impl(ctx):
    """Creates a wrapper script that runs py.test runner for the given list of
    files."""
    runner_script = ctx.actions.declare_file(ctx.attr.name)
    ctx.actions.write(runner_script, """\
import sys
import pytest

sys.exit(pytest.main(sys.argv[1:] + %s))
""" % repr(ctx.attr.test_files))
    return [DefaultInfo(executable=runner_script)]


pytest_runner = rule(
    implementation=_pytest_runner_impl,
    attrs={
        "test_files": attr.string_list(mandatory=True, allow_empty=False),
    },
    doc="""Creates a wrapper script that runs py.test runner for the given 
list of files.""",
    executable=True,
)


def _make_pytest_target(name, srcs, **kwargs):
    """Instantiate pytest_runner rule and a corresponding py_test rule.

    Args:
        name: Name of the rule
        test_files: List of py.test files to be executed.
        **kwargs: Additional arguments to pass to the native.py_test targets,
                  e.g. deps.
    """
    test_files = [
        _remove_leading_slash(native.package_name() + '/' + test_file) for
        test_file in srcs]
    runner_file = name + '_runner.py'
    pytest_runner(
        name=runner_file,
        test_files=test_files
    )
    py_test(
        name=name,
        srcs=[runner_file] + srcs,
        main=runner_file,
        **kwargs
    )


def pytest_test(name, srcs, sharded=True, **kwargs):
    """Create bazel native py_test rules for tests using py.test framework.

    If shared, then one py_test target is created per test file. Otherwise,
    only one target is created.
    """
    if sharded:
        names = []
        for test_file in srcs:
            unit_name = name + '_' + _sanitize_name(test_file)
            names.append(unit_name)
            _make_pytest_target(name=unit_name,
                                srcs=[test_file],
                                **kwargs)
        native.test_suite(name=name, tests=names)
    else:
        _make_pytest_target(name, srcs, **kwargs)
