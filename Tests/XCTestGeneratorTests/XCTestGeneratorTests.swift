import XCTest
@testable import XCTestGenerator

final class XCTestGeneratorTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(XCTestGenerator().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
