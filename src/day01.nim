import std/strformat
import std/strutils

proc part1() =
  let infile = open("data/day01.txt")
  defer: infile.close()

  var total = 0
  for line in infile.lines:
    var firstDigit: char = ' '
    var lastDigit: char = ' '
    for c in line:
      case c:
      of '0'..'9':
        if firstDigit == ' ':
          firstDigit = c
        lastDigit = c
      else:
        discard
    let calibration = fmt"{firstDigit}{lastDigit}".parseInt()
    total += calibration
  echo(total)

proc part2() =
  let infile = open("data/day01.txt")
  defer: infile.close()

  var total = 0
  for l in infile.lines:
    var line = l
    var firstDigit = -1
    var lastDigit = -1
    while line.len() > 0:
      var digit = -1
      if line.startsWith("one"):
        digit = 1
        line = line[3 .. line.len() - 1]
      elif line.startsWith("two"):
        digit = 2
        line = line[3 .. line.len() - 1]
      elif line.startsWith("three"):
        digit = 3
        line = line[5 .. line.len() - 1]
      elif line.startsWith("four"):
        digit = 4
        line = line[4 .. line.len() - 1]
      elif line.startsWith("five"):
        digit = 5
        line = line[4 .. line.len() - 1]
      elif line.startsWith("six"):
        digit = 6
        line = line[3 .. line.len() - 1]
      elif line.startsWith("seven"):
        digit = 7
        line = line[5 .. line.len() - 1]
      elif line.startsWith("eight"):
        digit = 8
        line = line[5 .. line.len() - 1]
      elif line.startsWith("nine"):
        digit = 9
        line = line[4 .. line.len() - 1]
      elif line.startsWith("zero"):
        digit = 0
        line = line[4 .. line.len() - 1]
      else:
        if line[0] >= '0' and line[0] <= '9':
          digit = line[0].ord() - '0'.ord()
        line = line[1 .. line.len() - 1]

      if digit != -1:
        if firstDigit == -1:
          firstDigit = digit
        lastDigit = digit
    let calibration = firstDigit * 10 + lastDigit
    total += calibration
  echo(total)

part2()
