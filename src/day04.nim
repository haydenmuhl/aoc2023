import lib
import std/sets
import std/math
import std/tables

proc part1() =
  let infile = open("data/day04.txt")
  defer: infile.close()

  var total = 0
  for line in infile.lines():
    let ints = line.parseInts()
    let winning = toSet(ints[1..10])
    let mynums = toSet(ints[11 ..< ints.len()])
    let common = winning * mynums
    if common.len() > 0:
      var score = 1
      for _ in 0 ..< common.len() - 1:
        score *= 2
      total += score

  echo(total)

proc part2() =
  let infile = open("data/day04.txt")
  defer: infile.close()

  var total = 0
  var cards = initCountTable[int]()
  for line in infile.lines():
    let ints = line.parseInts()
    let id = ints[0]
    cards.inc(id, 1)

    let winning = toSet(ints[1..10])
    let mynums = toSet(ints[11 ..< ints.len()])
    let common = winning * mynums
    for diff in 1..common.len():
      cards.inc(id + diff, cards[id])
    total += cards[id]
  echo(cards)
  echo(total)



part2()
