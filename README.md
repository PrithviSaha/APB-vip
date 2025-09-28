# AMBA 3 APB Protocol — Verification

> **Repository:** APB Verification

## 🚀 Project Overview

The APB (Advanced Peripheral Bus) protocol is a simple, low-cost, non‑pipelined peripheral bus optimized for minimal power and reduced interface complexity. This repository contains a UVM-based verification environment and testbench for an AMBA 3 APB DUT (Design Under Test) that verifies read/write behavior, data correctness, control signals, reset behavior, and error handling.

## 🎯 Verification Objectives

* Validate read (`PWRITE = 0`) and write (`PWRITE = 1`) operations.
* Ensure data written to slave (PWDATA) is stored correctly and PRDATA matches expected values.
* Confirm transfers occur only when `transfer = 1` and `READ_WRITE` selects the correct direction.
* Verify reset (`PRESETn`) behavior: outputs reset to default and reset does not toggle mid-transfer.
* Check `PSLVERR` is asserted for invalid transfers or unsupported addresses.
* Ensure no operation occurs when `transfer = 0`.

## 🔌 DUT Interfaces (Signals)

| Signal            |    Dir | Width | Description                      |
| ----------------- | -----: | ----: | -------------------------------- |
| PCLK              |  input |     1 | APB clock (rising edge timed)    |
| PRESETn           |  input |     1 | Active‑LOW system reset          |
| transfer          |  input |     1 | APB enable; high→transfer active |
| READ_WRITE        |  input |     1 | 1→write, 0→read                  |
| APB_Write_paddr   |  input |     9 | 9‑bit write address              |
| APB_Read_paddr    |  input |     9 | 9‑bit read address               |
| APB_Write_data_in |  input |     8 | 8‑bit write data from master     |
| APB_Read_data_out | output |     8 | 8‑bit read data from slave       |
| PSLVERR           | output |     1 | Slave error indicator            |

## 🧱 Testbench Architecture
<img width="672" height="510" alt="image" src="https://github.com/user-attachments/assets/127029e9-f047-4609-80c1-ef8a88d11e65" />

The verification environment follows a conventional UVM architecture composed of:

* **APB_Sequence / sequence_item** — transaction abstraction and stimulus generator
* **APB_Sequencer** — arbitrates sequence items between sequences and driver
* **APB_Driver** — converts transactions into pin‑level activity on the interface
* **APB_Monitor** — passive/active components that sample DUT signals and form transactions
* **APB_Agent** — groups sequencer, driver, and monitor (active or passive)
* **APB_Scoreboard** — golden reference comparator and checker
* **APB_Subscriber** — functional coverage collector (input & output cover groups)
* **APB_Environment** — top‑level container that connects agents, scoreboard, coverage
* **APB_Test** — configures the environment and launches sequences
* **APB_Top** — SystemVerilog top module that instantiates DUT and testbench

## 📋 Verification Results 

### Observed Design Flaws

* `PRESETn` behavior not matching expected results (investigate active‑low handling in DUT).
* **Slave1**: memory depth implemented as 64 entries; expected 256 entries for 8‑bit addressing.
* **Slave2**: same memory depth inconsistency (64 vs expected 256).

### 📊 Coverage Report
- Input Coverage ✅

  <img width="800" height="392" alt="image" src="https://github.com/user-attachments/assets/8becbfac-9a32-4408-918d-d529a19c3716" />

- Output Coverage ✅
  
  <img width="882" height="318" alt="image" src="https://github.com/user-attachments/assets/5fcc02c4-6a64-4983-be04-aa813e650f45" />
  
- Functional Coverage ✅

  <img width="828" height="265" alt="image" src="https://github.com/user-attachments/assets/eaddc3d0-aabd-4795-8ad3-032c70b4d326" />
 
- Assertion Coverage ✅

  <img width="936" height="288" alt="image" src="https://github.com/user-attachments/assets/73cc556f-7d58-4a7d-aabd-5997b92b2d51" />

- Overall Coverage ✅

  <img width="936" height="438" alt="image" src="https://github.com/user-attachments/assets/89bdd4be-6fd5-4ec1-b2b4-2d3b5553f0f0" />

---

## 📂 Resources
- **Verification Report:** [APB_VERIFICATION_REPORT](https://docs.google.com/document/d/1bFx6OAvAw7xLzZ8qrSZUbAJu8k9idxWM/edit?usp=drive_link&ouid=113766502478178390742&rtpof=true&sd=true)
- **Test Plan:** [APB TEST PLAN LINK](https://docs.google.com/spreadsheets/d/1zKbLLzoRzizrULOiGF13gZf9dwEge__P/edit?usp=drive_link&ouid=113766502478178390742&rtpof=true&sd=true)  
- **Functional Coverage Plan:** [APB COVERAGE LINK](https://docs.google.com/spreadsheets/d/1zKbLLzoRzizrULOiGF13gZf9dwEge__P/edit?usp=drive_link&ouid=113766502478178390742&rtpof=true&sd=true)  
- **Assertions:** [APB ASSERTION LINK](https://docs.google.com/spreadsheets/d/1zKbLLzoRzizrULOiGF13gZf9dwEge__P/edit?usp=drive_link&ouid=113766502478178390742&rtpof=true&sd=true)  
- **APB MANUAL:** [APB REFERENCE MANUAL LINK](https://drive.google.com/file/d/1eMB_l8td0uI7XvIKY3lq4_7lKLt4Rsfx/view?usp=drive_link)
---
