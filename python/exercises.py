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
