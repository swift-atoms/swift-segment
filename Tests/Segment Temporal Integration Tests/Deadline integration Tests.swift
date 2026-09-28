#if Affine
import Clock
import Affine
import Testing
import Time
import Time

@Test(arguments: [Int128(-1_000_000_000_000_000_000), 1, Int128.max])
func `Deadlines use explicit affine construction`(attoseconds: Int128) throws {
    let relation = Time.Coordinate.temporal.tagged(Clock.Continuous.self)
    let origin = Clock.Continuous.Instant.reference
    let end = try relation.translated(origin, by: .init(attoseconds: attoseconds))
    let deadline = Clock.Continuous.Deadline.at(end)
    #expect(deadline.instant == end)
    #expect(deadline.hasExpired(at: origin) == (attoseconds <= 0))
    #expect(deadline.hasExpired(at: end))
    #expect(deadline < .never)
}

@Test(arguments: [Int128.min, -1, 0, 1, Int128.max])
func `No finite coordinate is reserved for never`(attoseconds: Int128) {
    let instant = Clock.Continuous.Instant(offset: .init(attoseconds: attoseconds))
    let finite = Clock.Continuous.Deadline(instant)
    let never = Clock.Continuous.Deadline.never
    #expect(finite != never)
    #expect(never.instant == nil)
    #expect(!never.hasExpired(at: instant))
    #expect(finite.hasExpired(at: instant))
    #expect([never, finite].sorted() == [finite, never])
    #expect(Set([finite, never]).count == 2)
}
#endif
