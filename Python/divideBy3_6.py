num = int(input("Enter the number: "))
if(num % 3 == 0) & (num % 6 == 0):
    print(f"{num} is divisible by 3 and 6")
else:
    print(f"{num} not divisible by either 6 or 3 or both")