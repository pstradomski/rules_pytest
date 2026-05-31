# rules_pytest

[Bazel](https://bazel.build/) rules for running [pytest](https://docs.pytest.org/) tests.

## Enabling extra registry

To allow bazel to find `rules_pytest` repository, edit `.bazelrc`:

```
common --enable_bzlmod
common --registry file:///home/pawel/src/rules_pytest/bazel_registry
common --registry https://bcr.bazel.build
```

## Example usage

See `example` directory for a complete example of usage.

### `MODULE.bazel`

Add the following to your `MODULE.bazel`

```
bazel_dep(name = "rules_pytest", version = "0.3")
```

Make sure you also add `pytest` to your requirements.

### `BUILD`

```
# Import pytest_test rule
load("@rules_pytest//build_rules:pytest.bzl", "pytest_test")

# Import requirements - the requirements file must include pytest!
load("@third_party//:requirements.bzl", "requirement")

pytest_test(
    name = "sample_test",
    srcs = ["sample_test.py"],
    deps = [requirement("pytest")],
)

```
