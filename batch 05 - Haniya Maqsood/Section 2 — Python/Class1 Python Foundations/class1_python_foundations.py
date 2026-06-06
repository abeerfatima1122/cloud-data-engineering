# ============================================================
#   CLASS 1 — PYTHON FOUNDATIONS  (3 Hours)
#   Beginner Level | No prior experience needed
# ============================================================
#
#   TOPICS COVERED:
#     1. What is Python & how to run it
#     2. print() — showing output on screen
#     3. Variables & Data Types
#     4. Arithmetic (Math) Operations
#     5. Type Conversion
#     6. Getting Input from the User
#     7. Making Decisions — if / elif / else
#     8. Repeating Things — for loops
#     9. while loops
#    10. Functions
#    11. Lists (intro)
#
# ============================================================


# ─────────────────────────────────────────────
# SECTION 1 — WHAT IS PYTHON?
# ─────────────────────────────────────────────
# Python is a programming language.
# It lets us give instructions to the computer.
# A line that starts with '#' is a COMMENT — Python ignores it.
# Comments are notes for humans reading the code.


# ─────────────────────────────────────────────
# SECTION 2 — print()
# ─────────────────────────────────────────────
# print() displays something on the screen.
# Whatever you put inside the brackets appears as output.

print("Hello, World!")          # classic first program
print("Welcome to Python!")
print(100)                      # you can also print numbers
print(3.14)                     # and decimal numbers


# ─────────────────────────────────────────────
# SECTION 3 — VARIABLES & DATA TYPES
# ─────────────────────────────────────────────
# A variable is a container that stores a value.
# You give it a name, then use = to put something inside.

# --- Integers (whole numbers) ---
age = 20
year = 2024

# --- Floats (decimal / fraction numbers) ---
price = 49.99
temperature = 36.5

# --- Strings (text — always inside quotes) ---
name = "Ali"
city = "Karachi"

# --- Booleans (only two possible values: True or False) ---
is_student = True
has_graduated = False

# Printing variables
print(name)           # shows: Ali
print(age)            # shows: 20
print(price)          # shows: 49.99
print(is_student)     # shows: True

# You can print multiple things at once using commas
print("Name:", name, "| Age:", age)


# ─────────────────────────────────────────────
# SECTION 4 — ARITHMETIC OPERATIONS
# ─────────────────────────────────────────────
# Python can do math just like a calculator.

a = 10
b = 3

