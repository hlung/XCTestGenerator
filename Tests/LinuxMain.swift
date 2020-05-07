import XCTest

import XCTestGeneratorTests

var tests = [XCTestCaseEntry]()
tests += XCTestGeneratorTests.allTests()
XCTMain(tests)
