import Foundation
import Segment
import Testing

@Suite
struct `Segment values` {
    private enum Station { case departure, arrival }

    @Test
    func `Endpoints do not require arithmetic or coordinates`() {
        let segment = Segment(from: Station.departure, to: .arrival)
        #expect(segment.start == .departure)
        #expect(segment.end == .arrival)
    }

    @Test
    func `Both natural initializers preserve endpoint order`() {
        #expect(Segment(from: 3, to: 8) == Segment(start: 3, end: 8))
    }

    @Test
    func `Reversing twice restores the original segment`() {
        let segment = Segment(from: 3, to: 8)
        #expect(segment.reversed == Segment(from: 8, to: 3))
        #expect(segment.reversed.reversed == segment)
    }

    @Test
    func `Equality and hashing preserve orientation`() {
        let segment = Segment(from: 3, to: 8)
        #expect(segment != segment.reversed)
        #expect(Set([segment, segment, segment.reversed]).count == 2)
    }

    @Test
    func `Coincident endpoints are valid`() {
        let segment = Segment(from: 3, to: 3)
        #expect(segment.reversed == segment)
    }

    @Test
    func `Endpoint mutation preserves value semantics`() {
        let original = Segment(from: 3, to: 8)
        var copy = original
        copy.start = 5
        copy.end = 10
        #expect(original == Segment(from: 3, to: 8))
        #expect(copy == Segment(from: 5, to: 10))
    }

    @Test
    func `Mapping visits endpoints once in order`() {
        var visited: [Int] = []
        let mapped = Segment(from: 3, to: 8).map {
            visited.append($0)
            return String($0)
        }
        #expect(visited == [3, 8])
        #expect(mapped == Segment(from: "3", to: "8"))
    }

    private enum Failure: Error { case rejected }

    @Test
    func `Mapping propagates its concrete error and stops at the first failure`() {
        var visited: [Int] = []
        do {
            _ = try Segment(from: 3, to: 8).map { (value) throws(Failure) -> Int in
                visited.append(value)
                throw .rejected
            }
            Issue.record("Expected mapping failure")
        } catch {
            let failure: Failure = error
            #expect(failure == .rejected)
        }
        #expect(visited == [3])
    }

    @Test
    func `Mapping propagates failure from the second endpoint`() {
        var visited: [Int] = []
        do {
            _ = try Segment(from: 3, to: 8).map { (value) throws(Failure) -> Int in
                visited.append(value)
                if value == 8 { throw .rejected }
                return value
            }
            Issue.record("Expected mapping failure")
        } catch {
            #expect(error == .rejected)
        }
        #expect(visited == [3, 8])
    }

    @Test
    func `Sendability follows the endpoint type`() {
        func requireSendable<T: Sendable>(_ value: T) {}
        requireSendable(Segment(from: 3, to: 8))
    }
}

@Test func `Segment encodes endpoints without requiring decoding`() throws {
    struct Endpoint: Encodable { let value: Int }
    let data = try JSONEncoder().encode(Segment(from: Endpoint(value: 1), to: Endpoint(value: 2)))
    let object = try JSONSerialization.jsonObject(with: data) as? [String: [String: Int]]
    #expect(object == ["start": ["value": 1], "end": ["value": 2]])
}

@Test func `Segment decodes endpoints without requiring encoding`() throws {
    struct Endpoint: Decodable { let value: Int }
    let data = Data(#"{"start":{"value":1},"end":{"value":2}}"#.utf8)
    let value = try JSONDecoder().decode(Segment<Endpoint>.self, from: data)
    #expect(value.start.value == 1)
    #expect(value.end.value == 2)
}
