import pya
import os

project = os.path.expanduser("~/Desktop/sobel_accelerator")
lib = os.path.expanduser(
    "~/Desktop/OpenSTA/vsdbabysoc/skywater-pdk-libs-sky130_fd_sc_hd"
)

layout = pya.Layout()

tech = os.path.join(lib, "tech", "sky130_fd_sc_hd.tlef")
layout.read(tech)

cell_dir = os.path.join(lib, "cells")
for root, dirs, files in os.walk(cell_dir):
    for name in files:
        if name.startswith("sky130_fd_sc_hd__") and name.endswith(".lef") and not name.endswith(".magic.lef"):
            layout.read(os.path.join(root, name))

def_file = os.path.join(
    project, "physical_design", "sobel_floorplan.def"
)
layout.read(def_file)

view = pya.LayoutView.current()
view.show_layout(layout)
view.max_hier()
print("Sobel floorplan loaded")
