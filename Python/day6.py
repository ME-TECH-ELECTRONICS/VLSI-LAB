"""
find largest number without suing max() function
"""
val = list(eval(input("Enter sequence: ")))
large = 0
index = 0
for i, item in enumerate(val):
    if item > large:
        large = item
        index = i
print(f"largest number in list {val} is {large} with index {index}")


"""
print element of a list if a number is encounterd then print it 3times (313131)
if it is a string the terminated with # (hello#)
"""

inp = [41,"Hello",31,"world"]
for i in inp:
    if type(i) == int:
        print(str(i)*3)
    else:
        print(f"{i}#")
        

"""
program to fatten a list of tuple, find largest element
 input: [(1,2),(3,4),(5,6)]
 
"""
va = [(1,2),(3,4),(5,6)]
vd = []
large = 0
for item in va:
    for j in range(len(item)):
        vd.append(item[j])
        if item[j] > large:
            large = item[j]
vs = tuple(vd)

print(f"{vs} largest: {large}")


"""
make a tuple comprehension with squares of numbers from 1 - 10
"""
vm = (i*i for i in range(1,11))
print(tuple(vm))

"""
Predict output

"""

ntpl = ("Hello", "Nita", "How's", "life?")
(a,b,c,d) = ntpl
print(a,b,c,d)
ntpl = (a,b,c,d)
print(ntpl[0][0] + ntpl[1][1], " ", ntpl[1])