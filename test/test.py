# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_project(dut):

    dut._log.info("Start test")

    clock = Clock(dut.clk, 10, unit="us")
    cocotb.start_soon(clock.start())

    # Reset
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0

    await ClockCycles(dut.clk, 5)

    dut.rst_n.value = 1

    # -------- Test Case 1: Positive x Positive --------
    A = 3
    B = 2

    dut.ui_in.value = (B << 4) | (A & 0xF)

    await ClockCycles(dut.clk, 1)

    expected = 6
    dut._log.info(f"Test 1: A={A} B={B} Expected={expected} Output={dut.uo_out.value}")

    # -------- Test Case 2: Positive x Positive --------
    A = 4
    B = 5

    dut.ui_in.value = (B << 4) | (A & 0xF)

    await ClockCycles(dut.clk, 1)

    expected = 20
    dut._log.info(f"Test 2: A={A} B={B} Expected={expected} Output={dut.uo_out.value}")

    # -------- Test Case 3: Negative x Positive --------
    A = -1
    B = 5

    dut.ui_in.value = (B << 4) | (A & 0xF)

    await ClockCycles(dut.clk, 1)

    expected = -5
    dut._log.info(f"Test 3: A={A} B={B} Expected={expected} Output={dut.uo_out.value}")

    # -------- Test Case 4: Negative x Positive --------
    A = -2
    B = 3

    dut.ui_in.value = (B << 4) | (A & 0xF)

    await ClockCycles(dut.clk, 1)

    expected = -6
    dut._log.info(f"Test 4: A={A} B={B} Expected={expected} Output={dut.uo_out.value}")

    # -------- Test Case 5: Positive x Negative --------
    A = 5
    B = -1

    dut.ui_in.value = (B << 4) | (A & 0xF)

    await ClockCycles(dut.clk, 1)

    expected = -5
    dut._log.info(f"Test 5: A={A} B={B} Expected={expected} Output={dut.uo_out.value}")

    # -------- Test Case 6: Positive x Negative --------
    A = 3
    B = -2

    dut.ui_in.value = (B << 4) | (A & 0xF)

    await ClockCycles(dut.clk, 1)

    expected = -6
    dut._log.info(f"Test 6: A={A} B={B} Expected={expected} Output={dut.uo_out.value}")

    # -------- Test Case 7: Negative x Negative --------
    A = -1
    B = -1

    dut.ui_in.value = (B << 4) | (A & 0xF)

    await ClockCycles(dut.clk, 1)

    expected = 1
    dut._log.info(f"Test 7: A={A} B={B} Expected={expected} Output={dut.uo_out.value}")

    # -------- Test Case 8: Negative x Negative --------
    A = -2
    B = -3

    dut.ui_in.value = (B << 4) | (A & 0xF)

    await ClockCycles(dut.clk, 1)

    expected = 6
    dut._log.info(f"Test 8: A={A} B={B} Expected={expected} Output={dut.uo_out.value}")

    # -------- Test Case 9: Positive x Positive --------
    A = 7
    B = 3

    dut.ui_in.value = (B << 4) | (A & 0xF)

    await ClockCycles(dut.clk, 1)

    expected = 21
    dut._log.info(f"Test 9: A={A} B={B} Expected={expected} Output={dut.uo_out.value}")

    # -------- Test Case 10: Positive x Positive --------
    A = 5
    B = 5

    dut.ui_in.value = (B << 4) | (A & 0xF)

    await ClockCycles(dut.clk, 1)

    expected = 25
    dut._log.info(f"Test 10: A={A} B={B} Expected={expected} Output={dut.uo_out.value}")

    # -------- Test Case 11: Negative x Positive --------
    A = -5
    B = 4

    dut.ui_in.value = (B << 4) | (A & 0xF)

    await ClockCycles(dut.clk, 1)

    expected = -20
    dut._log.info(f"Test 11: A={A} B={B} Expected={expected} Output={dut.uo_out.value}")

    # -------- Test Case 12: Negative x Positive --------
    A = -7
    B = 3

    dut.ui_in.value = (B << 4) | (A & 0xF)

    await ClockCycles(dut.clk, 1)

    expected = -21
    dut._log.info(f"Test 12: A={A} B={B} Expected={expected} Output={dut.uo_out.value}")

    # -------- Test Case 13: Positive x Negative --------
    A = 4
    B = -5

    dut.ui_in.value = (B << 4) | (A & 0xF)

    await ClockCycles(dut.clk, 1)

    expected = -20
    dut._log.info(f"Test 13: A={A} B={B} Expected={expected} Output={dut.uo_out.value}")

    # -------- Test Case 14: Positive x Negative --------
    A = 7
    B = -7

    dut.ui_in.value = (B << 4) | (A & 0xF)

    await ClockCycles(dut.clk, 1)

    expected = -49
    dut._log.info(f"Test 14: A={A} B={B} Expected={expected} Output={dut.uo_out.value}")

    # -------- Test Case 15: Negative x Negative --------
    A = -4
    B = -5

    dut.ui_in.value = (B << 4) | (A & 0xF)

    await ClockCycles(dut.clk, 1)

    expected = 20
    dut._log.info(f"Test 15: A={A} B={B} Expected={expected} Output={dut.uo_out.value}")

    # -------- Test Case 16: Negative x Negative --------
    A = -7
    B = -7

    dut.ui_in.value = (B << 4) | (A & 0xF)

    await ClockCycles(dut.clk, 1)

    expected = 49
    dut._log.info(f"Test 16: A={A} B={B} Expected={expected} Output={dut.uo_out.value}")

    # -------- Test Case 17: Zero test --------
    A = 0
    B = 5

    dut.ui_in.value = (B << 4) | (A & 0xF)

    await ClockCycles(dut.clk, 1)

    expected = 0
    dut._log.info(f"Test 17: A={A} B={B} Expected={expected} Output={dut.uo_out.value}")

    # -------- Test Case 18: Boundary test --------
    A = -8
    B = 1

    dut.ui_in.value = (B << 4) | (A & 0xF)

    await ClockCycles(dut.clk, 1)

    expected = -8
    dut._log.info(f"Test 18: A={A} B={B} Expected={expected} Output={dut.uo_out.value}")

    # -------- Test Case 19: Boundary test --------
    A = -8
    B = -1

    dut.ui_in.value = (B << 4) | (A & 0xF)

    await ClockCycles(dut.clk, 1)

    expected = 8
    dut._log.info(f"Test 19: A={A} B={B} Expected={expected} Output={dut.uo_out.value}")

    # -------- Test Case 20: Positive x Positive --------
    A = 6
    B = 7

    dut.ui_in.value = (B << 4) | (A & 0xF)

    await ClockCycles(dut.clk, 1)

    expected = 42
    dut._log.info(f"Test 20: A={A} B={B} Expected={expected} Output={dut.uo_out.value}")
