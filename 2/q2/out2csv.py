import csv
import re
from collections import defaultdict
import sys

for file_name in ["c", "d", "dc"]:

  runs = defaultdict(list)

  file_in = open("%s.out" % file_name, "r")
  file_out = open("%s.csv" % file_name, "w")

  for line in file_in:

    # Skip lines until we find the start of a section
    if not re.match(r"Running Tabu Search", line): continue

    m = re.search(r"Length\: ([0-9]+)", line)
    length = int(m.groups(1)[0])

    m = re.search(r"Iterations\: ([0-9]+)", line)
    iterations = int(m.groups(1)[0])

    values = []

    for line in file_in:

      m = re.match(r"    ([0-9]+)/[0-9]+: ([0-9]+)", line)
      if m is None: break

      key = int(m.groups()[0]) - 1
      value = int(m.groups()[1])

      values.append(value)

    runs[length].append(values)

  writer = csv.writer(file_out)

  writer.writerow([
    "%d (%d)" % (length, j)
    for length in runs.keys()
    for j in xrange(0, 5)
  ])

  writer.writerows([
    [
      runs[length][j][i] if len(runs[length][j]) > i else 109

      for length in runs.keys()
      for j in xrange(0, 5)
    ]

    for i in xrange(0, 100)
  ])
