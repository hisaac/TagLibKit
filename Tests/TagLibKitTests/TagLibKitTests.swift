import XCTest
@testable import TagLibKit

final class TagLibKitTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(TagLibKit().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
