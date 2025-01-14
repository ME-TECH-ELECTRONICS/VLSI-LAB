import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge

@cocotb.test()
async def basic_count(dut):
    cocotb.start_soon(Clock(dut.clk, 1, units="ns").start())
    dut.rst.value = 1
    for _ in range(2):
        await RisingEdge(dut.clk)
    dut.rst.value = 0
    for cnt in range(50):
        await RisingEdge(dut.clk)
        dut_cnt = dut.count.value
        predict_val = cnt % 16
        assert dut_cnt == predict_val, \
          "error %s != %s" % (str(dut.count.value), predict_val)