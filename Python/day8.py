import math
from time import sleep
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

try:
    while True:
        print("1. Calculate the area of circle")
        print("2. Calculate the area of rectangle")
        print("Press enter Exit program")
        option: int = int(input("Choose an option: "))
        if(option == 1):
            rad: float = float(input("Enter the radius: "))
            print(f"Area of circle of radius {rad} is {calcCircleArea(rad)}")
        elif option == 2:
            length: float = float(input("Enter the length: "))
            breadth: float = float(input("Enter the breadth: "))
            print(f"Area of circle of radius {rad} is {calcRectArea(length, breadth)}")
        else:
            print("Terminating program...")
            sleep(3)
            exit()
        choice: str = input("Do you want to continue calculation [y/N]: ").lower()
        if(choice == "y"):
            pass
        else:
            break
except KeyboardInterrupt:
        print("\nSIGINT received. Quitting...")
        sleep(3)
        exit()
            
