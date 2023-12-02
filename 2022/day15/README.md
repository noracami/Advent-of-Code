# Day 15: Beacon Exclusion Zone

> https://adventofcode.com/2022/day/15

- sensors can only lock on to the one beacon closest to the sensor as measured by the Manhattan distance.
- (There is never a tie where two beacons are the same distance to a sensor.)

## part 1

### In the row where y=2000000, how many positions cannot contain a beacon?

### sample: In the row where y=10, how many positions cannot contain a beacon? => 26

Sensor and closest beacon form an area that sensor is center and distance of both is radius.

Beacon cannot place into the Area or break the closest beacon rule.

Take S: 2, 18; B: -2, 15 for example, their radius(Manhattan distance) is |2 - (-2)| + |18 - 15| = 7

The top coordinate of Area is (2, 18 - 7) = (2, 11)

Since the Area does not have intersection with y=10, it do not provide any position to the answer.

Take S: 8, 7; B: 2, 10 for example, their radius(Manhattan distance) is |8 - 2| + |7 - 10| = 9

The distance of S(8, 7) and y=10 is 3, so it provide the position from (8 - (9 - 3), 10) to (8 + (9 - 3), 10) to the answer.

That is:

1. If radius >= distance of (point S, y=10), we can set x=(S.x - (R - D)) to x=(S.x + (R - D)) as covered.
2. Once every Sensor is examined, we can count how many points is covered on y=10
