import Segment
import Point
import Tagged
import Testing

@Suite
struct `Segments of points` {
    @Test
    func `Three dimensional endpoints use natural point construction`() {
        let segment = Segment(
            from: Point(x: 1, y: 2, z: 3),
            to: Point(x: 4, y: 5, z: 6)
        )
        #expect(segment.start.coordinates == Vector<3, Int>(x: 1, y: 2, z: 3))
        #expect(segment.end == Point(x: 4, y: 5, z: 6))
    }

    private enum World {}

    @Test
    func `The endpoint type preserves its domain tag`() {
        typealias Position = Tagged<World, Point<2, Int>>
        let start = Position(_unchecked: Point(x: 1, y: 2))
        let end = Position(_unchecked: Point(x: 4, y: 6))
        let segment = Segment(from: start, to: end)
        let reversed: Segment<Position> = segment.reversed
        #expect(reversed.start == end)
        #expect(reversed.end == start)
    }
}
