import std/re
import std/strutils

let intRegex = re(r"\d+")
let nonDigitRegex = re(r"[^\d]")

type coord = object
  row: int
  col: int

type engine = object
  rows: int
  cols: int
  data: seq[string]

proc initEngine(data: string): engine =
  result.data = data.split
  result.data = result.data[0 ..< result.data.len() - 1]
  result.rows = result.data.len()
  result.cols = result.data[0].len()

proc isValid(self: engine, rowIdx: int, bounds: (int, int)): bool =
  for r in rowIdx - 1 .. rowIdx + 1:
    if r < 0 or r >= self.data.len():
      continue
    let line = self.data[r]
    let minIdx = max(0, bounds[0] - 1)
    let maxIdx = min(bounds[1] + 1, line.len() - 1)
    let subStr = line[minIdx .. maxIdx]
    echo(subStr)
    for c in subStr:
      case c
      of '0'..'9', '.':
        continue
      else:
        return true
  false

proc getInt(self: engine, rowIdx: int, bounds: (int, int)): int =
  self.data[rowIdx][bounds[0] .. bounds[1]].parseInt()

proc part1(self: engine): int =
  result = 0
  var rowIdx = 0
  while rowIdx < self.rows:
    let line = self.data[rowIdx]
    var start = 0
    while start < line.len():
      let bounds = findBounds(line, intRegex, start)
      if bounds[0] == -1:
        break
      if(self.isValid(rowIdx, bounds)):
        echo(rowIdx, ' ', bounds[0], ' ', bounds[1])
        result += self.getInt(rowIdx, bounds)
      start = bounds[1] + 1
    rowIdx += 1

proc part1() =
  let infile = open("data/day03.txt")
  defer: infile.close()

  let engine = initEngine(infile.readAll())
  echo(engine.part1())

proc getInt(self:engine, rowIdx: int, colIdx: int): int =
  if rowIdx < 0 or rowIdx >= self.data.len():
    return -1
  if colIdx < 0 or colIdx >= self.data.len():
    return -1
  if self.data[rowIdx][colIdx] notin Digits:
    return -1

  result = self.data[rowIdx][colIdx].ord() - '0'.ord()

  # go left
  var cursor = colIdx - 1
  var multiplier = 10
  while cursor >= 0:
    if self.data[rowIdx][cursor] notin Digits:
      break
    result += multiplier * (self.data[rowIdx][cursor].ord() - '0'.ord())
    multiplier *= 10
    cursor -= 1
  # go right
  cursor = colIdx + 1
  while cursor < self.data.len():
    if self.data[rowIdx][cursor] notin Digits:
      break
    result *= 10
    result += self.data[rowIdx][cursor].ord() - '0'.ord()
    cursor += 1


proc adjacentInts(self: engine, rowIdx: int, colIdx: int): seq[int] =
  var i = self.getInt(rowIdx - 1, colIdx)
  if i != -1:
    result.add(i)
  else:
    i = self.getInt(rowIdx - 1, colIdx - 1)
    if i != -1:
      result.add(i)
    i = self.getInt(rowIdx - 1, colIdx + 1)
    if i != -1:
      result.add(i)
  i = self.getInt(rowIdx + 1, colIdx)
  if i != -1:
    result.add(i)
  else:
    i = self.getInt(rowIdx + 1, colIdx - 1)
    if i != -1:
      result.add(i)
    i = self.getInt(rowIdx + 1, colIdx + 1)
    if i != -1:
      result.add(i)
  i = self.getInt(rowIdx, colIdx - 1)
  if i != -1:
    result.add(i)
  i = self.getInt(rowIdx, colIdx + 1)
  if i != -1:
    result.add(i)

proc part2(self: engine): int =
  result = 0
  for rowIdx in 0 ..< self.rows:
    for colIdx in 0 ..< self.cols:
      if self.data[rowIdx][colIdx] == '*':
        let adjacent = self.adjacentInts(rowIdx, colIdx)
        if adjacent.len() == 2:
          result += adjacent[0] * adjacent[1]

proc part2() =
  let infile = open("data/day03.txt")
  defer: infile.close()

  let engine = initEngine(infile.readAll())
  echo(engine.part2())

part2()
