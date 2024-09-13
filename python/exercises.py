from dataclasses import dataclass
from collections.abc import Callable


def change(amount: int) -> dict[int, int]:
    if not isinstance(amount, int):
        raise TypeError('Amount must be an integer')
    if amount < 0:
        raise ValueError('Amount cannot be negative')
    counts, remaining = {}, amount
    for denomination in (25, 10, 5, 1):
        counts[denomination], remaining = divmod(remaining, denomination)
    return counts


# Write your first then lower case function here

def first_then_lower_case(strings, predicate, /):
    for string in strings:
        if predicate(string):
            return string.lower()
    return None


# Write your powers generator here

def powers_generator(*, base, limit):
    power = 0
    result = 1 # 0 power always yields 1
    while result <= limit:
        yield result
        power += 1
        result = base ** power

# Write your say function here

def say(word=None, /):
    if word == None:
        return ""
    def chain(next_word=None):
        if next_word == None:
            return word
        return say(f"{word} {next_word}")
    return chain


# Write your line count function here

def meaningful_line_count(filename):
    count = 0
    try:
        with open(filename, 'r') as file:
            lines = file.readlines()
            for line in lines:
                if line.strip() and not line.lstrip().startswith('#'):
                    count += 1
        return count
    except FileNotFoundError as error:
        raise error


# Write your Quaternion class here

@dataclass(frozen=True)
class Quaternion:
    a: float  
    b: float  
    c: float  
    d: float  

    # requires positional arguments
    def __init__(self, a: float, b: float, c: float, d: float, /):
        object.__setattr__(self, 'a', a)
        object.__setattr__(self, 'b', b)
        object.__setattr__(self, 'c', c)
        object.__setattr__(self, 'd', d)

    # adds quarternions
    def __add__(self, other):
        if isinstance(other, Quaternion):
            return Quaternion(
                self.a + other.a,
                self.b + other.b,
                self.c + other.c,
                self.d + other.d
            )

    # multiplies quarternions
    def __mul__(self, other):
        if isinstance(other, Quaternion):
            a = self.a * other.a - self.b * other.b - self.c * other.c - self.d * other.d
            b = self.a * other.b + self.b * other.a + self.c * other.d - self.d * other.c
            c = self.a * other.c - self.b * other.d + self.c * other.a + self.d * other.b
            d = self.a * other.d + self.b * other.c - self.c * other.b + self.d * other.a
            return Quaternion(a, b, c, d)

    # checks if quarternions are equal
    def __eq__(self, other):
        if isinstance(other, Quaternion):
            return (self.a == other.a and self.b == other.b and 
                    self.c == other.c and self.d == other.d)

    # returns the conjugate of the quaternion
    @property
    def conjugate(self):
        return Quaternion(self.a, -self.b, -self.c, -self.d)

    # returns the coefficients of the quaternion as a tuple.
    @property
    def coefficients(self):
        return (self.a, self.b, self.c, self.d)

    # turns results into readable code
    def __str__(self):
        result = ''
        symbols = ['', 'i', 'j', 'k']  
        components = [self.a, self.b, self.c, self.d] 

        for idx, value in enumerate(components):
            if value != 0: 
                if value > 0 and result:
                    result += '+'
                elif value < 0:
                    result += '-'

                abs_value = abs(value)
                if abs_value != 1 or idx == 0:
                    result += str(abs_value)

                result += symbols[idx]

        return result or '0'  