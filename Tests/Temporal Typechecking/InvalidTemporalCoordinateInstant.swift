// expected-error: requires that
import Time
import Time
func requireInstant<I: Swift.InstantProtocol>(_ instant: I) {}
requireInstant(Time.Coordinate.reference)
