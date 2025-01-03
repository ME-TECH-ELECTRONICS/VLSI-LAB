num1 = int(input("Enter 1st number: "))
num2 = int(input("Enter 2nd number: "))
op = input("Type of operation (+,-,/,*): ")

if op == "+":
    print(f"{num1} + {num2} = {num1+num2}")
elif op == "-":
    print(f"{num1} - {num2} = {num1-num2}")
elif op == "/":
    print(f"{num1} / {num2} = {num1/num2}")
else:
    print(f"{num1} * {num2} = {num1*num2}")