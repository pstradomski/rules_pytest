load("@rules_python//python:pip.bzl", "compile_pip_requirements")
load("@rules_pytest//build_rules:pytest.bzl", "pytest_test")
load("@third_party//:requirements.bzl", "requirement")

compile_pip_requirements(
    name = "requirements",
    src = "requirements.in",
    requirements_txt = "requirements.lock",
)

pytest_test(
    name = "sample_test",
    srcs = ["sample_test.py"],
    sharded = False,
    deps = [requirement("pytest")],
)

pytest_test(
    name = "sharded_test",
    srcs = [
        "one_test.py",
        "two_test.py",
    ],
    sharded = True,
    deps = [requirement("pytest")],
)
