import math

def calcCircleArea(radius: float) -> float:
    if not radius:
        return 0.0
    else:
        return math.pi * radius * radius

def calcRectArea(length: float, breadth: float) -> float:
    if not (length or breadth):
        return 0.0
    else:
        return length * breadth

def calcSquareArea(side: float) -> float:
    if not (side):
        return 0.0
    else:
        return side ** 2

