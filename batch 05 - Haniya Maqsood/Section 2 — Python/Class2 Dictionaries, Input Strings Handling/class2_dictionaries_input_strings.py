# ============================================================
#   CLASS 2 — DICTIONARIES, INPUT & STRING HANDLING (3 Hours)
#   Beginner Level | Builds on Class 1
# ============================================================
#
#   TOPICS COVERED:
#     1. Strings in depth — indexing & slicing
#     2. Useful String Methods
#     3. String Formatting (f-strings)
#     4. User Input — advanced patterns
#     5. Dictionaries — creating & accessing
#     6. Dictionary Operations (add, update, delete)
#     7. Looping through Dictionaries
#     8. Nested Dictionaries
#     9. Mini Project — Student Record System
#    10. Mini Project — Simple Menu App
#
# ============================================================


# ─────────────────────────────────────────────
# SECTION 1 — STRINGS IN DEPTH
# ─────────────────────────────────────────────
# A string is a sequence of characters (letters, numbers, symbols).
# Each character has an index (position), starting at 0.

word = "Python"

#         P  y  t  h  o  n
# index:  0  1  2  3  4  5

print(word[0])      # P  — first character
print(word[1])      # y
print(word[-1])     # n  — last character  (negative = count from end)
print(word[-2])     # o  — second from end

# --- Slicing: grab a portion of a string ---
# Syntax: string[start : end]
# 'end' index is NOT included (it stops just before it)

message = "Hello, World!"

print(message[0:5])     # Hello    (index 0, 1, 2, 3, 4)
print(message[7:12])    # World
print(message[:5])      # Hello    (start from beginning)
print(message[7:])      # World!   (go till the end)
print(message[::-1])    # !dlroW ,olleH  (reverse the string!)

# --- Length of a string ---
name = "Karachi"
print(len(name))        # 7 — number of characters


# ─────────────────────────────────────────────
# SECTION 2 — USEFUL STRING METHODS
# ─────────────────────────────────────────────
# Methods are built-in actions you can perform on a string.
# You call them with a dot: string.method()

text = "  Hello, Python World!  "

# --- Changing case ---
print(text.upper())         # ALL CAPS
print(text.lower())         # all lowercase
print(text.title())         # First Letter Of Each Word Capitalised
print(text.capitalize())    # Only first letter of the whole string

# --- Removing extra spaces ---
print(text.strip())         # removes spaces from both ends
print(text.lstrip())        # removes spaces from the left only
print(text.rstrip())        # removes spaces from the right only

# --- Searching inside a string ---
sentence = "Python is great and Python is fun"

print(sentence.count("Python"))     # 2  — how many times "Python" appears
print(sentence.find("great"))       # 10 — index where "great" starts
print(sentence.find("Java"))        # -1 — not found, returns -1

# --- Checking what a string starts/ends with ---
filename = "report_2024.pdf"

print(filename.startswith("report"))    # True
print(filename.endswith(".pdf"))        # True
print(filename.endswith(".docx"))       # False

# --- Replacing text ---
original = "I love Java programming"
updated = original.replace("Java", "Python")
print(updated)      # I love Python programming

# --- Splitting a string into a list ---
csv_data = "Ali,Sara,Ahmed,Zara"
names = csv_data.split(",")     # split wherever there is a comma
print(names)        # ['Ali', 'Sara', 'Ahmed', 'Zara']

# --- Joining a list into a string ---
words = ["Python", "is", "awesome"]
joined = " ".join(words)        # put a space between each item
print(joined)       # Python is awesome

# --- Checking string contents ---
print("hello".isalpha())        # True — all letters
print("12345".isnumeric())      # True — all numbers
print("hello123".isalnum())     # True — letters and numbers only
print("  ".isspace())           # True — only whitespace


# ─────────────────────────────────────────────
# SECTION 3 — STRING FORMATTING (f-strings)
# ─────────────────────────────────────────────
# f-strings (formatted strings) let you embed variables
# directly inside a string.  Put f before the quote,
# then use { } around any variable or expression.

name = "Ali"
age = 22
city = "Karachi"

# Old way (using commas in print) — works but basic
print("Name:", name, "Age:", age)

# Better way — f-string
print(f"Name: {name} | Age: {age} | City: {city}")

# You can put expressions (calculations) inside { }
price = 1500
quantity = 3
print(f"Total cost: Rs. {price * quantity}")

# Controlling decimal places using :.2f
pi = 3.14159265
print(f"Pi rounded to 2 decimals: {pi:.2f}")    # 3.14

average = 87.5678
print(f"Average: {average:.1f}%")               # 87.6%

# Practical receipt example
item = "Notebook"
unit_price = 120
qty = 5
total = unit_price * qty
print(f"Item: {item}  |  Unit Price: Rs.{unit_price}  |  Qty: {qty}  |  Total: Rs.{total}")


# ─────────────────────────────────────────────
# SECTION 4 — USER INPUT — ADVANCED PATTERNS
# ─────────────────────────────────────────────
# Remember: input() always returns a STRING.
# You must convert it if you need a number.

