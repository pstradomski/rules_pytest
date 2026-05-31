import json
import os
import unittest
from pathlib import Path

VERSION = "0.3"


class RegistryTest(unittest.TestCase):
    def get_registry_tree(self) -> set[str]:
        """List of files in bazel_registry directory."""
        registry_tree = set()
        for dirpath, _, filenames in os.walk("bazel_registry"):
            dirpath = Path(dirpath)
            for filename in filenames:
                registry_tree.add(dirpath / filename)
        return registry_tree

    def test_registry_json_file(self):
        """Check that bazel_registry exists and is valid JSON."""
        files_in_registry = self.get_registry_tree()
        registry_json_file = Path("bazel_registry") / "bazel_registry.json"
        self.assertIn(registry_json_file, files_in_registry)
        with open(registry_json_file, "rt") as fp:
            json.load(fp)

    def test_exported_module_equal_to_main_module(self):
        """Check that MODULE.bazel in registry matches the real one."""
        print(self.get_registry_tree())
        with open(
            Path("bazel_registry")
            / "modules"
            / "rules_pytest"
            / VERSION
            / "MODULE.bazel",
            "rt",
        ) as fp:
            registry_module_contents = fp.read()
        with open("MODULE.bazel", "rt") as fp:
            main_module_contents = fp.read()

        self.assertEqual(registry_module_contents, main_module_contents)


if __name__ == "__main__":
    unittest.main()
