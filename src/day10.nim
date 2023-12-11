import lib

import std/re
import std/algorithm
import std/strformat
import std/strutils
import std/tables
import std/sequtils
import std/deques


proc part1() =
  let infile = open("data/day10.txt")
  defer: infile.close()

  var board: seq[string]
  for line in infile.lines():
    board.add(line)

  var rStart = 0
  var cStart = 0
  for rIdx, line in board:
    for cIdx, ch in line:
      if ch == 'S':
        rStart = rIdx
        cStart = cIdx

  var length = 1
  var r = rStart
  var c = cStart
  var cameFrom: Point
  if board[rStart - 1][cStart] in "|7F":
    r = rStart - 1
    cameFrom = up
  elif board[rStart + 1][cStart] in "|LJ":
    r = rStart + 1
    cameFrom = down
  elif board[rStart][cStart - 1] in "-LF":
    c = cStart - 1
    cameFrom = right
  elif board[rStart][cStart + 1] in "-J7":
    c = cStart + 1
    cameFrom = left
  else:
    raise newException(ValueError, "Dang")

  var here = Point(x: c, y: r)
  var start = Point(x: cStart, y: rStart)
  while here != start:
    case board[here.y][here.x]
    of '|':
      if cameFrom == up:
        here += down
        cameFrom = up
      else:
        here += up
        cameFrom = down
    of '-':
      if cameFrom == left:
        here += right
        cameFrom = left
      else:
        here += left
        cameFrom = right
    of 'L':
      if cameFrom == right:
        here += down
        cameFrom = up
      else:
        here += right
        cameFrom = left
    of 'J':
      if cameFrom == down:
        here += left
        cameFrom = right
      else:
        here += down
        cameFrom = up
    of 'F':
      if cameFrom == right:
        here += up
        cameFrom = down
      else:
        here += right
        cameFrom = left
    of '7':
      if cameFrom == left:
        here += up
        cameFrom = down
      else:
        here += left
        cameFrom = right
    else:
      raise newException(ValueError, "Shucks")
    length += 1
  echo(length div 2)

proc update(board: var seq[string], rowIdx, colIdx: int, ch: char) =
  if rowIdx < 0:
    return
  if colIdx < 0:
    return
  if rowIdx >= board.len():
    return
  if colIdx >= board[0].len():
    return
  if board[rowIdx][colIdx] == ' ':
    board[rowIdx][colIdx] = ch

proc fill(board: var seq[string], rowIdx, colIdx: int) =
  let ch = board[rowIdx][colIdx]
  var q: Deque[(int, int)]
  q.addLast((rowIdx + 1, colIdx))
  q.addLast((rowIdx - 1, colIdx))
  q.addLast((rowIdx, colIdx + 1))
  q.addLast((rowIdx, colIdx - 1))

  while q.len() != 0:
    let here = q.popFirst()
    let r = here[0]
    let c = here[1]
    if board[r][c] == ' ':
      board[r][c] = ch
      q.addLast((r + 1, c))
      q.addLast((r - 1, c))
      q.addLast((r, c + 1))
      q.addLast((r, c - 1))

