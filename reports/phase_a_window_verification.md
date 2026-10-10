# Phase A — Window Generator Verification

## 1. Active window module: 5x5 test
Status: PASS

- Testbench: tb/sobel_window_selfcheck_tb.v
- RTL: rtl/sobel_window.v
- Expected windows: 9
- Actual windows: 9
- Window mismatches: 0

## 2. Active window module: 640x480 pattern test
Status: FAIL

- Testbench: tb/sobel_window_640x480_pattern_tb.v
- RTL: rtl/sobel_window.v
- Expected windows: 304964
- Actual windows: 184314
- Reported window mismatches: 184314

Root cause indicated by RTL inspection:
The active implementation uses five explicit line-buffer positions
and 3-bit row/column counters. It is not a general-width 640x480 design.

## 3. Parameterized backup window plus balanced core: 640x480
Status: PASS

- Testbench: tb/sobel_accelerator_640x480_tb.v
- Window RTL: rtl/sobel_window_backup.v
- Core RTL: rtl/sobel_core_balanced.v
- Expected outputs: 304964
- Actual outputs: 304964
- Output mismatches: 0

## Conclusion
The active window implementation passes the 5x5 test but fails the
640x480 test. The parameterized backup implementation passes the
640x480 full-frame accelerator test. Neither implementation was
modified during these tests.

The earlier reported 3866 mismatches have not yet been reproduced
or conclusively explained.

## Repeated-frame limitation

The current window-generator interface has no frame_start or
end_of_frame input. Two consecutive 640x480 frames without reset
are therefore treated as one continuous 640x960 pixel stream.

Observed output count: 611204
Expected for two independent frames: 609928
Difference: 1276 windows, equal to 2*(640-2).

Independent frame boundaries require reset between frames or a
future RTL interface change adding an explicit frame-start signal.
Continuous back-to-back frame support is not verified.

## Balanced candidate gate-level simulation

The balanced SKY130 mapped netlist compiles with the available
standard-cell models, but the initial gate-level simulation produces
X values on edge_valid and edge_pixel. Zero outputs were checked.
Therefore, balanced-candidate GLS is NOT PASS and remains unresolved.
RTL-level balanced accelerator verification and synthesis checks passed.
Do not treat RTL simulation as a substitute for gate-level verification.

## Timing status before Phase A exit

The existing post-CTS placement-estimated STA report shows:
- Setup slack: -0.64 ns (VIOLATED)
- Hold slack: +0.31 ns (MET)
- Critical endpoint: edge_pixel[0]
- Data arrival time: 8.64 ns
- Data required time: 8.00 ns

This report belongs to the existing implementation and does not
establish timing closure for the balanced candidate. Timing must be
rechecked for the selected implementation. Routed and extracted
timing closure has not been demonstrated.


## Phase A remaining verification status

- Small-image valid-gap testing includes a gap at a row boundary. Full-frame
  row-boundary gaps have not been independently verified.
- The balanced candidate mapped netlist GLS produces X values. Zero outputs
  were checked; gate-level functional equivalence is NOT established.
- Existing original gate-level evidence does not establish equivalence of
  the selected balanced candidate RTL and its mapped netlist.
- Existing full-accelerator post-CTS setup slack is -0.64 ns. This violation
  is unresolved; it must not be reported as timing closure.
- Timing for the selected final implementation has not been rechecked.
- Phase A is not technically closed while candidate GLS and final
  implementation timing remain unresolved.
