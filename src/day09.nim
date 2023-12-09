import lib

import std/re
import std/algorithm
import std/strformat
import std/strutils
import std/tables
import std/sequtils

proc nextValue(ints: openArray[int]): int =
  let tab = ints.toCountTable()
  if tab[0] == ints.len():
    return 0

  var nextInts: seq[int]
  for i in 0 .. ints.len() - 2:
    nextInts.add(ints[i + 1] - ints[i])
  let next = nextValue(nextInts)
  result = next + ints[ints.len() - 1]

proc part1() =
  let infile = open("data/day09.txt")
  defer: infile.close()

  var total = 0
  for line in infile.lines():
    let ints = line.parseInts()
    total += nextValue(ints)
  echo(total)

proc prevValue(ints: openArray[int]): int =
  let tab = ints.toCountTable()
  if tab[0] == ints.len():
    return 0

  var nextInts: seq[int]
  for i in 0 .. ints.len() - 2:
    nextInts.add(ints[i + 1] - ints[i])
  let prev = prevValue(nextInts)
  return ints[0] - prev

proc part2() =
  let infile = open("data/day09.txt")
  defer: infile.close()

  var total = 0
  for line in infile.lines():
    let ints = line.parseInts()
    total += prevValue(ints)
  echo(total)

part2()
