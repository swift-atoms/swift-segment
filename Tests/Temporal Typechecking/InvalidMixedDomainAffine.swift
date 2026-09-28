// expected-error: cannot convert value of type
import Clock
import Affine
import Time
import Time
let relation = Time.Coordinate.temporal.tagged(Clock.Continuous.self)
let invalid = try relation.translated(Clock.Suspending.Instant.reference, by: .seconds(1))
