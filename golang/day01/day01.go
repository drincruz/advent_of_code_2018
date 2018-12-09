package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"strconv"
)

// We want to add or subtract integers from an array. We will start from zero.
func main() {
	file, err := os.Open("day01.txt")
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()
	var lines []string
	var nums []int
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		lines = append(lines, scanner.Text())
	}

	for _, i := range lines {
		j, err := strconv.Atoi(i)
		if err != nil {
			log.Fatal(err)
		}
		nums = append(nums, j)
	}

	sum := 0
	for _, n := range nums {
		sum += n
	}
	fmt.Printf("Final frequency %d\n", sum)

	// Part 2: find the first repeated value
	frequency := 0
	var frequencies = make(map[int]int)
	isFound := false
	for {
	Start:
		for _, n := range nums {
			frequency += n
			count := frequencies[frequency] + 1
			if count == 2 {
				fmt.Printf("First frequency to repeat %d\n", frequency)
				isFound = true
				goto End
			}
			frequencies[frequency] = count
		}
	End:
		if isFound {
			break
		}
		goto Start
	}
}
