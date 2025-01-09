num1 = int(input("Enter the length 1st side: "))
num2 = int(input("Enter the length 2nd side: "))
num3 = int(input("Enter the length 3rd side: "))

if num1 == num2 == num3:
    print("It is a equilaterial triangle")
elif (num1 + num2 <= num3) or (num2 + num3 <= num1) or (num1 + num3 < num2):
    print("Not a triangle")
elif num1 == num2 or num1 == num3 or num2== num3:
    print("It is a isosceles triangle")
elif not(num1 == num2 == num3):
    print("It is a scalene triangle")
    