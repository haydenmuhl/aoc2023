import std/re
import std/strutils

let intsRegex = re(r"(0|[1-9][0-9]*)")

proc parseInts*(line: string): seq[int] =
  let substrings = findAll(line, intsRegex)
  for s in substrings:
    result.add(s.parseInt())

proc peek*[T](a: openArray[T]): T =
  a[a.len() - 1]
