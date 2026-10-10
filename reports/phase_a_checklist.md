# Phase A — RTL Verification Checklist

## A. Functional verification

- [x] Original core directed simulation
- [x] Balanced core: 10,000 randomized comparisons
- [x] Balanced accelerator: 5x5 image test
- [x] Active window: 5x5 self-check
- [x] Window reset recovery test
- [x] Window valid-gap test
- [x] Core corner cases: zero, maximum and directional edges
- [x] Accelerator valid-gap test
- [x] Parameterized window: 640x480 alignment test
- [x] Parameterized window + balanced core: full-frame test
- [x] Documented: the earlier 3,866-mismatch result was not reproduced; its original cause remains unknown
- [x] Documented limitation: back-to-back frames without reset or a frame-start signal are unsupported
- [x] Verified small-image valid gaps, including a row-boundary gap; full-frame boundary-gap behavior remains unverified
- [x] Implementation choice documented: parameterized window for full-frame tests; active window is limited to 5x5

## B. Synthesis and gate-level verification

- [x] Original core synthesis evidence
- [x] Balanced core synthesis evidence
- [x] Balanced accelerator SKY130 synthesis
- [x] Mapped netlist structural check
- [x] Existing gate-level functional simulation evidence
- [ ] Confirm gate-level simulation corresponds to the selected final RTL
- [x] Documented comparison: RTL checks 9 outputs; balanced candidate GLS checks 0 outputs and produces X values

## C. Timing evidence available before physical design

- [x] Standalone balanced-core STA report
- [x] Existing post-CTS placement-estimated timing report
- [ ] Resolve the existing full-accelerator setup violation
- [ ] Recheck timing after selecting the final implementation

## Phase A exit criteria

Phase A is not complete until all open verification items are
resolved or explicitly documented with an accepted limitation.
Do not claim routed timing closure or final physical signoff here.