# --- Safe integer input ---
age = int(input("Enter your age: "))
print(f"You are {age} years old.")
print(f"In 10 years you will be {age + 10}.")

# --- Multiple inputs on one line (split by space) ---
# Example: user types  "10 20" and we split it
numbers = input("Enter two numbers separated by space: ").split()
x = int(numbers[0])
y = int(numbers[1])
print(f"{x} + {y} = {x + y}")

# --- Input with a menu choice ---
print("Choose a shape:")
print("1. Circle")
print("2. Rectangle")

choice = input("Enter 1 or 2: ")

if choice == "1":
    radius = float(input("Enter radius: "))
    area = 3.14159 * radius ** 2
    print(f"Area of Circle: {area:.2f}")
elif choice == "2":
    length = float(input("Enter length: "))
    width  = float(input("Enter width: "))
    area = length * width
    print(f"Area of Rectangle: {area:.2f}")
else:
    print("Invalid choice.")


# ─────────────────────────────────────────────
# SECTION 5 — DICTIONARIES (Creating & Accessing)
# ─────────────────────────────────────────────
# A dictionary stores data as KEY : VALUE pairs.
# Think of it like a real dictionary:
#   word  (key)  →  meaning (value)
#
# Keys are usually strings.  Values can be anything.
# Dictionaries use curly brackets { }.
#
# Syntax:
#   my_dict = { "key1": value1, "key2": value2 }
#
# Access a value using:  my_dict["key"]

# --- Creating a dictionary ---
student = {
    "name": "Ali",
    "age": 20,
    "city": "Karachi",
    "marks": 88.5,
    "passed": True
}

# --- Accessing values ---
print(student["name"])      # Ali
print(student["marks"])     # 88.5
print(student["city"])      # Karachi

# --- Using .get() — safer way to access ---
# If the key doesn't exist, .get() returns None instead of an error
print(student.get("age"))           # 20
print(student.get("email"))         # None (key doesn't exist)
print(student.get("email", "N/A"))  # N/A (custom default value)

# --- Checking if a key exists ---
if "name" in student:
    print("Name is available:", student["name"])

if "phone" not in student:
    print("Phone number not found.")

# --- Printing with f-string ---
print(f"Student: {student['name']} | Age: {student['age']} | Marks: {student['marks']}")


# ─────────────────────────────────────────────
# SECTION 6 — DICTIONARY OPERATIONS
# ─────────────────────────────────────────────

profile = {
    "username": "sara_k",
    "email": "sara@example.com",
    "score": 150
}

# --- Adding a new key ---
profile["level"] = "Gold"
print(profile)

# --- Updating an existing value ---
profile["score"] = 200          # direct assignment
profile.update({"email": "sara_new@example.com", "level": "Platinum"})
print(profile)

# --- Deleting a key ---
del profile["level"]            # removes the key completely
print(profile)

removed = profile.pop("score")  # removes AND returns the value
print("Removed score:", removed)
print(profile)

# --- Useful dictionary info ---
print(len(profile))             # number of key-value pairs

# All keys
print(profile.keys())           # dict_keys(['username', 'email'])

# All values
print(profile.values())         # dict_values(['sara_k', 'sara_new@...'])

# All key-value pairs together
print(profile.items())          # dict_items([...])

# --- Clearing all data ---
temp = {"a": 1, "b": 2}
temp.clear()
print(temp)     # {}  — empty dictionary


# ─────────────────────────────────────────────
# SECTION 7 — LOOPING THROUGH DICTIONARIES
# ─────────────────────────────────────────────

inventory = {
    "apples": 50,
    "bananas": 30,
    "mangoes": 20,
    "oranges": 45
}

# --- Loop through keys only ---
print("--- Items in inventory ---")
for item in inventory:
    print(item)

# --- Loop through keys, then access value ---
print("--- Stock levels ---")
for item in inventory:
    print(f"{item}: {inventory[item]} units")

# --- Loop through values only ---
print("--- Quantities ---")
for qty in inventory.values():
    print(qty)

# --- Loop through key AND value at the same time ---
# .items() gives you both together
print("--- Full inventory list ---")
for item, qty in inventory.items():
    print(f"{item.capitalize()}: {qty} units")

# --- Practical: check low stock ---
print("--- Low Stock Warning (<= 25 units) ---")
for item, qty in inventory.items():
    if qty <= 25:
        print(f"⚠ {item} is low: only {qty} left")


# ─────────────────────────────────────────────
# SECTION 8 — NESTED DICTIONARIES
# ─────────────────────────────────────────────
# A dictionary can contain another dictionary as its value.
# This lets you group related information.

# --- Dictionary of students ---
classroom = {
    "student1": {
        "name": "Ali",
        "age": 20,
        "grade": "A"
    },
    "student2": {
        "name": "Sara",
        "age": 19,
        "grade": "B+"
    },
    "student3": {
        "name": "Ahmed",
        "age": 21,
        "grade": "A-"
    }
}

