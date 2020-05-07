import Foundation

class XCTestGenerator {
  class func generateXCAssertEqualStrings(for variable: Any, name: String) -> String {
    Mirror(reflecting: variable)
      .generateXCAssertEqualStrings(variableName: name)
      .joined(separator: "\n")
  }
}

private extension Mirror {

  // Possible improvement
  // - Only generate for children that conforms to Equatable.
  //   But Equatable has Self requirement, which makes checking protocol
  //   conformance checking not possible :(
  //   So just remove things you don't want to check manually for now.
  func generateXCAssertEqualStrings(variableName: String) -> [String] {
    var output: [String] = []

    if let superclassMirror = superclassMirror {
      output += superclassMirror.generateXCAssertEqualStrings(variableName: variableName)
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
