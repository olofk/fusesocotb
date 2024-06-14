# This file is public domain, it can be freely copied without restrictions.
# SPDX-License-Identifier: CC0-1.0

from random import random

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge

async def request_packet(dut):
    while True:
        dut.i_valid.value = 1
        await RisingEdge(dut.i_clk)
        if dut.i_valid.value and dut.o_ready.value:
            break
    dut.i_valid.value = 0

#FIXME: Add timeout
async def recv_word(dut, rate=0.5):
    while True:
        dut.i_msg_ready.value = int(random() < rate)
        await RisingEdge(dut.i_clk)
        if dut.o_msg_valid.value and dut.i_msg_ready.value:
            return dut.o_msg_data.value

async def recv_packet(dut, rate=0.5):

    l = ""

    while True:
        l += chr(await recv_word(dut, rate))
        if dut.o_msg_last.value:
            break

    expected = cocotb.top.MSG_STR._handle.get_signal_val_str().decode('ascii')
    assert l == expected
    dut._log.info(f"Received {l}")

async def init_dut(dut):
    cocotb.start_soon(Clock(dut.i_clk, 10, units="ns").start())

    dut._log.info("Initialize and reset model")

    # Initial values
    dut.i_valid.value = 0
    dut.i_msg_ready.value = 0

    # Reset DUT
    dut.i_rst.value = 1
    for _ in range(2):
        await RisingEdge(dut.i_clk)
    dut.i_rst.value = 0

async def multi_request(dut, interval=20):
    for i in range(5):
        for _ in range(interval):
            await RisingEdge(dut.i_clk)
        dut._log.info("Requesting packet " + str(i))
        await request_packet(dut)

async def multi_receive(dut):
    for i in range(5):
        dut._log.info("Waiting for packet " + str(i))
        await recv_packet(dut)

@cocotb.test()
async def test_busy_cfg(dut):
    await init_dut(dut)

    for _ in range(3):
        await RisingEdge(dut.i_clk)

    st = cocotb.start_soon(multi_request(dut))
    rt = cocotb.start_soon(multi_receive(dut))

    await st
    await rt
