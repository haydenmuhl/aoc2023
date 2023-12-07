import std/sequtils
import std/strutils
import std/enumerate
import std/algorithm

const CARDS: array[13, char] = ['2', '3', '4', '5', '6', '7', '8', '9', 'T', 'J', 'Q', 'K', 'A']

type rank = enum
  highCard
  pair
  twoPair
  three
  fullHouse
  four
  five

proc handToNums(hand: string): seq[int] =
  for c in hand:
    result.add(CARDS.find(c))

proc scoreHand(h: seq[int]): rank =
  var hand = h
  hand.sort()
  var pairs = ""
  for i in 0..3:
    if hand[i] == hand[i + 1]:
      pairs.add('1')
    else:
      pairs.add('0')

  case pairs
  of "0000":
    highCard
  of "1000", "0100", "0010", "0001":
    pair
  of "1010", "0101", "1001":
    twoPair
  of "1100", "0110", "0011":
    three
  of "1101", "1011":
    fullHouse
  of "1110", "0111":
    four
  of "1111":
    five
  else:
    raise newException(ValueError, pairs)

proc cmp(a, b: seq[int]): int =
  let aRank = scoreHand(a)
  let bRank = scoreHand(b)
  if aRank < bRank:
    return -1
  if aRank > bRank:
    return 1

  for i in 0..<5:
    if a[i] < b[i]:
      return -1
    if a[i] > b[i]:
      return 1

  return 0

proc part1() =
  let infile = open("data/day07.txt")
  defer: infile.close()

  var hands: seq[(seq[int], int)] = @[]
  for line in infile.lines():
    let parts = line.split(" ")
    let hand = parts[0].handToNums()
    let bet = parts[1].parseInt()

    hands.add((hand, bet))
  hands.sort(cmp)
  var total = 0
  for i, item in enumerate(hands):
    total += (i + 1) * item[1]
  echo(total)

const CARDS2: array[13, char] = ['J', '2', '3', '4', '5', '6', '7', '8', '9', 'T', 'Q', 'K', 'A']

proc handToNums2(hand: string): seq[int] =
  for c in hand:
    result.add(CARDS2.find(c))

proc scoreHand2(h: seq[int]): rank =
  result = highCard
  for wild in 1..12:
    let wildHand = h.map(proc (i: int): int =
      if i == 0:
        wild
      else:
        i)
    let score = scoreHand(wildHand)
    if score > result:
      result = score

proc cmp2(a, b: (seq[int], int)): int =
  let aRank = scoreHand2(a[0])
  let bRank = scoreHand2(b[0])
  if aRank < bRank:
    return -1
  if aRank > bRank:
    return 1

  for i in 0..<5:
    if a[0][i] < b[0][i]:
      return -1
    if a[0][i] > b[0][i]:
      return 1

  return 0

proc part2() =
  let infile = open("data/day07.txt")
  defer: infile.close()

  var hands: seq[(seq[int], int)] = @[]
  for line in infile.lines():
    let parts = line.split(" ")
    let hand = parts[0].handToNums2()
    let bet = parts[1].parseInt()

    hands.add((hand, bet))
  hands.sort(cmp2)
  var total = 0
  for i, item in enumerate(hands):
    total += (i + 1) * item[1]
  echo(total)


part2()
