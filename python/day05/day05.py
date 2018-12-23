#!/usr/bin/env python
"""
Day 05.

Part 1: Given a string, find character complements, remove them, and return the length
of the string.
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

with open('day05.txt') as f:
    polymer = f.readline().strip()

print(parse_str(polymer))
