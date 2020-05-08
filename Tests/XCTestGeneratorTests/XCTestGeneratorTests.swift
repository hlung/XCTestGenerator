import XCTest
@testable import XCTestGenerator

final class XCTestGeneratorTests: XCTestCase {

  func test_generate() {
    let episode = Episode()
    let output = XCTestGenerator.generate(for: "output", variable: episode)
    print(output)

    let expected = """
    // Media
    XCTAssertEqual(output.name, "Some media")
    XCTAssertEqual(output.array.count, 2)
    XCTAssertEqual(output.array[0], "foo")
    XCTAssertEqual(output.array[1], "bar")
    XCTAssertEqual(output.stringDict.count, 1)
    XCTAssertEqual(output.stringDict["en"], "Hi")
    XCTAssertEqual(output.intDict.count, 1)
    XCTAssertEqual(output.intDict["en"], 11)

    // Episode
    XCTAssertEqual(output.number, 42)
    XCTAssertEqual(output.someOptional, "some optional")
    XCTAssertEqual(output.someNil, nil)
    XCTAssertEqual(output.date, Date(timeIntervalSince1970: 12345.0))
    XCTAssertEqual(output.bool, true)
    XCTAssertEqual(output.url, URL(string: "https://www.google.com")!)
    XCTAssertEqual(output.simpleStruct.foo, "foo!")
    XCTAssertEqual(output.simpleStruct.bar, "bar?")
    XCTAssertEqual(output.simpleClass.foo, "foo!")
    XCTAssertEqual(output.simpleClass.bar, "bar?")
    """

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
  let bar: String? = "bar?"
}

struct SimpleClass {
  let foo: String = "foo!"
  let bar: String? = "bar?"
}

class Media {
  let name: String = "Some media"
  let array: [String] = ["foo", "bar"]
  // note: printing a dictionary randomizes order, making test fails sometimes.
  // so just test with one entry for now.
  let stringDict: [String: String] = ["en": "Hi"]
  let intDict: [String: Int] = ["en": 11]
}

class Episode: Media {
  let number: Int = 42
  let someOptional: String? = "some optional"
  let someNil: String? = nil
  let date: Date = Date(timeIntervalSince1970: 12345)
  let bool: Bool = true
  let url: URL = URL(string: "https://www.google.com")!
  let simpleStruct = SimpleStruct()
  let simpleClass = SimpleClass()
}

