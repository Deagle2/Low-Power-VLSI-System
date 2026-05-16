# Low-Power VLSI Digital Timing System (RTL-to-GDSII)

### A Digital Design RTL-GDSII implementation of a low power digital timing architecture using Cadence Design Flow (Genus, Innovus)
- The tool inferred 5 hierarchical ICG instances (`RC_CG_MOD`).
-  The final physical layout achieved **100% routing completion with zero DRC, connectivity, or density violations**, reaching a post-route effective utilization of **77.2%**.

## Benchmark Comparison

### Power & Area Analysis (Genus Synthesis vs. Innovus Post-Route)


| Design Stage & Flow Version | Cell Count | Total Area (µm²) | Leakage Power (µW) | Internal Power (µW) | Switching Power (µW) | Total Power (µW) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: |
| Genus Baseline | 205 | 2045.900 | 10.360 | 134.280 | 14.390 | 159.030 |
| Genus Proposed | 211 | 2026.978 | 9.871 | 58.340 | 6.114 | 74.344 |
| Innovus Post-Route Baseline | 255 | 2394.100 | 12.890 | 153.150 | 12.800 | 178.840 |
| **Innovus Post-Route Proposed** | **242** | **2210.905** | **11.770** | **86.847** | **10.494** | **109.112** |

#### **Post-Route Net Savings (Proposed vs. Baseline):**
- **Total Power Reduction:** -69.73 µW (**-38.99%**)
- **Switching Power Reduction:** -2.31 µW (**-18.02%**)
- **Internal Power Reduction:** -66.30 µW (**-43.29%**)
- **Total Area Savings:** -183.195 µm² (**-7.6%**)
---


## ⏱️ Timing Analysis

* **Baseline Design:** Critical path delay of **4458 ps** ($215 \text{ MHz}$ max theoretical limit).
* **Proposed Design:** Reduced critical path delay to **3015 ps**, extending the maximum theoretical frequency headroom to **309 MHz** (a **32% timing path optimization**).

| Flow Version | Timing Analysis | WNS |
| :--- | :--- | :---: |
| Genus Baseline | Setup | +5353 ps |
| Genus Proposed | Setup | +6768 ps |
| Innovus Baseline | Setup | +4.671 ns |
| Innovus Baseline | Hold | +0.001 ns |
| Innovus Proposed | Setup | +6.114 ns |
| Innovus Proposed | Hold | +0.002 ns |

---

## Design Flow

### EDA Tool Implementation Flow
![Flowchart](assets/Flowchart.png)

### Functional Verification & Simulation
> Functional verification waveform executed in Cadence nclaunch.
![Waveform](assets/nclaunchsim.png)

### Synthesized RTL Gate-Level Schematic
![RTL Schematic](assets/gui_schematic.png)

### Clock Gating Cell Inference Detail

![Clock Gating](assets/clockgatinginference.png)

### Final 90nm Physical Layout (Post-Route)
![Post Route Layout](assets/PostRoute%20Layout.png)

---
## Reports
The raw synthesis and physical design report outputs detailing cell breakdowns, power rails, timing slacks, and physical floorplan metrics can be found below:

*  **Area:** [`ICG_area.rep`](./reports/ICG_area.rep) 
*  **Power:** [`ICG_power.rep`](./reports/ICG_power.rep) 
*  **Timing:** [`ICG_timing.rep`](./reports/ICG_timing.rep)
*  **Critical Path Data:** [`ICG_worst_setup.rep`](./reports/ICG_worst_setup.rep) 
*  **Innovus Summary :** [`stopwatch.main.htm.ascii`](./reports/stopwatch.main.htm.ascii) 