print(a + b)    # Addition        → 13
print(a - b)    # Subtraction     → 7
print(a * b)    # Multiplication  → 30
print(a / b)    # Division        → 3.333...
print(a // b)   # Floor Division  → 3  (no decimal, rounded down)
print(a % b)    # Modulus         → 1  (remainder after division)
print(a ** b)   # Exponent        → 1000  (10 to the power of 3)

# Storing math results in a variable
total = 100 + 250
discount = total * 0.10           # 10% discount
final_price = total - discount

print("Total:", total)
print("Discount:", discount)
print("Final Price:", final_price)


# ─────────────────────────────────────────────
# SECTION 5 — TYPE CONVERSION
# ─────────────────────────────────────────────
# Sometimes you need to change a value from one type to another.

num_str = "42"          # this is TEXT, not a number yet
num_int = int(num_str)  # convert text "42" → integer 42
num_flt = float("3.7")  # convert text "3.7" → float 3.7
back_str = str(100)     # convert integer 100 → text "100"

print(num_int + 8)      # now you can do math: 42 + 8 = 50
print(type(num_str))    # <class 'str'>
print(type(num_int))    # <class 'int'>


# ─────────────────────────────────────────────
# SECTION 6 — GETTING INPUT FROM THE USER
# ─────────────────────────────────────────────
# input() pauses the program and waits for the user to type something.
# Whatever the user types is ALWAYS a string (text).

# --- Example 1: simple greeting ---
user_name = input("Enter your name: ")
print("Hello,", user_name + "!")

# --- Example 2: doing math with user input ---
# We must convert to int because input() gives us text
num1 = int(input("Enter first number: "))
num2 = int(input("Enter second number: "))
print("Sum:", num1 + num2)


# ─────────────────────────────────────────────
# SECTION 7 — if / elif / else (Making Decisions)
# ─────────────────────────────────────────────
# if lets the program choose what to do based on a condition.
# A condition is something that is either True or False.
#
# Comparison operators:
#   ==   equal to
#   !=   not equal to
#   >    greater than
#   <    less than
#   >=   greater than or equal to
#   <=   less than or equal to

marks = 75

if marks >= 90:
    print("Grade: A")           # runs if marks is 90 or above
elif marks >= 75:
    print("Grade: B")           # runs if marks is 75–89
elif marks >= 60:
    print("Grade: C")           # runs if marks is 60–74
else:
    print("Grade: F")           # runs if none of the above matched

# --- Example: even or odd ---
number = 7

if number % 2 == 0:
    print(number, "is Even")
else:
    print(number, "is Odd")

# --- Example: voting eligibility ---
age = 17

if age >= 18:
    print("You can vote.")
else:
    print("You are too young to vote.")


# ─────────────────────────────────────────────
# SECTION 8 — for LOOPS
# ─────────────────────────────────────────────
# A loop repeats a block of code multiple times.
# for loop is used when you know HOW MANY times to repeat.

# --- Counting 1 to 5 ---
for i in range(1, 6):       # range(1, 6) gives: 1, 2, 3, 4, 5
    print(i)

# --- Loop through a list of items ---
fruits = ["apple", "banana", "mango", "orange"]

for fruit in fruits:
    print("Fruit:", fruit)

# --- Multiplication table ---
n = 5
for i in range(1, 11):
    print(n, "x", i, "=", n * i)


# ─────────────────────────────────────────────
# SECTION 9 — while LOOPS
# ─────────────────────────────────────────────
# while loop keeps running AS LONG AS a condition is True.
# Use it when you DON'T know exactly how many times to repeat.

# --- Countdown ---
count = 5
while count > 0:
    print("Count:", count)
    count = count - 1       # decrease count by 1 each time
print("Go!")

# --- Keep asking until correct password ---
password = "python123"

entered = input("Enter the password: ")
while entered != password:
    print("Wrong! Try again.")
    entered = input("Enter the password: ")
print("Access granted!")


# ─────────────────────────────────────────────
# SECTION 10 — FUNCTIONS
# ─────────────────────────────────────────────
# A function is a reusable block of code with a name.
# Instead of writing the same code over and over, put it in a function.
# Use 'def' to define (create) a function.
# Use the function name followed by () to call (run) it.

# --- Simple function with no inputs ---
def greet():
    print("Hello! Welcome to Python class.")

greet()     # calling the function — output: Hello! Welcome to Python class.
greet()     # call it again any time

# --- Function with parameters (inputs) ---
def greet_person(name):
    print("Hello,", name + "! Good to see you.")

greet_person("Sara")
greet_person("Ahmed")

# --- Function that returns a value ---
def add(x, y):
    result = x + y
    return result           # 'return' sends the answer back

answer = add(10, 20)        # store the returned value
print("Sum:", answer)       # 30

# --- Practical function: calculate discount ---
def calculate_discount(original_price, discount_percent):
    discount_amount = original_price * (discount_percent / 100)
    final = original_price - discount_amount
    return final

price_after_discount = calculate_discount(500, 20)   # 20% off Rs. 500
print("Price after discount: Rs.", price_after_discount)


# ─────────────────────────────────────────────
# SECTION 11 — LISTS (Introduction)
# ─────────────────────────────────────────────
# A list stores MULTIPLE values in one variable.
# Items are written inside square brackets [ ].
# Items are separated by commas.
# Each item has an INDEX (position) starting at 0.

students = ["Ali", "Sara", "Ahmed", "Zara"]

# Accessing items by index
print(students[0])      # Ali   (first item = index 0)
print(students[1])      # Sara  (second item = index 1)
print(students[-1])     # Zara  (last item)

# Changing an item
students[2] = "Bilal"   # replace "Ahmed" with "Bilal"
print(students)

# Adding items
students.append("Omar")    # adds to the end
print(students)

# Removing items
students.remove("Sara")    # removes "Sara"
print(students)

# Length of a list
print("Total students:", len(students))

# Loop through a list
for student in students:
    print("Student:", student)

# --- Numbers list + math ---
scores = [85, 92, 78, 90, 88]
print("Highest score:", max(scores))
print("Lowest score:", min(scores))
print("Total:", sum(scores))
print("Average:", sum(scores) / len(scores))


# ============================================================
#   END OF CLASS 1
#   Practice Exercises (try on your own):
#
#   1. Create variables for your name, age, and city.
#      Print them in one sentence using print().
#
#   2. Ask the user for two numbers and print their
#      product (multiplication).
#
#   3. Write a program that asks for a temperature in Celsius
#      and converts it to Fahrenheit.
#      Formula: F = (C × 9/5) + 32
#
#   4. Write a function called is_even(n) that returns True
#      if n is even, False if it is odd.
#
#   5. Create a list of 5 of your favourite foods.
#      Loop through it and print each one.
# ============================================================