proc part2() =
  let infile = open("data/day10.txt")
  defer: infile.close()

  var board: seq[string]
  for line in infile.lines():
    board.add(line)

  var rStart = 0
  var cStart = 0
  for rIdx, line in board:
    for cIdx, ch in line:
      if ch == 'S':
        rStart = rIdx
        cStart = cIdx

  var r = rStart
  var c = cStart
  var cameFrom: Point
  if board[rStart - 1][cStart] in "|7F":
    r = rStart - 1
    cameFrom = up
  elif board[rStart + 1][cStart] in "|LJ":
    r = rStart + 1
    cameFrom = down
  elif board[rStart][cStart - 1] in "-LF":
    c = cStart - 1
    cameFrom = right
  elif board[rStart][cStart + 1] in "-J7":
    c = cStart + 1
    cameFrom = left
  else:
    raise newException(ValueError, "Dang")

  var path: seq[Point]
  var here = Point(x: c, y: r)
  var start = Point(x: cStart, y: rStart)
  path.add(start)
  path.add(here)
  while here != start:
    case board[here.y][here.x]
    of '|':
      if cameFrom == up:
        here += down
        cameFrom = up
      else:
        here += up
        cameFrom = down
    of '-':
      if cameFrom == left:
        here += right
        cameFrom = left
      else:
        here += left
        cameFrom = right
    of 'L':
      if cameFrom == right:
        here += down
        cameFrom = up
      else:
        here += right
        cameFrom = left
    of 'J':
      if cameFrom == down:
        here += left
        cameFrom = right
      else:
        here += down
        cameFrom = up
    of 'F':
      if cameFrom == right:
        here += up
        cameFrom = down
      else:
        here += right
        cameFrom = left
    of '7':
      if cameFrom == left:
        here += up
        cameFrom = down
      else:
        here += left
        cameFrom = right
    else:
      raise newException(ValueError, "Shucks")
    path.add(here)

  for rIdx in 0 ..< board.len():
    for cIdx in 0 ..< board[rIdx].len():
      if Point(x: cIdx, y: rIdx) notin path:
        board[rIdx][cIdx] = ' '

  r = rStart
  c = cStart
  if board[rStart - 1][cStart] in "|7F":
    r = rStart - 1
    cameFrom = up
  elif board[rStart + 1][cStart] in "|LJ":
    r = rStart + 1
    cameFrom = down
  elif board[rStart][cStart - 1] in "-LF":
    c = cStart - 1
    cameFrom = right
  elif board[rStart][cStart + 1] in "-J7":
    c = cStart + 1
    cameFrom = left
  else:
    raise newException(ValueError, "Dang")

  here = Point(x: c, y: r)
  while here != start:
    let hereChar = board[here.y][here.x]
    case hereChar
    of '|':
      if cameFrom == up:
        board.update(here.y, here.x - 1, 'l')
        board.update(here.y, here.x + 1, 'r')
        here += down
        cameFrom = up
      else:
        board.update(here.y, here.x - 1, 'r')
        board.update(here.y, here.x + 1, 'l')
        here += up
        cameFrom = down
    of '-':
      if cameFrom == left:
        board.update(here.y - 1, here.x, 'l')
        board.update(here.y + 1, here.x, 'r')
        here += right
        cameFrom = left
      else:
        board.update(here.y - 1, here.x, 'r')
        board.update(here.y + 1, here.x, 'l')
        here += left
        cameFrom = right
    of 'L':
      if cameFrom == right:
        board.update(here.y + 1, here.x, 'l')
        board.update(here.y, here.x - 1, 'l')
        board.update(here.y + 1, here.x - 1, 'l')
        here += down
        cameFrom = up
      else:
        board.update(here.y + 1, here.x, 'r')
        board.update(here.y, here.x - 1, 'r')
        board.update(here.y + 1, here.x - 1, 'r')
        here += right
        cameFrom = left
    of 'J':
      if cameFrom == down:
        board.update(here.y, here.x + 1, 'l')
        board.update(here.y + 1, here.x, 'l')
        board.update(here.y + 1, here.x + 1, 'l')
        here += left
        cameFrom = right
      else:
        board.update(here.y, here.x + 1, 'r')
        board.update(here.y + 1, here.x, 'r')
        board.update(here.y + 1, here.x + 1, 'r')
        here += down
        cameFrom = up
    of 'F':
      if cameFrom == right:
        board.update(here.y - 1, here.x, 'r')
        board.update(here.y, here.x - 1, 'r')
        board.update(here.y - 1, here.x - 1, 'r')
        here += up
        cameFrom = down
      else:
        board.update(here.y - 1, here.x, 'l')
        board.update(here.y, here.x - 1, 'l')
        board.update(here.y - 1, here.x - 1, 'l')
        here += right
        cameFrom = left
    of '7':
      if cameFrom == left:
        board.update(here.y - 1, here.x, 'l')
        board.update(here.y, here.x + 1, 'l')
        board.update(here.y - 1, here.x + 1, 'l')
        here += up
        cameFrom = down
      else:
        board.update(here.y - 1, here.x, 'r')
        board.update(here.y, here.x + 1, 'r')
        board.update(here.y - 1, here.x + 1, 'r')
        here += left
        cameFrom = right
    else:
      for line in board:
        echo(line)
      raise newException(ValueError, fmt"{hereChar}, {here}")

  for r in 0 ..< board.len():
    for c in 0 ..< board[0].len():
      if board[r][c] == 'r':
        board.fill(r, c)

  var count = 0
  for line in board:
    for ch in line:
      if ch == 'r':
        count += 1
  echo(count)

part2()
