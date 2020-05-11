import XCTest
@testable import XCTestGenerator

final class XCTestGeneratorTests: XCTestCase {

  func test_generate() {
    let input = Episode()
    let output = XCTestGenerator.generate(for: input, name: "output")

    let expected = """

    // Media
    XCTAssertEqual(output.name, "Some media")
    XCTAssertEqual(output.array.count, 2)
    XCTAssertEqual(output.array[0], "foo")
    XCTAssertEqual(output.array[1], "bar")
    XCTAssertEqual(output.stringDict.count, 1)
    XCTAssertEqual(output.stringDict["en"], "Hi")

    // Episode
    XCTAssertEqual(output.number, 42)
    XCTAssertEqual(output.intDict.count, 1)
    XCTAssertEqual(output.intDict["en"], 11)
    XCTAssertEqual(output.someOptional, "some optional")
    XCTAssertEqual(output.someNil, nil)
    XCTAssertEqual(output.date, Date(timeIntervalSince1970: 12345.0))
    XCTAssertEqual(output.bool, true)
    XCTAssertEqual(output.url, URL(string: "https://www.google.com")!)
    XCTAssertEqual(output.simpleStruct.foo, "foo!")
    XCTAssertEqual(output.simpleStruct.bar, "bar")
    XCTAssertEqual(output.simpleClass?.foo, "foo!")
    XCTAssertEqual(output.simpleClass?.bar, "bar")

    """

    // Split to check line-by-line so test failure can show exactly which line fails.
    let outputArray = output.split(separator: "\n")
    let expectedArray = expected.split(separator: "\n")

    XCTAssertEqual(outputArray.count, expectedArray.count)

    for i in 0..<expectedArray.count {
      XCTAssertEqual(outputArray[i], expectedArray[i])
    }
  }

  func test_code_string() {
    XCTAssertEqual(XCTestGenerator.codeString(for: 0), "0")
    XCTAssertEqual(XCTestGenerator.codeString(for: "hello"), #""hello""#)
    XCTAssertEqual(XCTestGenerator.codeString(for: true), "true")
  }

  func test_very_long_property_should_produce_swiftlint_disable_comment() {
    let input = VeryLongPropertyStruct()
    let output = XCTestGenerator.generate(for: input, name: "output", swiftLintMaxLineLength: 200)
    XCTAssertEqual(output, """

    // VeryLongPropertyStruct
    XCTAssertEqual(output.string, "During the time of the Chinese Northern Qi dynasty, a lady-in-waiting could never become a princess because of the rigid social hierarchy and the actions of many jealous rivals. Lu Zhen (Zhao Li Ying) flees from an arranged marriage and her evil stepmother and enters the palace as an attendant. She meets Prince Gao Zhan (Chen Xiao), and the two fall in love but know that their social differences would never allow them to marry.") // swiftlint:disable:this line_length

    """)
  }
}
