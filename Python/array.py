"""
    create a user input list find the largest number and its index
"""
val = input("Enter sequence")
temp = [int(i) for i in val.split(",")]
num = max(temp)
index = temp.index(num)
print(f"largest number {num} in the list with index {index}")


"""
     Add 2 corresponding index elements from 2 arrays
"""
l = [36,72,8]
m = [2,3,5]
result = []
for i in range(3):
    result.append(l[i] + m[i])
print(result)


"""
    Find the largest word in the sentence
"""
string = "This is a paragrapgh with long sentence"
v = string.split(" ")
c = [len(v[i]) for i in range(len(v))]
d = c.index(max(c))
print(v[d])



"""
    Remove duplicates from the array
"""
first = [1, 36, 2, 90, 67, 3, 7, 8, 9]
second = [1, 2, 3, 4, 5, 6, 7, 8, 9]

second.extend(first)
result = []
for i in second:
    if i not in result:
        result.append(i)

print(result)
