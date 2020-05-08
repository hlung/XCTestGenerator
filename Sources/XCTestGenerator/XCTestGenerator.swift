import Foundation

public class XCTestGenerator {

  /// Example:
  /// let string = XCTestGenerator.generate(for: output, name: "output")
  public class func generate(for variable: Any, name: String) -> String {
    Mirror(reflecting: variable)
      .generateXCAssertEqualStrings(variableName: name)
      .joined(separator: "\n")
  }

  internal class func generateAsStringArray(for variable: Any, name: String) -> [String] {
    Mirror(reflecting: variable)
      .generateXCAssertEqualStrings(variableName: name)
  }

}

private extension Mirror {

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
      valueString = "\(valueString)".replacingOccurrences(of: "Optional\\((.+)\\)", with: "$1", options: .regularExpression)

      output += ["XCTAssertEqual(\(name), \(valueString))"]
    }

    return output
  }

}
