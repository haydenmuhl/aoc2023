import lib
import std/sequtils

proc calcPossibilities(time, distance: int): int =
  for i in 0..time:
    let total = i * (time - i)
    if total > distance:
      result += 1

proc part1() =
  let infile = open("data/day06.txt")
  defer: infile.close()

  let times = infile.readLine().parseInts()
  let distances = infile.readLine().parseInts()

  var answer = 1
  for i in 0 ..< times.len():
    answer = answer * calcPossibilities(times[i], distances[i])
  echo(answer)

proc part2() =
  let infile = open("data/day06.txt")
  defer: infile.close()

  var time = 0
  var line = infile.readLine()
  for c in line:
    if '0' <= c and c <= '9':
      time *= 10
      time += c.ord() - '0'.ord()

  var distance = 0
  line = infile.readLine()
  for c in line:
    if '0' <= c and c <= '9':
      distance *= 10
      distance += c.ord() - '0'.ord()


  var min = 0
  while true:
    let total = min * (time - min)
    if total > distance:
      break
    min += 1

  var max = time
  while true:
    let total = max * (time - max)
    if total > distance:
      break
    max -= 1

  echo(max - min + 1)

part2()
