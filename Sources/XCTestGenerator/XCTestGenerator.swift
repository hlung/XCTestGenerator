import Foundation

public class XCTestGenerator {

  /// Example:
  /// let string = XCTestGenerator.generate(for: output, name: "output")
  public class func generate(for variable: Any, name: String) -> String {
    Mirror(reflecting: variable)
      .generateXCAssertEqualStrings(variableName: name)
      .joined(separator: "\n")
  }

  class func generateAsStringArray(for variable: Any, name: String) -> [String] {
    Mirror(reflecting: variable)
      .generateXCAssertEqualStrings(variableName: name)
  }

}

private extension Mirror {

  func generateXCAssertEqualStrings(variableName: String) -> [String] {
    var output: [String] = []
    output += ["-------------------"]

    if let superclassMirror = superclassMirror {
      output += superclassMirror.generateXCAssertEqualStrings(variableName: variableName)
      output += [""]
    }

    output += ["// \(subjectType)"]

    for c in children {
      guard var name = c.label else { continue }
      name = variableName + "." + name

      let value = c.value
      var valueString: String
      if let string = value as? String {
        valueString = "\"\(string)\""
      }
      else if let date = value as? Date {
        valueString = "Date(timeIntervalSince1970: \(date.timeIntervalSince1970))"
      }
      else {
        valueString = "\(value)"
      }

      // Replace "Optional(x)" with "x"
      valueString = valueString.removingAllOptionals()
      valueString = valueString.wrapURLsWithInitializers()

      output += ["XCTAssertEqual(\(name), \(valueString))"]
    }

    output += ["-------------------"]
    return output
  }

}

extension String {
  func wrapURLsWithInitializers() -> String {
    let pattern = #"[^"](https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*))[^"]"#
    return replacingOccurrences(of: pattern, with: "URL(string: \"$1\")!", options: .regularExpression)
  }

  func removingAllOptionals() -> String {
    var input = self

    // loop to remove handle nested parentheses
    while true {
      let output = input.replacingOccurrences(of: #"Optional\((.*?)\)"#,
                                              with: "$1",
                                              options: .regularExpression)
      if output == input {
        return output
      }
      else {
        input = output
      }
    }
  }
}
