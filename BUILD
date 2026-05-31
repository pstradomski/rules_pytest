load("@rules_python//python:defs.bzl", "py_test")

filegroup(
    name = "module_bazel",
    srcs = ["MODULE.bazel"],
)

filegroup(
    name = "registry",
    srcs = glob(["bazel_registry/**"]),
)

py_test(
    name = "registry_test",
    srcs = ["registry_test.py"],
    data = [
        ":module_bazel",
        ":registry",
    ],
)