# --- Accessing nested data ---
# Outer key first, then inner key
print(classroom["student1"]["name"])    # Ali
print(classroom["student2"]["grade"])   # B+

# --- Looping through nested dictionary ---
print("--- Class Report ---")
for student_id, info in classroom.items():
    print(f"{student_id}: {info['name']} | Age: {info['age']} | Grade: {info['grade']}")


# ─────────────────────────────────────────────
# SECTION 9 — MINI PROJECT: Student Record System
# ─────────────────────────────────────────────
# Let the user enter details for a student,
# store them in a dictionary, then display a report.

print("\n============================")
print("   STUDENT RECORD SYSTEM   ")
print("============================")

# Collecting info
student_name   = input("Enter student name: ")
student_roll   = input("Enter roll number: ")
student_math   = float(input("Enter Math marks (out of 100): "))
student_eng    = float(input("Enter English marks (out of 100): "))
student_sci    = float(input("Enter Science marks (out of 100): "))

# Storing in a dictionary
record = {
    "name":    student_name,
    "roll":    student_roll,
    "math":    student_math,
    "english": student_eng,
    "science": student_sci
}

# Calculating total and average
total   = record["math"] + record["english"] + record["science"]
average = total / 3

# Assigning a grade
if average >= 90:
    grade = "A"
elif average >= 75:
    grade = "B"
elif average >= 60:
    grade = "C"
elif average >= 50:
    grade = "D"
else:
    grade = "F"

# Storing results back in the same dictionary
record["total"]   = total
record["average"] = round(average, 2)
record["grade"]   = grade

# Displaying the report card
print("\n------------------------------")
print("        REPORT CARD          ")
print("------------------------------")
print(f"Name        : {record['name']}")
print(f"Roll No.    : {record['roll']}")
print(f"Math        : {record['math']}")
print(f"English     : {record['english']}")
print(f"Science     : {record['science']}")
print(f"Total       : {record['total']} / 300")
print(f"Average     : {record['average']}%")
print(f"Grade       : {record['grade']}")
print("------------------------------")


# ─────────────────────────────────────────────
# SECTION 10 — MINI PROJECT: Simple Menu App
# ─────────────────────────────────────────────
# A looping menu that keeps running until the user exits.
# Uses a dictionary to store a small contact book.

contacts = {}   # start with an empty dictionary

print("\n============================")
print("     CONTACT BOOK APP      ")
print("============================")

# Keep showing the menu until the user chooses to quit
running = True
while running:
    print("\nMenu:")
    print("1. Add Contact")
    print("2. View All Contacts")
    print("3. Search Contact")
    print("4. Delete Contact")
    print("5. Exit")

    choice = input("Choose an option (1-5): ")

    # --- Option 1: Add a new contact ---
    if choice == "1":
        c_name  = input("Enter name: ").strip()
        c_phone = input("Enter phone number: ").strip()
        contacts[c_name] = c_phone      # name = key, phone = value
        print(f"✔ Contact '{c_name}' added.")

    # --- Option 2: Show all contacts ---
    elif choice == "2":
        if len(contacts) == 0:
            print("No contacts yet.")
        else:
            print("\n--- Your Contacts ---")
            for person, phone in contacts.items():
                print(f"  {person}: {phone}")

    # --- Option 3: Search for a contact ---
    elif choice == "3":
        search = input("Enter name to search: ").strip()
        if search in contacts:
            print(f"Found! {search}: {contacts[search]}")
        else:
            print(f"'{search}' not found in contacts.")

    # --- Option 4: Delete a contact ---
    elif choice == "4":
        delete = input("Enter name to delete: ").strip()
        if delete in contacts:
            del contacts[delete]
            print(f"✔ '{delete}' has been deleted.")
        else:
            print(f"'{delete}' not found.")

    # --- Option 5: Exit ---
    elif choice == "5":
        print("Goodbye! 👋")
        running = False     # this stops the while loop

    else:
        print("Invalid choice. Please enter a number between 1 and 5.")


# ============================================================
#   END OF CLASS 2
#   Practice Exercises (try on your own):
#
#   1. Ask the user to enter a sentence.
#      Count how many vowels (a, e, i, o, u) it contains.
#      Hint: loop through each character and check if it's a vowel.
#
#   2. Create a dictionary of 5 countries and their capitals.
#      Let the user type a country name; print its capital.
#      If the country is not found, print "Not in our database."
#
#   3. Ask the user to enter their full name.
#      Print: first name, last name, total characters, and
#      the name in UPPERCASE.
#
#   4. Build a simple shopping cart:
#      - Use a dictionary (item name → price).
#      - Keep adding items until the user types "done".
#      - At the end, print an itemised bill and the grand total.
#
#   5. CHALLENGE — Word frequency counter:
#      Ask the user to enter a sentence.
#      Count how many times each word appears.
#      Store the counts in a dictionary and print the results.
#      Example: "the cat sat on the mat"
#               → {"the": 2, "cat": 1, "sat": 1, "on": 1, "mat": 1}
# ============================================================
