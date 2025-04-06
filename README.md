# APB Interface with ALU and RAM Slaves

This project implements an **AMBA APB (Advanced Peripheral Bus)** interface that connects to two peripheral slaves: an **ALU (Arithmetic Logic Unit)** and a **RAM**. The APB protocol is used for low-power, low-bandwidth communication with peripherals in many SoC designs.

---
##  Modules Description

### 🔹 APB Master
- Generates APB signals: `PSEL`, `PENABLE`, `PWRITE`, `PADDR`, `PWDATA`
- Controls communication between the bus and the connected slaves

### 🔹 ALU Slave
- Performs arithmetic and logic operations based on control and data sent over the bus
- Supported operations: `ADD`, `SUB`, `AND`, `OR`, `XOR`, etc.
- Operation type selected via address or dedicated control bits

### 🔹 RAM Slave
- Acts as a memory-mapped slave
- Supports read/write access
- Simple synchronous memory with byte or word-level access

---

## 🧪 Testbench

- Includes a testbench that stimulates the APB master to communicate with both ALU and RAM slaves
- Tests:
  - ALU operations through APB
  - RAM read and write via APB
- Displays waveform for visualization

---

## 🔧 How to Run

1. Clone the repository or copy the files
2. Use a simulator like **ModelSim**, **VCS**, or **Icarus Verilog**
3. Run simulation from the do file attached
