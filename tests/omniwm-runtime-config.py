"""Ask the running app for its native config/input diagnostic, without disturbing an existing capture."""
import json
import pathlib
import subprocess


def capture(action, *args):
    result = json.loads(subprocess.check_output([
        "/opt/homebrew/bin/omniwmctl", "capture", action, *args, "--json"
    ]))
    assert result["ok"], result
    return result["result"]["payload"]


assert capture("status")["phase"] == "idle", "An existing capture is running; leave it untouched and retry later"
capture("start", "trace")
result = capture("stop")
diagnostic = pathlib.Path(result["lastArtifact"]["path"]).read_text()
active = diagnostic.split("== Active Issues ==\n", 1)[1].split("\n==", 1)[0].strip()
assert active == "none", active
assert "accessibilityGranted=true" in diagnostic
assert "enabled=true" in diagnostic
assert "mouseTapInstalled=true" in diagnostic
assert "registrationFailures=0" in diagnostic
print("Running OmniWM: native config accepted; accessibility and input hooks healthy.")
