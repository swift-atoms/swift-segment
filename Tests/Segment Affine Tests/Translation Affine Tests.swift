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

@Suite struct `Translations preserve composition and inversion` {
    @Test func `Spatial translations preserve composition and inverse laws`() {
        let point = Point(coordinates: Vector<3, Int>([1, 2, 3]))
        let first = Translation(by: Displacement(components: Vector<3, Int>([3, -2, 1])))
        let second = Translation(by: Displacement(components: Vector<3, Int>([-1, 5, 2])))
        let affine = Point<3, Int>.cartesian
        #expect(first.composed(with: second).applying(to: point, using: affine)
            == second.applying(to: first.applying(to: point, using: affine), using: affine))
        #expect(first.inverted().applying(to: first.applying(to: point, using: affine), using: affine) == point)
        #expect(first.composed(with: .identity) == first)
    }
    @Test func `Native duration displacements require no wrapper`() {
        let affine = Affine<Int, Swift.Duration, Never>(
            translating: { $0 + Int($1.components.seconds) },
            displacement: { .seconds($1 - $0) }
        )
        let operation = Translation(by: Swift.Duration.seconds(3))
        #expect(operation.applying(to: 7, using: affine) == 10)
    }
}
#endif
