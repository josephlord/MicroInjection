import XCTest
@testable import MicroInjection

final class MicroInjectionTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(MicroInjection().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
