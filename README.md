# XCTestGenerator

![](https://github.com/viki-org/XCTestGenerator/workflows/Swift/badge.svg)

## Requirements

- Swift 5.1

## How to use

For model types like this:
```swift
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
```

You can use this code...
```swift
let episode = Episode()
let output = XCTestGenerator.generate(for: episode, name: "output")
```

to generate this code in debug console...
```swift
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
```

Then, you can copy this code to your test file. 🎉

## Frameworks used

- Swift [Reflection](https://developer.apple.com/documentation/swift/mirror) in Standard Library.

## Known issues

- `lazy var` produces some private `$__lazy_storage_$_` variable label prefix and `nil` value.
