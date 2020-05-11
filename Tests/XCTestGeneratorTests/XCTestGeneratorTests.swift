import XCTest
@testable import XCTestGenerator

final class XCTestGeneratorTests: XCTestCase {

  func test_generate() {
    let input = Episode()
    let output = XCTestGenerator.generate(for: input, name: "output")
    print(output)

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

//  func test_string_removing_all_optionals() {
//    XCTAssertEqual(
//      #"Optional(1, Optional("ja"), Optional("ja"))"#.removingAllOptionals(),
//      #"1, "ja", "ja""#
//    )
//  }

//  func test_wrap_url() {
//    XCTAssertEqual(
//      #"Viki.Images.Image(url: https://fakeimage.com, source: "viki"))"#.wrapURLsWithInitializers(),
//      #"Viki.Images.Image(url: URL(string: "https://fakeimage.com")!, source: "viki"))"#
//    )
//  }

//  static var allTests = [
//    ("testExample", testExample),
//  ]
}

struct SimpleStruct {
  let foo: String = "foo!"
  let bar: String? = "bar"
}

struct SimpleClass {
  let foo: String = "foo!"
  let bar: String? = "bar"
}

class Media {
  let name: String = "Some media"
  let array: [String] = ["foo", "bar"]
  // note: printing a dictionary randomizes order, making test fails sometimes.
  // so just test with one entry for now.
  let stringDict: [String: String] = ["en": "Hi"]
}

class Episode: Media {
  let number: Int = 42
  let intDict: [String: Int]? = ["en": 11]
  let someOptional: String? = "some optional"
  let someNil: String? = nil
  let date: Date = Date(timeIntervalSince1970: 12345)
  let bool: Bool = true
  let url: URL = URL(string: "https://www.google.com")!
  let simpleStruct = SimpleStruct()
  let simpleClass: SimpleClass? = SimpleClass()
}

