import lib

import std/re
import std/algorithm
import std/strformat
import std/strutils
import std/tables
import std/sequtils

#let mazeRegex = re(r"(...) = \((...), (...)\)")
let mazeRegex = re(r"^(.)")

proc part1() =
  let infile = open("data/day08.txt")
  defer: infile.close()

  let directions = infile.readLine()
  discard infile.readLine()

  var maze: Table[string, (string, string)]
  for line in infile.lines():
    let key = line[0..<3]
    let left = line[7..<10]
    let right = line[12..<15]
    maze[key] = (left, right)

  var here = "AAA"
  var steps = 0
  var i = 0
  while here != "ZZZ":
    let c = directions[i]

    if c == 'L':
      here = maze[here][0]
    else:
      here = maze[here][1]

    steps += 1
    i += 1
    if i >= directions.len():
      i = 0
  echo(steps)


proc part2() =
  let infile = open("data/day08.txt")
  defer: infile.close()

  let directions = infile.readLine()
  discard infile.readLine()

  var nodes: seq[string] = @[]
  var maze: Table[string, (string, string)]
  for line in infile.lines():
    let key = line[0..<3]
    let left = line[7..<10]
    let right = line[12..<15]
    maze[key] = (left, right)
    if key[2] == 'A':
      nodes.add(key)

  var total = 1
  var allSteps: seq[(int, int)]
  var intervals: seq[int]
  for n in nodes:
    var node = n
    var steps = 0
    while true:
      if node[2] == 'Z':
        intervals.add(steps)
        break

      let i = steps mod directions.len()
      let dir = directions[i]

      if dir == 'L':
        node = maze[node][0]
      else:
        node = maze[node][1]

      steps += 1
  var lcm = intervals[0]
  for interval in intervals:
    var i = 1
    while true:
      if (lcm * i) mod interval == 0:
        lcm = lcm * i
        break
      i += 1
  echo(lcm)



part2()
