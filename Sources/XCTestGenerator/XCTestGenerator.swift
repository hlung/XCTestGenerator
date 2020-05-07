import Foundation

class XCTestGenerator {
  class func generateXCAssertEqual(for variable: Any, name: String) -> String {
    Mirror(reflecting: variable).generateXCAssertEqual(variableName: name).joined(separator: "\n")
  }
}

private extension Mirror {

  // Generates XCTAssertEqual(...) code from receiver
  // --- Input: ---
  //   class Episode {
  //     let number: Int = 42
  //     let someNil: String? = nil
  //   }
  // --- Output: ---
  //   XCTAssertEqual(output.number, 42)
  //   XCTAssertEqual(output.someNil, nil)
  func generateXCAssertEqual(variableName: String) -> [String] {
    var output: [String] = []

    if let superclassMirror = superclassMirror {
      output += superclassMirror.generateXCAssertEqual(variableName: variableName)
      output += [""]
    }

    output += ["// \(subjectType)"]

    for c in children {
      guard var name = c.label else { continue }
      name = variableName + "." + name

      let value = c.value
      if let string = value as? String {
        output += ["XCTAssertEqual(\(name), \"\(string)\")"]
      }
      else if let date = value as? Date {
        output += ["XCTAssertEqual(\(name), Date(timeIntervalSince1970: \(date.timeIntervalSince1970)))"]
      }
      else {
        // Replace "Optional(x)" with "x"
        let string = "\(value)".replacingOccurrences(of: "Optional\\((.+)\\)", with: "$1", options: .regularExpression)
        output += ["XCTAssertEqual(\(name), \(string))"]
      }
    }

    return output
  }

}

//func isEquatable(_ value: Any) -> Bool {
//  return (value as? AnyObject)?.conforms(to: protocol(Hashable)) ?? false
//}
