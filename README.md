# XCTestGenerator

A Swift Package for generating simple XCTest code from any variable.

# Story

Suppose you have an `Episode` class with several properties. Something like this.
```swift
struct SimpleStruct {
  let foo: String = "foo!"
  let bar: String? = "bar?"
}

struct SimpleClass {
  let foo: String = "foo!"
  let bar: String? = "bar?"
}

class Episode {
  let number: Int = 42
  let someOptional: String? = "some optional"
  let someNil: String? = nil
  let date: Date = Date(timeIntervalSince1970: 12345)
  let bool: Bool = true
  let simpleStruct = SimpleStruct()
  let simpleClass = SimpleClass()
}
```

All property values are set up here. But in real world, you might write a Decodable function `init(from decoder:)` to parse from JSON data, handling some edge cases. How do you confirm all properties are parsed correctly? Of course by checking all the properties. But writing each test case for each property is tedious.

What if you can generate it?

Using Swift's [Reflection](https://developer.apple.com/documentation/swift/mirror) in Standard Library. We can iterate through all properties use that to generate some code! 

So this...
```swift
let output = Episode()
let string = XCTestGenerator.generateXCAssertEqualStrings(for: output, name: "output")
```

will generate this code...
```swift
// Episode
XCTAssertEqual(output.number, 42)
XCTAssertEqual(output.someOptional, "some optional")
XCTAssertEqual(output.someNil, nil)
XCTAssertEqual(output.date, Date(timeIntervalSince1970: 12345.0))
XCTAssertEqual(output.bool, true)
XCTAssertEqual(output.simpleStruct, SimpleStruct(foo: "foo!", bar: "bar?"))
XCTAssertEqual(output.simpleClass, SimpleClass(foo: "foo!", bar: "bar?"))
```

You can copy this code to your test files and run. 🎉
