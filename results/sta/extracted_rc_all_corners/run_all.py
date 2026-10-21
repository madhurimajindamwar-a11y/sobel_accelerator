from pathlib import Path
import subprocess
import csv
import re

root = Path.cwd()
out = root / "results/sta/extracted_rc_all_corners"
libdir = Path("/home/vsduser/Desktop/OpenSTA/vsdbabysoc/lib")

libs = sorted(libdir.glob("sky130_fd_sc_hd__*.lib"))

print("Liberty files found:", len(libs), flush=True)

results = []

for lib in libs:
    corner = lib.stem.replace("sky130_fd_sc_hd__", "")
    folder = out / corner
    folder.mkdir(parents=True, exist_ok=True)

    tcl = f"""
read_lef {root}/physical_design/lef/merged_sky130_cts.lef
read_liberty {lib}
read_def {root}/physical_design/routing/sobel_detailed_pinfix.def
read_sdc {root}/constraints/sobel.sdc
set_propagated_clock [all_clocks]

read_spef {root}/results/sta/openrcx_test/sobel_extracted.spef

puts "===== SETUP ====="
report_checks -path_delay max -group_path_count 10
report_wns -max
report_tns -max

puts "===== HOLD ====="
report_checks -path_delay min -group_path_count 10
report_wns -min
report_tns -min

puts "===== STA COMPLETE ====="
"""

    (folder / "run_sta.tcl").write_text(tcl)

    print("Running:", corner, flush=True)

    with (folder / "sta_full.log").open("w") as log:
        proc = subprocess.run(
            ["openroad", "-exit", str(folder / "run_sta.tcl")],
            cwd=root,
            stdout=log,
            stderr=subprocess.STDOUT,
            timeout=180
        )

    text = (folder / "sta_full.log").read_text(
        errors="replace"
    )

    setup_match = re.search(
        r"===== SETUP =====(.*?)===== HOLD =====",
        text, re.S
    )
    hold_match = re.search(
        r"===== HOLD =====(.*?)===== STA COMPLETE =====",
        text, re.S
    )

    setup = setup_match.group(1) if setup_match else ""
    hold = hold_match.group(1) if hold_match else ""

    (folder / "setup.rpt").write_text(setup)
    (folder / "hold.rpt").write_text(hold)

    def metric(pattern, data):
        m = re.search(pattern, data)
        return m.group(1) if m else "N/A"

    completed = (
        proc.returncode == 0
        and "===== STA COMPLETE =====" in text
    )

    row = [
        corner,
        "PASS" if completed else "ERROR",
        metric(r"wns max\s+(-?[\d.]+)", setup),
        metric(r"tns max\s+(-?[\d.]+)", setup),
        metric(r"wns min\s+(-?[\d.]+)", hold),
        metric(r"tns min\s+(-?[\d.]+)", hold),
    ]

    results.append(row)
    print("  ", row, flush=True)

with (out / "summary.csv").open("w", newline="") as f:
    writer = csv.writer(f)
    writer.writerow([
        "corner",
        "status",
        "setup_wns_ns",
        "setup_tns_ns",
        "hold_wns_ns",
        "hold_tns_ns"
    ])
    writer.writerows(results)

print("===== ALL CORNERS COMPLETED =====")
print("Reports:", out / "summary.csv")
