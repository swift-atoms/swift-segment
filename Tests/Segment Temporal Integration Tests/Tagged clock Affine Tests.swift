#if Affine
import Clock
import Affine
import Tagged
import Testing
import Time
import Time

private final class LocalDomain { var state = 0 }
private struct NoncopyableDomain: ~Copyable {}

private func checkDomain<Domain: ~Copyable & ~Escapable>(_ domain: Domain.Type) throws {
    let relation = Time.Coordinate.temporal.tagged(domain)
    let start = Clock.Instant<Domain>(offset: .seconds(-3))
    let result: Clock.Instant<Domain> = try relation.translated(start, by: .seconds(3))
    #expect(result == .reference)
    #expect(try relation.displacement(from: start, to: result) == .seconds(3))
}

@Test func `Existing tagged composition preserves clock domain identity`() throws {
    try checkDomain(Clock.Continuous.self)
    try checkDomain(Clock.Suspending.self)
    try checkDomain(LocalDomain.self)
    try checkDomain(NoncopyableDomain.self)
}

@Test(arguments: [Int128.min, -1, 0, 1, Int128.max])
func `Tagged composition preserves all attoseconds`(attoseconds: Int128) throws {
    let relation = Time.Coordinate.temporal.tagged(Clock.Continuous.self)
    let origin = Clock.Continuous.Instant.reference
    let delta = Swift.Duration(attoseconds: attoseconds)
    let end: Tagged<Clock.Continuous, Time.Coordinate> = try relation.translated(origin, by: delta)
    #expect(end.offset == delta)
    #expect(try relation.displacement(from: origin, to: end) == delta)
}
#endif
