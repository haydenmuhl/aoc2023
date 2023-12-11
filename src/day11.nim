import lib

import std/re
import std/algorithm
import std/strformat
import std/strutils
import std/tables
import std/sequtils
import std/deques

proc addCols(starfield: var seq[string]) =
  var cols: seq[int]
  for cidx in 0 ..< starfield[0].len():
    let chars = starfield.map(proc (l: string): char = l[cidx])
    let histogram = chars.toCountTable()
    if histogram['.'] == starfield.len():
      cols.add(cidx)

  cols.sort()
  cols.reverse()
  for cidx in cols:
    for row in starfield.mitems:
      row.insert(".", cidx)

proc findGalaxies(starfield: seq[string]): seq[Point] =
  for ridx, line in starfield:
    for cidx, ch in line:
      if ch == '#':
        result.add(Point(x: cidx, y: ridx))

proc part1() =
  let infile = open("data/day11.txt")
  defer: infile.close()

  var starfield: seq[string]
  for line in infile.lines():
    starfield.add(line)
    let histogram = line.toCountTable()
    if histogram['.'] == line.len():
      starfield.add(line)

  starfield.addCols()

  var total = 0
  let galaxies = findGalaxies(starfield)
  for a in galaxies:
    for b in galaxies:
      let diff = a - b
      total += abs(diff.x) + abs(diff.y)
  echo(total div 2)

proc getEmptyRows(starfield: seq[string]): seq[int] =
  for ridx, row in starfield:
    let histogram = row.toCountTable()
    if histogram['.'] == row.len():
      result.add(ridx)

proc getEmptyCols(starfield: seq[string]): seq[int] =
  for cidx in 0 ..< starfield[0].len():
    let chars = starfield.map(proc (l: string): char = l[cidx])
    let histogram = chars.toCountTable()
    if histogram['.'] == starfield.len():
      result.add(cidx)

proc part2() =
  let infile = open("data/day11.txt")
  defer: infile.close()

  var starfield: seq[string]
  for line in infile.lines():
    starfield.add(line)

  let expandoRows = starfield.getEmptyRows()
  let expandoCols = starfield.getEmptyCols()

  var total = 0
  let galaxies = findGalaxies(starfield)
  for a in galaxies:
    for b in galaxies:
      let diff = a - b
      total += abs(diff.x) + abs(diff.y)

      for ridx in expandoRows:
        if (ridx - a.y) * (ridx - b.y) < 0:
          total += 999999
      for cidx in expandoCols:
        if (cidx - a.x) * (cidx - b.x) < 0:
          total += 999999
  echo(total div 2)

part2()
