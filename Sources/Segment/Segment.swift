public struct Segment<Point> {
    public var start: Point
    public var end: Point

    public init(start: Point, end: Point) {
        self.start = start
        self.end = end
    }

    public var reversed: Self { Self(start: end, end: start) }

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
extension Segment: Encodable where Point: Encodable {}
extension Segment: Decodable where Point: Decodable {}
#endif

extension Segment {
    public init(from start: Point, to end: Point) {
        self.init(start: start, end: end)
    }
}
