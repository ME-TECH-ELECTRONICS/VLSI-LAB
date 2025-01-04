i = 1
fact = 1
s = 0
while(i<10):
    fact = fact * i
    s = s + i
    i += 1

def largest(num):
    c = []
    i = 0
    while(i < len(num)):
        c.append(int(num[i]))
        i += 1
    return f"largest number {num} is {max(c)}"
    
a = input("Enter a num: ")

print(f"{a} has {len(a)} digits")
print(f"factorial of 10 = {fact}")
print(f"sum of 10 natural numbers = {s}")
print(largest(a))