from bank import *
from time import sleep

try:
    while True:
        print("1. Depost money")
        print("2. Withdraw money")
        print("3. show balance")
        print("0. cancel")
        option: int = int(input("Choose an option: "))
        if(option == 1):
            money: float = float(input("Enter the money to deposit: "))
            print(deposit(money))
        elif option == 2:
            money: float = float(input("Enter the money to withdraw: "))
            print(withdraw(money))
        elif option == 3:
            print(f"Your balance is ₹{balance}")
        else:
            print("Terminating program...")
            sleep(3)
            exit()
except KeyboardInterrupt:
        print("\nSIGINT received. Quitting...")
        sleep(3)
        exit()