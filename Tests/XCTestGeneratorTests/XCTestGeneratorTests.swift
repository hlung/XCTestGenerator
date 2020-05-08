import XCTest
@testable import XCTestGenerator

final class XCTestGeneratorTests: XCTestCase {
  func test_generate() {

    let output = Episode()
    let array = XCTestGenerator.generateAsStringArray(for: output, name: "output")

    let expected = [
      #"// Media"#,
      #"XCTAssertEqual(output.name, "Some media")"#,
      #"XCTAssertEqual(output.array, ["foo", "bar"])"#,
      #"XCTAssertEqual(output.stringDict, ["en": "Hi"])"#,
      #"XCTAssertEqual(output.intDict, ["en": 11, "es": 22])"#,
      #""#,
      #"// Episode"#,
      #"XCTAssertEqual(output.number, 42)"#,
      #"XCTAssertEqual(output.someOptional, "some optional")"#,
      #"XCTAssertEqual(output.someNil, nil)"#,
      #"XCTAssertEqual(output.date, Date(timeIntervalSince1970: 12345.0))"#,
      #"XCTAssertEqual(output.bool, true)"#,
      #"XCTAssertEqual(output.simpleStruct, SimpleStruct(foo: "foo!", bar: "bar?"))"#,
      #"XCTAssertEqual(output.simpleClass, SimpleClass(foo: "foo!", bar: "bar?"))"#
    ]
    for i in 0..<array.count {
      XCTAssertEqual(array[i], expected[i])
    }
  }

//  static var allTests = [
//    ("testExample", testExample),
//  ]

  func test_remove_optional() {
    XCTAssertEqual(
      #"Optional("ja") Optional("ja")"#.removingAllOptionals(),
      #""ja" "ja""#
    )
  }

  func test_remove_optional_nested() {
    XCTAssertEqual(
      #"Optional(a, Optional("ja"), Optional("ja"))"#.removingAllOptionals(),
      #"a, "ja", "ja""#
    )
  }
}

struct SimpleStruct {
  let foo: String = "foo!"
  let bar: String? = "bar?"
}

struct SimpleClass {
  let foo: String = "foo!"
  let bar: String? = "bar?"
}

class Media {
  let name: String = "Some media"
  let array: [String] = ["foo", "bar"]
  // note: printing a dictionary randomizes order, making test fails sometimes. so just test with one entry for now.
  let stringDict: [String: String] = ["en": "Hi"]
  let intDict: [String: Int] = ["en": 11, "es": 22]
}

class Episode: Media {
  let number: Int = 42
  let someOptional: String? = "some optional"
  let someNil: String? = nil
  let date: Date = Date(timeIntervalSince1970: 12345)
  let bool: Bool = true
  let simpleStruct = SimpleStruct()
  let simpleClass = SimpleClass()
}
