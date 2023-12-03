import std/strutils

import lib

type Round = object
  red: int
  green: int
  blue: int

proc possible(rounds: seq[Round]): bool =
  result = true
  for round in rounds:
    result = result and (round.red <= 12 and round.green <= 13 and round.blue <= 14)

proc parseGame(line: string): (int, seq[Round]) =
  let firstParse = line.split(":")
  let secondParse = firstParse[1].split(";")
  let gameId = parseInts(firstParse[0])[0]
  var rounds: seq[Round] = @[]
  for rawRound in secondParse:
    var round: Round
    for draw in rawRound.split(", "):
      let num = draw.parseInts()[0]
      if draw.find("blue") != -1:
        round.blue = num
      if draw.find("green") != -1:
        round.green = num
      if draw.find("red") != -1:
        round.red = num
    rounds.add(round)
  result = (gameId, rounds)

proc part1() =
  let infile = open("data/day02.txt")
  defer: infile.close()

  var total = 0
  for line in infile.lines:
    let game = parseGame(line)
    if possible(game[1]):
      total += game[0]
  echo(total)

proc minValid(rounds: seq[Round]): Round =
  for round in rounds:
    if round.red > result.red:
      result.red = round.red
    if round.green > result.green:
      result.green = round.green
    if round.blue > result.blue:
      result.blue = round.blue

proc power(round: Round): int =
  round.red * round.green * round.blue

proc part2() =
  let infile = open("data/day02.txt")
  defer: infile.close()

  var total = 0
  for line in infile.lines:
    let game = parseGame(line)
    total += game[1].minValid().power()
  echo(total)

part2()
