"""Read-only check for managed windows bleeding onto a foreign display."""
import json
import subprocess


def query(kind):
    result = json.loads(subprocess.check_output(["/opt/homebrew/bin/omniwmctl", "query", kind]))
    assert result["ok"], result
    return result["result"]["payload"][kind]


def intersects(a, b):
    return (min(a["x"] + a["width"], b["x"] + b["width"]) > max(a["x"], b["x"]) + 1
            and min(a["y"] + a["height"], b["y"] + b["height"]) > max(a["y"], b["y"]) + 1)


displays = query("displays")
windows = query("windows")
physical_order = ["Built-in Retina Display", "MAG 341C OLED", "DELL U2725QE"]
connected_names = {display["name"] for display in displays}
if connected_names <= set(physical_order):
    assert [d["name"] for d in sorted(displays, key=lambda d: d["frame"]["x"])] == [
        name for name in physical_order if name in connected_names
    ], "Wrong macOS monitor order: expected laptop → ultrawide → Dell"
for window in windows:
    if window["mode"] != "tiling" or window.get("isAppHidden") or not window.get("frame"):
        continue
    for display in displays:
        if window.get("display", {}).get("id") == display["id"]:
            continue
        assert not intersects(window["frame"], display["frame"]), (
            f'{window["app"]["name"]} ({window["windowId"]}) bleeds onto {display["name"]}'
        )
print(f"Live geometry: {len(windows)} windows / {len(displays)} connected displays; correct desk order, no cross-display bleed.")
