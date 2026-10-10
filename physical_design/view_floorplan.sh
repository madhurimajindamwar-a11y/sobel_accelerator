#!/bin/bash
set -e

PROJECT="$HOME/Desktop/sobel_accelerator"
LIB="$HOME/Desktop/OpenSTA/vsdbabysoc/skywater-pdk-libs-sky130_fd_sc_hd"

# Create a KLayout macro that imports every standard-cell LEF.
cat > "$PROJECT/physical_design/load_floorplan.lym" <<'MACRO'
<?xml version="1.0" encoding="utf-8"?>
<klayout-macro>
  <description>Load Sobel floorplan with SKY130 LEFs</description>
  <language>python</language>
  <autorun>true</autorun>
  <show-in-menu>false</show-in-menu>
  <script>
import pya
import os

project = os.path.expanduser("~/Desktop/sobel_accelerator")
lib = os.path.expanduser("~/Desktop/OpenSTA/vsdbabysoc/skywater-pdk-libs-sky130_fd_sc_hd")
tech = os.path.join(lib, "tech", "sky130_fd_sc_hd.tlef")

# Load the technology and standard-cell LEFs into a layout.
layout = pya.Layout()
layout.read(tech)

for root, dirs, files in os.walk(os.path.join(lib, "cells")):
    for name in files:
        if name.startswith("sky130_fd_sc_hd__") and name.endswith(".lef") and not name.endswith(".magic.lef"):
            layout.read(os.path.join(root, name))

# Load the DEF after the cell macros are available.
layout.read(os.path.join(project, "physical_design", "sobel_floorplan.def"))

view = pya.LayoutView.current()
view.show_layout(layout)
view.max_hier()
  </script>
</klayout-macro>
