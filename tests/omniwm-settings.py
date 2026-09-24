"""Validate the interaction contract and schema-sensitive values for OmniWM 0.6.8."""
import sys
import tomllib

with open(sys.argv[1], "rb") as config_file:
    config = tomllib.load(config_file)
assert config["schemaVersion"] == 3
assert "monitorRoutingOverrides" not in config, "Schema 3 uses routing.arrangements"
assert config["routing"]["mode"] == "custom"
monitors = config["routing"]["arrangements"][0]["monitors"]
assert [(m["gridColumn"], m["gridRow"]) for m in monitors] == [(0, 0), (1, 0), (2, 0)]
assert len({m["monitorDisplayUUID"] for m in monitors}) == 3
assert config["focus"]["followsMouse"] is True
assert config["focus"]["moveMouseToFocusedWindow"] is False
assert config["gestures"]["mouseMoveModifierKey"] == "off"
# Unlike mouseMoveModifierKey, mouseResizeModifierKey has NO "off" case.
assert config["gestures"]["mouseResizeModifierKey"] == "controlOptionCommandShift"
assert config["niri"]["defaultContainerPrimarySpan"] == 0.5
assert config["niri"]["centerFocusedColumn"] == "never"
assert config["niri"]["singleWindowFit"] == "container_primary_span"
assert config["niri"]["containerPrimarySpanPresets"] == [0.33333, 0.5, 0.66667, 1.0]
for binding in config["hotkeys"]:
    if binding["id"] in {"focus.left", "focus.right", "focus.up", "focus.down", "move.left", "move.right", "moveColumnToWorkspaceUp", "moveColumnToWorkspaceDown"}:
        assert binding["binding"] == "Unassigned", binding
print("OmniWM settings: schema 3, routing and Niri interaction contract passed.")
