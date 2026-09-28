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

@Suite struct `Natural construction preserves explicit domain composition` {
    @Test func `Tagged points have natural constructors without exposing unchecked storage`() {
        let point: Tagged<Screen, Point<2, Double>> = .init(x: 100, y: 200)
        let underlying: Point<2, Double> = point.underlying

        #expect(underlying.x == 100.0)
        #expect(underlying.y == 200.0)
    }

    @Test func `Tagged coordinates retain their domain and component representation`() {
        let coordinate: Tagged<Screen, Coordinate<2, Double>> = .init(x: 10, y: 20)

        #expect(coordinate.underlying == Coordinate(x: 10.0, y: 20.0))
    }

    @Test func `Tagged displacements retain their domain and displacement labels`() {
        let displacement: Tagged<Screen, Displacement<2, Double>> = .init(dx: 3, dy: -2)

        #expect(displacement.underlying == Displacement(dx: 3.0, dy: -2.0))
    }

    @Test func `Spatial translation shorthand preserves the generic translation identity`() {
        let translation = Translation(dx: 3, dy: -2, dz: 1)
        let typed: Translation<Displacement<3, Int>> = translation

        #expect(typed == Translation(by: Displacement(dx: 3, dy: -2, dz: 1)))
    }

    @Test func `Point operations select an affine relationship explicitly`() {
        let start: Point<3, Double> = .init(x: 1, y: 2, z: 3)
        let movement: Displacement<3, Double> = .init(dx: 3, dy: -2, dz: 1)
        let space = Point<3, Double>.cartesian

        let end = space.translated(start, by: movement)
        let recovered = space.displacement(from: start, to: end)
        let translation = Translation(by: movement)

        #expect(end == Point(x: 4.0, y: 0.0, z: 4.0))
        #expect(recovered == movement)
        #expect(translation.applying(to: start, using: space) == end)
    }

    @Test func `A caller supplies the reference for a coordinate system`() {
        let reference = Point(x: 100, y: 200)
        let point = Point(x: 105, y: 207)
        let system = reference.coordinateSystem(using: Point<2, Int>.cartesian)

        let coordinates = system.coordinates(of: point)
        let recovered = system.point(at: Coordinate(x: 5, y: 7))

        #expect(coordinates == Coordinate(x: 5, y: 7))
        #expect(recovered == point)
    }

    @Test func `Tagged point operations reuse the displacement without retagging it`() {
        let start: Tagged<Screen, Point<2, Double>> = .init(x: 100, y: 200)
        let space = Point<2, Double>.cartesian.tagged(Screen.self)

        let end = space.translated(start, by: .init(dx: 5, dy: 7))
        let recovered: Displacement<2, Double> = space.displacement(from: start, to: end)

        #expect(end.underlying == Point(x: 105.0, y: 207.0))
        #expect(recovered == Displacement(dx: 5.0, dy: 7.0))
    }
}

private struct LocalDomain: ~Copyable {}

@Test func `Tagged constructors preserve noncopyable phantom domains in every named dimension`() {
    let point: Tagged<LocalDomain, Point<1, Int>> = .init(x: 1)
    let coordinate: Tagged<LocalDomain, Coordinate<1, Int>> = .init(x: 2)
    let displacement: Tagged<LocalDomain, Displacement<1, Int>> = .init(dx: 3)
    let point3: Tagged<LocalDomain, Point<3, Int>> = .init(x: 1, y: 2, z: 3)
    let coordinate3: Tagged<LocalDomain, Coordinate<3, Int>> = .init(x: 4, y: 5, z: 6)
    let displacement3: Tagged<LocalDomain, Displacement<3, Int>> = .init(dx: 7, dy: 8, dz: 9)

    #expect(point.underlying.x == 1)
    #expect(coordinate.underlying.x == 2)
    #expect(displacement.underlying.dx == 3)
    #expect(point3.underlying.z == 3)
    #expect(coordinate3.underlying.z == 6)
    #expect(displacement3.underlying.dz == 9)
}

@Test func `Spatial translation shorthand supports one and two dimensions`() {
    let first = Translation(dx: 3)
    let second = Translation(dx: 3.0, dy: -2.0)

    #expect(first.offset == Displacement(dx: 3))
    #expect(second.offset == Displacement(dx: 3.0, dy: -2.0))
}
#endif
