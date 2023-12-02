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
      elif line.startsWith("two"):
        digit = 2
      elif line.startsWith("three"):
        digit = 3
      elif line.startsWith("four"):
        digit = 4
      elif line.startsWith("five"):
        digit = 5
      elif line.startsWith("six"):
        digit = 6
      elif line.startsWith("seven"):
        digit = 7
      elif line.startsWith("eight"):
        digit = 8
      elif line.startsWith("nine"):
        digit = 9
      elif line.startsWith("zero"):
        digit = 0
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
