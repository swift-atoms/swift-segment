# Segment

An oriented pair of endpoints, independent of coordinate storage, numeric arithmetic,
or a particular affine interpretation.

```swift
import Segment

let interval = Segment(from: 3, to: 8)
let reversed = interval.reversed
```

For geometric endpoints, import their owner:

```swift
import Segment
import Point

let edge = Segment(from: Point(x: 1, y: 2), to: Point(x: 4, y: 6))
```

Segment itself has no production dependencies. Point and Tagged are test dependencies;
a generic endpoint parameter does not create a dependency on a particular Point implementation.
Coincident endpoints are valid, equality is oriented, and no ordering or additive
conformance is supplied. Explicit affine operations are provided by Point Affine.
