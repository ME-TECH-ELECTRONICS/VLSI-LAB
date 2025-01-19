import cocotb
from cocotb.triggers import RisingEdge, Timer

@cocotb.test()
async def test_and_gate(dut):
    """
    Test the AND gate with all possible input combinations.
    """
    # Test all combinations of a and b
    for a in [0, 1]:
        for b in [0, 1]:
            # Apply inputs
            dut.a.value = a
            dut.b.value = b

            # Wait for a short time to allow the output to settle
            await Timer(1, units="ns")
