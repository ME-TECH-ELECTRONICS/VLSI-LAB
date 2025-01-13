
#### 1. Make a dictionary

d = {}
for i in range(1,16):
    d[i] = i*i

print(d)


#### 2. Merge 2 dictionary

d1 = {"a": "apple", "b": "ball", "c": "cat"}
d2 = {"d": "dog", "e": "egg"}

d2.update(d1)
print(d2)


#### 3. Sort dictionary

d3 = dict(sorted(d2.items()))
d4 = dict(sorted(d2.items(),reverse=True))
print("Sorted: ", d3, "\nReverse: ", d4)

##### 4. Count charaters in a string and make a dictionary
string = "google.com"
di = {}
for i in string:
    if i in di:
        di[i] += 1
    else:
        di[i] = 1
print(di)


#### 5. add same key values to make new dictionary
d5 = {"a": 100, "b": 200, "c": 300}
d6 = {"a": 300, "b": 200, "d": 400}
result = d5.copy()
for key, val in d6.items():
    if key in result:
        result[key] += val
    else:
        result[key] = val

print(result)