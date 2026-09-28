#if Affine
#if os(macOS)
import Foundation
import Testing

private final class TemporalCompilerBoundaryBundle: NSObject {}

@Test
func `Importing temporal composition does not grant instant protocol conformances`() throws {
    let tests = URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent()
    let script = tests.appendingPathComponent("Temporal Typechecking/Verify.swift")
    let products = Bundle(for: TemporalCompilerBoundaryBundle.self).bundleURL.deletingLastPathComponent()
    let scratch = FileManager.default.temporaryDirectory
        .appendingPathComponent("temporal-compiler-test-\(UUID().uuidString)")
    try FileManager.default.createDirectory(at: scratch, withIntermediateDirectories: true)

    let process = Process()
    process.executableURL = URL(fileURLWithPath: "/usr/bin/xcrun")
    process.arguments = [
        "swift", "-module-cache-path", scratch.path, script.path, products.path,
    ]
    let pipe = Pipe()
    process.standardOutput = pipe
    process.standardError = pipe
    try process.run()
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    process.waitUntilExit()
    let diagnostics = String(decoding: data, as: UTF8.self)
    #expect(process.terminationStatus == 0, "\(diagnostics)")
}
#endif
#endif
