import Affine
import Clock
import Coordinate
import Affine
import Tagged
import Time
import Time

struct LocalDomain: ~Copyable {}
let instant: Time.Coordinate = Time.Coordinate.reference
let coordinate: Time.Coordinate = instant
let representation: Tagged<Time, Coordinate::Coordinate<1, Swift.Duration>> = instant
let clock: Clock.Instant<LocalDomain> = Tagged<LocalDomain, Time.Coordinate>(_unchecked: instant)
let relation = Time.Coordinate.temporal.tagged(LocalDomain.self)
let later: Clock.Instant<LocalDomain> = try relation.translated(clock, by: .seconds(1))
let deadline = Clock.Deadline.at(later)
let duration: Swift.Duration = try relation.displacement(from: clock, to: later)
