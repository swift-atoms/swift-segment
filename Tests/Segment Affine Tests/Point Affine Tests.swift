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

private enum Screen {}
private enum World {}
private final class LocalScalar {}

@Suite struct `Points preserve representation and domain identity` {
    @Test func `Changing reference changes coordinates not the point`() {
        let point = Point(coordinates: Vector<2, Int>([5, 7]))
        let first = Point(coordinates: Vector<2, Int>([0, 0]))
        let second = Point(coordinates: Vector<2, Int>([-5, 2]))
        let a = first.coordinateSystem(using: Point<2, Int>.cartesian)
        let b = second.coordinateSystem(using: Point<2, Int>.cartesian)
        #expect(a.coordinates(of: point).components == Vector([5, 7]))
        #expect(b.coordinates(of: point).components == Vector([10, 5]))
        #expect(a.point(at: a.coordinates(of: point)) == point)
        #expect(b.point(at: b.coordinates(of: point)) == point)
    }

    private func dimension<let N: Int>(_ type: Vector<N, Int>.Type) {
        let start = Point(coordinates: Vector<N, Int>(InlineArray { $0 }))
        let d = Displacement(components: Vector<N, Int>(repeating: 3))
        let affine = Point<N, Int>.cartesian
        let end = affine.translated(start, by: d)
        #expect(affine.displacement(from: start, to: end) == d)
        #expect(affine.translated(start, by: .zero) == start)
        #expect(affine.translated(end, by: .zero - d) == start)
        #expect(affine.translated(end, by: d) == affine.translated(start, by: d + d))
        #expect(Set([start, start]).count == 1)
        for i in 0..<N { #expect(end[i] == i + 3) }
    }

    @Test func `Cartesian relationships preserve affine laws in zero one two three and eight dimensions`() {
        dimension(Vector<0, Int>.self)
        dimension(Vector<1, Int>.self)
        dimension(Vector<2, Int>.self)
        dimension(Vector<3, Int>.self)
        dimension(Vector<8, Int>.self)
    }

    @Test func `Tagging point identity leaves the displacement type unchanged`() {
        let point = Point(coordinates: Vector<2, Int>([1, 2]))
        let screen = Tagged<Screen, Point<2, Int>>(_unchecked: point)
        let world = Tagged<World, Point<2, Int>>(_unchecked: point)
        let affine = Point<2, Int>.cartesian.tagged(Screen.self)
        let delta = Displacement(components: Vector<2, Int>([3, 4]))
        let result = affine.translated(screen, by: delta)
        #expect(result.underlying.coordinates == Vector([4, 6]))
        #expect(affine.displacement(from: screen, to: result) == delta)
        #expect(world.underlying == point)
    }

    @Test func `Point representations require neither arithmetic nor sendability`() {
        let value = LocalScalar()
        let point = Point(coordinates: Vector<2, LocalScalar>(repeating: value))
        let relation = Affine<Point<2, LocalScalar>, Void, Never>(
            translating: { point, _ in point }, displacement: { _, _ in () }
        ).tagged(Screen.self)
        let tagged = Tagged<Screen, Point<2, LocalScalar>>(_unchecked: point)
        #expect(relation.translated(tagged, by: ()).underlying[0] === value)
    }
}
#endif
