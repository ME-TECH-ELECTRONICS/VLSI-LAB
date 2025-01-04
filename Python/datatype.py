datatypes = [5,4.5,3+4j,5<6,None,"mn",(2,6,"a"),[2,5,6],{"a":5, "t":"gg"}]

for i in datatypes:
    print(f"'{i}' is ",type(i))
    
def summer(a, b):
    result = a + b
    
c = summer(2, 6)
print("val of c ",c)

