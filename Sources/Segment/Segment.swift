/// An oriented segment represented by two endpoints of the same point type.
///
/// Endpoint order is significant. Coincident endpoints are permitted. Storage
/// alone imposes no ordering, coordinates, metric, or interpolation on Point.
/// Domain and frame identity are preserved by the endpoint type itself.
public struct Segment<Point> {
    public var start: Point
    public var end: Point

    public init(start: Point, end: Point) {
        self.start = start
        self.end = end
    }

    public init(from start: Point, to end: Point) {
        self.init(start: start, end: end)
    }

    public var reversed: Self { Self(start: end, end: start) }

    /// Transform endpoints in start-then-end order, preserving orientation.
    public func map<Result, Failure: Swift.Error>(
        _ transform: (Point) throws(Failure) -> Result
    ) throws(Failure) -> Segment<Result> {
        try Segment<Result>(start: transform(start), end: transform(end))
    }
}

extension Segment: Equatable where Point: Equatable {}
extension Segment: Hashable where Point: Hashable {}
extension Segment: Sendable where Point: Sendable {}

#if !hasFeature(Embedded)
extension Segment: Codable where Point: Codable {}
#endif
