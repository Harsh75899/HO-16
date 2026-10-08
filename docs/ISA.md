
# HO-16 Instruction Set Architecture

## 1. Processor Overview

| Parameter | Specification |
|---|---|
| Processor | HO-16 |
| Architecture | 16-bit RISC |
| Instruction Width | 16 bits |
| Register Count | 8 |
| Register Width | 16 bits |
| Instruction Memory | 256 × 16 bits |
| Data Memory | 256 × 16 bits |

---

## 2. Register Set

HO-16 contains eight general-purpose registers:

| Register | Encoding |
|---|---|
| R0 | 000 |
| R1 | 001 |
| R2 | 010 |
| R3 | 011 |
| R4 | 100 |
| R5 | 101 |
| R6 | 110 |
| R7 | 111 |

All registers are 16 bits wide.

---

## 3. Instruction Encoding

Each instruction is 16 bits wide.

### R-Type Instructions

Used for register-to-register ALU operations.

```text
15          12 11       9 8        6 5        3 2       0
+-------------+-----------+----------+----------+---------+
|    Opcode   |    Rd     |   Rs1    |   Rs2    | Unused  |
+-------------+-----------+----------+----------+---------+
```

Operations:

```text
ADD Rd, Rs1, Rs2
SUB Rd, Rs1, Rs2
AND Rd, Rs1, Rs2
OR  Rd, Rs1, Rs2
XOR Rd, Rs1, Rs2
```

---

## 4. Immediate Instructions

### ADDI

Adds a sign-extended 6-bit immediate value to a register.

```text
15          12 11       9 8        6 5               0
+-------------+-----------+----------+-----------------+
|    Opcode   |    Rd     |   Rs1    |    Immediate   |
+-------------+-----------+----------+-----------------+
```

Format:

```text
ADDI Rd, Rs1, Imm
```

The 6-bit immediate is sign extended to 16 bits.

---

## 5. Load Instruction

### LD

Loads a 16-bit value from data memory into a register.

```text
15          12 11       9 8        6 5               0
+-------------+-----------+----------+-----------------+
|    Opcode   |    Rd     |   Rs1    |    Immediate   |
+-------------+-----------+----------+-----------------+
```

Format:

```text
LD Rd, [Rs1 + Imm]
```

The effective address is calculated as:

```text
Effective Address = Rs1 + SignExtended(Imm)
```

---

## 6. Store Instruction

### ST

Stores a register value into data memory.

```text
15          12 11       9 8        6 5               0
+-------------+-----------+----------+-----------------+
|    Opcode   |    Rd     |   Rs1    |    Immediate   |
+-------------+-----------+----------+-----------------+
```

Format:

```text
ST Rd, [Rs1 + Imm]
```

For the current HO-16 implementation, `Rd` identifies the register whose value is written to memory.

The effective address is:

```text
Effective Address = Rs1 + SignExtended(Imm)
```

---

## 7. Branch Instruction

### BEQ

Branches when two registers are equal.

```text
15          12 11       9 8        6 5        3 2     0
+-------------+-----------+----------+----------+-------+
|    Opcode   |  Unused   |   Rs1    |   Rs2    | Offset|
+-------------+-----------+----------+----------+-------+
```

Format:

```text
BEQ Rs1, Rs2, Offset
```

The ALU performs:

```text
Rs1 - Rs2
```

If the result is zero:

```text
Rs1 == Rs2
```

the branch is taken.

The 3-bit signed branch offset is sign extended to 16 bits.

```text
Branch Target = PC + SignExtended(Offset)
```

---

## 8. Jump Instruction

### JMP

Performs an unconditional PC-relative jump.

```text
15          12 11                    3 2     0
+-------------+------------------------+-------+
|    Opcode   |        Unused          | Offset|
+-------------+------------------------+-------+
```

Format:

```text
JMP Offset
```

The offset is sign extended to 16 bits.

```text
Jump Target = PC + SignExtended(Offset)
```

---

## 9. Opcode Table

| Opcode | Instruction | Type |
|---|---|---|
| 0000 | ADD | R-Type |
| 0001 | SUB | R-Type |
| 0010 | AND | R-Type |
| 0011 | OR | R-Type |
| 0100 | XOR | R-Type |
| 0110 | ADDI | I-Type |
| 0111 | LD | I-Type |
| 1000 | ST | I-Type |
| 1001 | BEQ | Branch |
| 1010 | JMP | Jump |

---

## 10. ALU Operations

| ALU Select | Operation |
|---|---|
| 000 | ADD |
| 001 | SUB |
| 010 | AND |
| 011 | OR |
| 100 | XOR |

---

## 11. Control Signals

The control unit generates the following control signals:

| Signal | Function |
|---|---|
| ALUSrc | Selects register or immediate as ALU input |
| RegWrite | Enables register-file write |
| MemRead | Enables data-memory read |
| MemWrite | Enables data-memory write |
| MemToReg | Selects memory data for register writeback |
| Branch | Enables conditional branch |
| Jump | Enables unconditional jump |

---

## 12. Program Counter Operation

During normal sequential execution:

```text
Next PC = PC + 1
```

For a taken BEQ:

```text
Next PC = PC + SignExtended(Offset)
```

For JMP:

```text
Next PC = PC + SignExtended(Offset)
```

The branch/jump control logic selects the appropriate next PC.

---

## 13. Example Program

Example register initialization:

```text
R1 = 25
R2 = 10
```

Example operations:

```text
ADD  R3, R1, R2
SUB  R4, R3, R1
AND  R5, R3, R4
ADDI R7, R6, 5
ST   R7, [R1 + 5]
LD   R6, [R1 + 5]
```

Expected results for the tested program include:

```text
R3 = 35
R4 = 10
R5 = 2
R7 = 48
Memory[30] = 48
```

---

## 14. Verification

The HO-16 processor has been verified using an automated Verilog testbench.

The verification checks:

- ADD
- SUB
- AND
- ADDI
- ST
- LD
- BEQ
- JMP
- Sequential PC operation
- BEQ PC transition
- JMP PC transition

The current automated verification result is:

```text
PASS = 11
FAIL = 0

ALL TESTS PASSED
```
