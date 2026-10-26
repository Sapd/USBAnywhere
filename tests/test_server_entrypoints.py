# Copyright 2026 Denis Arnst (Sapd) — https://github.com/Sapd
# USBAnywhere project: oscarlosu-lab (SnakeFoxu) — https://github.com/oscarlosu-lab
# Licensed under GPL-3.0; see the repository LICENSE.
"""Execute public forwarding entrypoints with isolated canonical scripts."""
import json
from pathlib import Path
import shlex
import shutil
import subprocess
import sys
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]

class ServerEntrypoints(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix="USBAnywhere entrypoints ")
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        (self.root / "scripts").mkdir()
        self.canonical = self.root / "server-windows/scripts"
        self.canonical.mkdir(parents=True)

    def entry(self, name):
        path = self.root / "scripts" / name
        shutil.copy2(ROOT / "scripts" / name, path)
        return path

    def test_control_forwards_exact_arguments_and_exit_status(self):
        name = "usbanywhere-ctl"
        (self.canonical / name).write_text("import json,sys; print(json.dumps(sys.argv[1:])); sys.exit(7)\n")
        args = ["share", "1-1; echo unsafe", "value with spaces"]
        result = subprocess.run([sys.executable, str(self.entry(name)), *args], capture_output=True, text=True, cwd="/")
        self.assertEqual(result.returncode, 7)
        self.assertEqual(json.loads(result.stdout), args)

    def test_installers_forward_without_running_a_second_implementation(self):
        for name in ["install-server-mac.sh", "uninstall-server-mac.sh"]:
            with self.subTest(name=name):
                code = "import json,sys; print(json.dumps(sys.argv[1:])); sys.exit(9)"
                (self.canonical / name).write_text("#!/bin/sh\nexec " + shlex.quote(sys.executable) + " -c " + shlex.quote(code) + ' "$@"\n')
                args = ["100.1.2.3", "100.4.5.6", "label with spaces"]
                result = subprocess.run(["/bin/sh", str(self.entry(name)), *args], capture_output=True, text=True, cwd="/")
                self.assertEqual(result.returncode, 9)
                self.assertEqual(json.loads(result.stdout), args)

    def test_missing_submodule_fails_with_actionable_message(self):
        for name in ["usbanywhere-ctl", "install-server-mac.sh", "uninstall-server-mac.sh"]:
            with self.subTest(name=name):
                interpreter = sys.executable if name == "usbanywhere-ctl" else "/bin/sh"
                result = subprocess.run([interpreter, str(self.entry(name))], capture_output=True, text=True)
                self.assertEqual(result.returncode, 2)
                self.assertIn("git submodule update --init server-windows", result.stderr)

if __name__ == "__main__":
    unittest.main()
