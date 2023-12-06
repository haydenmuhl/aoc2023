import lib

import std/sequtils

proc translate(infile: File, invals: seq[int]): seq[int] =
  result = invals
  while true:
    var line = ""
    try:
      line = infile.readLine()
      if line == "":
        break
    except IOError:
      break
    let ints = line.parseInts()
    let outRange = ints[0]
    let inRange = ints[1]
    let size = ints[2]

    for inval in invals:
      if inRange <= inval and inval < inRange + size:
        #echo(inRange, ' ', inval, ' ', size, ' ', outRange)
        let tmp = inval
        result = result.filter(proc (i: int): bool = i != tmp)
        let outval = inval - inRange + outRange
        #echo(outval)
        result.add(outval)


proc part1() =
  let infile = open("data/day05.txt")
  defer: infile.close()

  let seeds = infile.readLine().parseInts()
  discard infile.readLine()
  discard infile.readLine()
  let soils = translate(infile, seeds)
  echo(soils)
  echo(infile.readLine())
  let fertilizers = translate(infile, soils)
  echo(fertilizers)
  echo(infile.readLine())
  let waters = translate(infile, fertilizers)
  echo(waters)
  echo(infile.readLine())
  let light = translate(infile, waters)
  echo(light)
  echo(infile.readLine())
  let temperatures = translate(infile, light)
  echo(temperatures)
  echo(infile.readLine())
  let humidities = translate(infile, temperatures)
  echo(humidities)
  echo(infile.readLine())
  let locations = translate(infile, humidities)
  echo(locations)
  echo(min(locations))

type Range = object
  start: int
  size: int

proc max(self: Range): int =
  self.start + self.size - 1

proc intersect(a, b: Range): Range =
  result.start = 0
  result.size = 0
  let start = max(a.start, b.start)
  let maxVal = min(a.start + a.size - 1, b.start + b.size - 1)
  if maxVal >= start:
    result.start = start
    result.size = maxVal - start + 1

proc transform(orig, frum, to: Range): (Range, seq[Range]) =
  var intersection = orig.intersect(frum)
  if intersection.size == 0:
    return
  if orig.start < intersection.start:
    result[1].add(Range(start: orig.start, size: intersection.start - orig.start))
  if orig.max() > intersection.max():
    result[1].add(Range(start: orig.max() + 1, size: intersection.max() - orig.max()))
  intersection.start += to.start - frum.start
  result[0] = intersection

proc translate(infile: File, ins: seq[Range]): seq[Range] =
  # Start on the header. Discard it.
  discard infile.readLine()

  var inputs = ins
  var tmpInputs: seq[Range] = @[]
  while true:
    var line = ""
    try:
      line = infile.readLine()
    except IOError:
      discard
    if line == "":
      break

    let ints = line.parseInts()
    let to = Range(start: ints[0], size: ints[2])
    let frum = Range(start: ints[1], size: ints[2])

    while inputs.len() > 0:
      let input = inputs.pop()
      let xform = transform(input, frum, to)
      if xform[0].size == 0:
        # Did not match
        tmpInputs.add(input)
      else:
        result.add(xform[0])
        for r in xform[1]:
          tmpInputs.add(r)
    inputs = tmpInputs
    tmpInputs = @[]
  for r in inputs:
    result.add(r)


proc part2() =
  let infile = open("data/day05.txt")
  defer: infile.close()

  let rawseeds = infile.readLine().parseInts()
  var seeds: seq[Range]
  var i = 0
  while i < rawseeds.len():
    seeds.add(Range(start: rawseeds[i], size: rawseeds[i + 1]))
    i += 2
  discard infile.readLine()
  for _ in 0..<7:
    seeds = translate(infile, seeds)
  echo(seeds.map( proc(r: Range): int = r.start).min())

part2()
