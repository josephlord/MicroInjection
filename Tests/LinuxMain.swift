import XCTest

import MicroInjectionTests

var tests = [XCTestCaseEntry]()
tests += MicroInjectionTests.allTests()
XCTMain(tests)
