#!/usr/bin/env python
"""
Day 01.

Part 1: Calculating the frequency from a list of integers that change the
frequency.
"""

with open('day01.txt') as f:
    read_data = f.readlines()
    frequency = 0
    for line in read_data:
        frequency += int(line.strip())
print(frequency)
