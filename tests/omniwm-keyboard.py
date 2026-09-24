"""Check first-match Karabiner arrow routing, not merely JSON syntax."""
import itertools
import json
import sys

with open(sys.argv[1]) as config_file:
    config = json.load(config_file)
profile = next(profile for profile in config["profiles"] if profile.get("selected"))
rules = profile["complex_modifications"]["rules"]
manipulators = [m for rule in rules for m in rule["manipulators"]]

for side in ("left", "right"):
    key = f"{side}_shift"
    tracker = next(m for m in manipulators if m["from"].get("key_code") == key)
    assert tracker["to"] == [
        {"set_variable": {"name": f"helium_{key}", "value": 1, "key_up_value": 0}},
        {"key_code": key},
    ], "Physical Shift must be tracked, released, and passed through"

cases = 0
for hyper, left, right in itertools.product((0, 1), repeat=3):
    variables = {"hyper_layer": hyper, "helium_left_shift": left, "helium_right_shift": right}
    for direction in ("left", "down", "up", "right"):
        candidates = [m for m in manipulators if m["from"].get("key_code") == f"{direction}_arrow"]
        for m in candidates:
            assert m["from"]["modifiers"] == {"optional": ["any"]}
            assert all(c["type"] == "variable_if" for c in m.get("conditions", []))
        match = next((m for m in candidates if all(
            variables.get(c["name"], 0) == c["value"] for c in m.get("conditions", [])
        )), None)
        if not hyper:
            assert match is None, "Ordinary arrows and text-selection chords must pass through"
        else:
            action = "move" if left or right else "focus"
            if action == "move" and direction in ("left", "right"):
                action = "move-column"
            assert match["to"] == [{"shell_command": f"/opt/homebrew/bin/omniwmctl command {action} {direction}"}]
        cases += 1
print(f"Keyboard routing: {cases} Hyper/physical-Shift/direction cases passed.")
