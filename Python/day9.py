class Employee:
    company_name = "Infosys"
    
    def __init__(self):
        self.name = "vikas"
        self.age = 56
    
    def display(self):
        print(f"Name: {self.name}, Age: {self.age}")
    
    @classmethod
    def get_company_name(cls):
        print(f"Company name: {cls.company_name}")
        cls.company_name = "Vipro"
        print(f"Company name: {cls.company_name}")
"""
em = Employee()
em.display()
print(Employee.company_name)
Employee.company_name = "TCS"
print(Employee.company_name)
Employee.get_company_name()
"""

class Computer:
    cpu_clock = 28e8
    ram = 32e8        
    ssd = 2e12         
    
    def __init__(self):
        print("I am computer")
    
class Mobile(Computer):
    def __init__(self):
        super().__init__()
        self.cpu_clock = Computer.cpu_clock / 2 
        self.ram = Computer.ram / 8             
        self.ssd = Computer.ssd / 16           
        
    def display(self):
        print(f"I am mobile. My clock speed is {self.cpu_clock/1e9:.1f} GHz, I have {self.ram/1e8:.0f} GB of RAM, also my storage capacity is {self.ssd/1e9:.0f} GB")

mob = Mobile()
mob.display()

from abc import ABC, abstractmethod
class User(ABC):
    password = 0
    username = ""
    __screct_key = 10101010
    
    @abstractmethod
    def getusername(self):
        pass
    
    def __get_screct_key(self):        return self.__screct_key

class Login(User):
    def __init__(self):
        super().__init__()
        self.key = super()._User__get_screct_key()
        self.pwd = 0

    def user_login(self, username, password):
        self.username = username
        self.password = password
        if self.username and self.password:
            self.pwd = self.password ^ self.key
            return f"Username: {self.username}, Hashed password: {self.pwd}"
    def getusername(self):
        print(self.username)
        
l = Login()
print(l.user_login("test", 12345678))
print(l.pwd ^ 10101010)