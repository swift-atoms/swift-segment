# swift-segment

Use this package when you need a directed pair of endpoints, such as an edge from one point to another, a journey from one station to the next, or a span from one instant to a later one. The endpoints can be any type, with no arithmetic or coordinates required. Start from `Segment<Point>`. With the `Affine` trait, a segment measures and moves itself through an `Affine<Point, Displacement, Failure>` that you choose, so the same endpoints can be read under different spaces or domain tags. For an unbounded line or a half-line from an origin, use swift-line or swift-ray. For a range of ordered positions with open or closed bounds, use swift-interval.

## Laws

- A segment is oriented. `start` and `end` are not interchangeable: a segment and its `reversed` are unequal and hash apart, unless the endpoints coincide. Coincident endpoints are valid. `reversed` applied twice gives back the original.
- `map` transforms `start` first, then `end`, each exactly once. If the transform fails on `start`, it is never called on `end`.
- `displacement(using:)` measures from `start` to `end`. Under a lawful affine relation, the displacement of `reversed` is its inverse.
- `translated(by:using:)` moves both endpoints by the same displacement, in the order `map` uses. Under a lawful affine relation it keeps the orientation and the `displacement(using:)` value. If a translation fails, nothing changes: the original segment stays as it was and no partly moved segment is returned.
