import XCTest
@testable import XCTestGenerator

final class XCTestGeneratorTests: XCTestCase {
  func testExample() {

    let output = Episode()
    let string = XCTestGenerator.generateXCAssertEqual(for: output, name: "output")
    //print(string)
    XCTAssertEqual(string, """
      // Media
      XCTAssertEqual(output.name, "Some media")
      XCTAssertEqual(output.array, ["foo", "bar"])
      XCTAssertEqual(output.stringDict, ["es": "Hola", "en": "Hi"])
      XCTAssertEqual(output.intDict, ["en": 11, "es": 22])

      // Episode
      XCTAssertEqual(output.number, 42)
      XCTAssertEqual(output.someOptional, "some optional")
      XCTAssertEqual(output.someNil, nil)
      XCTAssertEqual(output.date, Date(timeIntervalSince1970: 12345.0))
      XCTAssertEqual(output.bool, true)
      XCTAssertEqual(output.simpleStruct, SimpleStruct(foo: "foo!", bar: "bar?"))
      XCTAssertEqual(output.simpleClass, SimpleClass(foo: "foo!", bar: "bar?"))
      """)
  }

  static var allTests = [
    ("testExample", testExample),
  ]
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
  let stringDict: [String: String] = ["en": "Hi", "es": "Hola"]
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
