import Foundation

public class XCTestGenerator {
  /// Example:
  /// let string = XCTestGenerator.generate(for: output, name: "output")
  public class func generate(for variable: Any, name: String) -> String {
    Mirror(reflecting: variable)
      .generateStrings(forName: name)
      .joined(separator: "\n")
  }

  class func codeString(for value: Any) -> String? {
    // --- Note about why we need to check "nil" string ---
    // Mirror.Child value has `Any` type, but can provide `nil` (Swift allows Optional to Any assignment).
    // This makes checking it with `== nil` always returns false, because it is not an optional type.
    // We work around this by checking it's string representation instead.
    if "\(value)" == "nil" {
      return "nil"
    }
    else if let string = value as? String {
      return "\"\(string)\"".removingAllOptionals()
    }
    else if let string = value as? Character {
      return "\"\(string)\"".removingAllOptionals()
    }
    else if let date = value as? Date {
      return "Date(timeIntervalSince1970: \(date.timeIntervalSince1970))".removingAllOptionals()
    }
    else if let url = value as? URL {
      return "URL(string: \"\(url.absoluteString)\")!".removingAllOptionals()
    }
    else if value is Int || value is UInt || value is Float || value is Double || value is Bool {
      return "\(value)".removingAllOptionals()
    }
    // Add more supported types here
    else {
      return nil
    }
  }

}

private extension Mirror {

  func generateStrings(forName name: String) -> [String] {
    var output: [String] = []

    if let superclassMirror = superclassMirror {
      output += superclassMirror.generateStrings(forName: name)
    }

    output += ["// \(subjectType)"]
    for child in children {
      output += labelValues(for: child, name: name).map { lv in
        if lv.failed {
          return "// Type \(lv.value) of \"\(lv.label)\" is currently unsupported."
        }
        else {
          return "XCTAssertEqual(\(lv.label), \(lv.value))"
        }
      }
    }

    return output
  }

  func labelValues(for child: Mirror.Child, name: String) -> [LabelValue] {
    guard let childLabel = child.label else { return [] }
    let label = "\(name).\(childLabel)"
    let value = child.value

    var result: [LabelValue] = []
    if let v = XCTestGenerator.codeString(for: value) {
      result += [LabelValue(label: label, value: v)]
    }
    else if let array = value as? [Any] {
      // Array
      result += [LabelValue(label: label + ".count", value: "\(array.count)")]
      for i in 0..<array.count {
        let value = array[i]
        result += labelValues(for: value, name: label + "[\(i)]")
      }
    }
    else if let dict = value as? [String: Any] {
      // Dictionary
      result += [LabelValue(label: label + ".count", value: "\(dict.count)")]
      for (key, value) in dict {
        result += labelValues(for: value, name: label + "[\"\(key)\"]")
      }
    }
    else {
      // Custom Struct / Class
      let mirror = Mirror(reflecting: value)
      if !mirror.children.isEmpty {
        for c in mirror.children {
          result += labelValues(for: c, name: label)
        }
      }
      else {
        result += [LabelValue(label: label, value: "\(type(of: value))", failed: true)]
      }
    }
    return result
  }

  func labelValues(for variable: Any, name: String) -> [LabelValue] {
    var result: [LabelValue] = []

    if let value = XCTestGenerator.codeString(for: variable) {
      result += [LabelValue(label: name, value: value)]
    }
    else {
      let mirror = Mirror(reflecting: variable)
      for c in mirror.children {
        result += labelValues(for: c, name: name)
      }
    }
    return result
  }

}

extension String {
  func removingAllOptionals() -> String {
    var input = self

    // loop to remove handle nested parentheses
    while true {
      let output = input.replacingOccurrences(of: #"Optional\((.*?)\)"#, with: "$1", options: .regularExpression)
      if output == input {
        return output
      }
      else {
        input = output
      }
    }
  }
}

struct LabelValue {
  let label: String
  let value: String
  let failed: Bool

  init(label: String, value: String, failed: Bool = false) {
    self.label = label
    self.value = value
    self.failed = failed
  }
}
