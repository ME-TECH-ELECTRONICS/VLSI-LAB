def xor_hex_sequence(hex_string):
    hex_list = hex_string.split(',')  # Split input by comma
    result = 0
    for hex_num in hex_list:
        result ^= int(hex_num, 16)  # Convert hex to int and XOR
        print(f"XORing: {result} ^ {hex_num} = {hex(result)}")
    return hex(result)  # Return result as hex

# User input
hex_input = input("Enter Seq: ")
xor_result = xor_hex_sequence(hex_input)
print(f"XOR Result: {xor_result}")
