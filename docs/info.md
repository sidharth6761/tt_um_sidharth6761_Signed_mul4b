<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

### Mitchell Multiplier Algorithm

The design implements signed multiplication using Mitchell's approximation:

1. **Sign Extraction**: Extract sign bits from both inputs
   - `sign_a = A[3]`
   - `sign_b = B[3]`

2. **Absolute Value Conversion**: Convert to positive values using 2's complement
   - `abs_a = (sign_a) ? (~A + 1) : A`
   - `abs_b = (sign_b) ? (~B + 1) : B`

3. **Priority Encoding**: Find MSB (Most Significant Bit) position for each input
   - `ka = encoder(abs_a)` → position of MSB in A (0-3)
   - `kb = encoder(abs_b)` → position of MSB in B (0-3)

4. **Magnitude Calculation**: Approximate multiplication on absolute values
   - `Xa = abs_a << kb`
   - `Xb = abs_b << ka`
   - `s = Xa + Xb`
   - `k = ka + kb`

5. **Output Encoding**: Extract bits and shift to form result
   - Extract bits from `s` based on position `k`
   - Shift right to normalize

6. **Sign Restoration**: Apply correct sign to result
   - `result_sign = sign_a XOR sign_b`
   - If negative, apply 2's complement
   
## How to test

Provide two 4-bit inputs using the input pins:

ui[3:0] → Operand A

ui[7:4] → Operand B

The multiplier computes the product internally using the Mitchell approximation.

The result appears on the output pins:

## External hardware

Does not require any external hardware
