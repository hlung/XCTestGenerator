# XCTestGenerator

![](https://github.com/hlung/XCTestGenerator/workflows/Swift/badge.svg)

A Swift Package for generating simple XCTest code from any variable.

## Requirements

- Swift 5.1

# Story

Suppose you have an `Episode` class with several properties. Something like this.
```swift
struct SimpleStruct {
  let foo: String = "foo!"
  let bar: String? = "bar"
}

struct SimpleClass {
  let foo: String = "foo!"
  let bar: String? = "bar"
}

class Episode {
  let number: Int = 42
  let intDict: [String: Int] = ["en": 11]
  let someOptional: String? = "some optional"
  let someNil: String? = nil
  let date: Date = Date(timeIntervalSince1970: 12345)
  let bool: Bool = true
  let url: URL = URL(string: "https://www.google.com")!
  let simpleStruct = SimpleStruct()
  let simpleClass = SimpleClass()
}

```

All property values are set up here. But in real world, you might write a Decodable function `init(from decoder:)` to parse from JSON data, handling some edge cases. How do you confirm all properties are parsed correctly? Of course by checking all the properties. But writing each test case for each property is tedious.

What if you can generate it?

Using Swift's [Reflection](https://developer.apple.com/documentation/swift/mirror) in Standard Library. We can iterate through all properties use that to generate some code! 

So this...
```swift
let episode = Episode()
let output = XCTestGenerator.generate(for: episode, name: "output")
```

will generate this code...
```swift
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
XCTAssertEqual(output.simpleClass.foo, "foo!")
XCTAssertEqual(output.simpleClass.bar, "bar")
XCTAssertEqual(output.simpleClass.bar, "bar")
```

You can copy this code to your test files and run. 🎉
