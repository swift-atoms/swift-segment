#if Affine
public import Affine

extension Segment {

    public func displacement<Displacement, Failure: Swift.Error>(
        using affine: Affine<Point, Displacement, Failure>
    ) throws(Failure) -> Displacement {
        try affine.displacement(from: start, to: end)
    }

    public func translated<Displacement, Failure: Swift.Error>(
        by displacement: Displacement,
        using affine: Affine<Point, Displacement, Failure>
    ) throws(Failure) -> Self {
        try map { (point) throws(Failure) in
            try affine.translated(point, by: displacement)
        }
    }
}
#endif
