from area import *

while True:
        print("1. Calculate the area of circle")
        print("2. Calculate the area of rectangle")
        print("2. Calculate the area of square")
        print("Press enter Exit program")
        option: int = int(input("Choose an option: "))
        if(option == 1):
            rad: float = float(input("Enter the radius: "))
            print(f"Area of circle of radius {rad} is {calcCircleArea(rad)}")
        elif option == 2:
            length: float = float(input("Enter the length: "))
            breadth: float = float(input("Enter the breadth: "))
            print(f"Area of rectangle of length {length}, breadth {breadth} is {calcRectArea(length, breadth)}")
        elif option == 3:
            side: float = float(input("Enter the side: "))
            print(f"Area of square of side {side} is {calcSquareArea(side)}") 
        else:
            print("Terminating program...")
            sleep(3)
            exit()
        choice: str = input("Do you want to continue calculation [y/N]: ").lower()
        if(choice == "y"):
            pass
        else:
            break
