#!/usr/bin/env python
"""
Day 05.

Part 1: Given a string, find character complements, remove them, and return the length
of the string.
Part 2: Remove one single character pair, clean up the string based off of the negative
polarity concept, and find the shortest string length.
"""

def complement(char):
    if char.upper() == char:
        return char.lower()
    return char.upper()

def parse_str(str):
    begin, end = 0, len(str) - 1
    while begin < end:
        cur_char = str[begin]
        updated = str.replace(cur_char + complement(cur_char), '')
        if len(str) == len(updated):
            begin += 1
        elif begin == end:
            return (str, len(str))
        else:
            begin = 0
            end = len(updated) - 1
            str = updated
    return (str, len(str))

 # TODO OPTIMIZE ME
def clean_str(str):
    beg, end = 0, len(str) - 1
    next = beg + 1
    while next < end:
        if str[next] == complement(str[beg]):
            str = str[:beg] + str[next + 1:]
            beg = 0
            next = beg + 1
            end = len(str)
        else:
            beg += 1
            next += 1
            end = len(str)
    return str


def part2(str):
    """
    Process only the characters once in the input string, remove them, and clean up
    the remaining to get the string length.
    """
    char_count = {}
    char_set = {char.lower() for char in str}
    for char in char_set:
        updated_str = clean_str(str.replace(char, '').replace(complement(char), ''))
        char_count[char] = len(updated_str)
    return char_count

with open('day05.txt') as f:
    polymer = f.readline().strip()

print(parse_str(polymer))

print(part2(polymer))
