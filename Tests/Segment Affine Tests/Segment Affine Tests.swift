#if Affine
import Affine
import Point
import Coordinate
import Displacement
import Translation
import Vector
import Tagged
import Segment
import Testing

@Suite
struct `Segment affine interpretation` {
    @Test
    func `Segment displacement uses the selected point structure`() {
        let edge = Segment(from: Point(x: 1, y: 2), to: Point(x: 4, y: 6))
        #expect(edge.displacement(using: Point<2, Int>.cartesian) == Displacement(dx: 3, dy: 4))
        #expect(edge.reversed.displacement(using: Point<2, Int>.cartesian) == Displacement(dx: -3, dy: -4))
    }

    @Test
    func `Translation preserves endpoint difference and orientation`() {
        let edge = Segment(from: Point(x: 1, y: 2), to: Point(x: 4, y: 6))
        let moved = edge.translated(by: Displacement(dx: 10, dy: -2), using: Point<2, Int>.cartesian)
        #expect(moved == Segment(from: Point(x: 11, y: 0), to: Point(x: 14, y: 4)))
        #expect(moved.displacement(using: Point<2, Int>.cartesian) == edge.displacement(using: Point<2, Int>.cartesian))
    }

    private enum World {}

    @Test
    func `Translation preserves tagged endpoint identity`() {
        typealias Position = Tagged<World, Point<2, Int>>
        let edge = Segment<Position>(from: .init(x: 1, y: 2), to: .init(x: 4, y: 6))
        let moved: Segment<Position> = edge.translated(
            by: Displacement(dx: 1, dy: 1),
            using: Point<2, Int>.cartesian.tagged(World.self)
        )
        #expect(moved.start == Position(x: 2, y: 3))
        #expect(moved.end == Position(x: 5, y: 7))
    }

    private enum Failure: Error { case rejected }

    @Test
    func `Displacement preserves the concrete affine failure`() {
        let affine = Affine<Int, Int, Failure>(
            translating: { point, offset in point + offset },
            displacement: { (_, _) throws(Failure) in throw .rejected }
        )
        do {
            _ = try Segment(from: 1, to: 2).displacement(using: affine)
            Issue.record("Expected displacement failure")
        } catch {
            let failure: Failure = error
            #expect(failure == .rejected)
        }
    }

    @Test
    func `Failed translation leaves the original segment unchanged`() {
        let affine = Affine<Int, Int, Failure>(
            translating: { (point, offset) throws(Failure) in
                if point == 2 { throw .rejected }
                return point + offset
            },
            displacement: { start, end in end - start }
        )
        let edge = Segment(from: 1, to: 2)
        do {
            _ = try edge.translated(by: 3, using: affine)
            Issue.record("Expected translation failure")
        } catch {
            #expect(error == .rejected)
        }
        #expect(edge == Segment(from: 1, to: 2))
    }
}
#endif
