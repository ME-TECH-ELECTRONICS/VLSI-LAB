balance = 1000

def deposit(amt: float) -> str:
    global balance
    balance += amt
    return "Deposited sucessfully"

def withdraw(amt: float) -> str:
    global balance
    if amt > balance:
        return "Insufficient balance"
    else:
        balance -= amt
        return "withdraw sucessfully"
