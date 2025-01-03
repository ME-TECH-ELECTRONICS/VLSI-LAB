P = int(input("Enter Principle amount: ")) 
R = int(input("Enter Rate of interest: "))
T = int(input("Enter Time period: "))
Si = (P * R * T) / 100

print(f"P = {P}, R = {R}, T = {T}")
print(f"Si = {Si}")