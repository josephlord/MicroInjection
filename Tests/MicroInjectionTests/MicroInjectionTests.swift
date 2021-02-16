import XCTest
@testable import MicroInjection

fileprivate class Foo {
    let text: String
    init(text: String) {
        self.text = text
    }
}

fileprivate struct AKey : InjectionKey {
    static var defaultValue = "a"
}

extension InjectionValues {
    fileprivate var a: String {
        get { self[AKey.self] }
        set { self[AKey.self] = newValue }
    }
}

final class MicroInjectionTests: XCTestCase {
    func testDefaultValue() {
        struct TestKey : InjectionKey {
            static var defaultValue = 5
        }
        let injection = InjectionValues()
        XCTAssertEqual(injection[TestKey.self], 5)
    }

    func testDefaultValueComputed() {
        struct TestKey : InjectionKey {
            static var lastValue = 0
            static var defaultValue: Int {
                let next = lastValue + 5
                lastValue = next
                return next
            }
        }
        let injection = InjectionValues()
        XCTAssertEqual(injection[TestKey.self], 5)
        XCTAssertEqual(injection[TestKey.self], 10)
    }
    
    func testSetValue() {
        struct TestKey : InjectionKey {
            static var defaultValue = 5
        }
        var injection = InjectionValues()
        injection[TestKey.self] = 8
        XCTAssertEqual(injection[TestKey.self], 8)
    }
    
    func testDefaultObject() {
        struct TestKey : InjectionKey {
            static var defaultValue = Foo(text: "default")
        }
        let injection = InjectionValues()
        XCTAssertEqual(injection[TestKey.self].text, "default")
    }
    
    func testSetObject() {
        struct TestKey : InjectionKey {
            static var defaultValue = Foo(text: "default")
        }
        var injection = InjectionValues()
        injection[TestKey.self] = Foo(text: "Updated")
        XCTAssertEqual(injection[TestKey.self].text, "Updated")
    }

    func testExtendInjectionDefaultValue() {
        let injection = InjectionValues()
        XCTAssertEqual(injection.a, "a")
    }

    func testExtendInjectionSetValue() {
        var injection = InjectionValues()
        injection.a = "A"
        XCTAssertEqual(injection.a, "A")
        XCTAssertEqual(injection[AKey.self], "A")
    }
    
    func testExtendInjectionSetValueSubscript() {
        var injection = InjectionValues()
        injection[AKey.self] = "A"
        XCTAssertEqual(injection.a, "A")
        XCTAssertEqual(injection[AKey.self], "A")
    }

    func testPropertyWrapperDefault() {
        class Bar : Injectable {
            let injection = InjectionValues()
            @Injection(\.a) var a
        }
        let bar = Bar()
        XCTAssertEqual(bar.a, "a")
    }
    
    func testPropertyWrapperStored() {
        class Bar : Injectable {
            init(injection: InjectionValues) {
                self.injection = injection
            }
            let injection: InjectionValues
            @Injection(\.a) var a
        }
        var injection = InjectionValues()
        injection.a = "A"
        let bar = Bar(injection: injection)
        XCTAssertEqual(bar.a, "A")
    }
    
    func testCallForUnstoredNil() {
        var hasCalledCount = 0
        let injection = InjectionValues(callForUnstoredValues: { key in
            XCTAssertEqual(String(reflecting: key), String(reflecting: AKey.self))
            hasCalledCount += 1
            return nil
        })
        XCTAssertEqual(injection.a, "a")
        XCTAssertEqual(hasCalledCount, 1)
    }
    
    func testCallForUnstoredReturn() {
        var hasCalledCount = 0
        let injection = InjectionValues(callForUnstoredValues: { key in
            XCTAssertEqual(String(reflecting: key), String(reflecting: AKey.self))
            hasCalledCount += 1
            return "A"
        })
        XCTAssertEqual(injection.a, "A")
        XCTAssertEqual(hasCalledCount, 1)
    }
    
    func testCallForUnstoredNoCallWhenStored() {
        var hasCalledCount = 0
        var injection = InjectionValues(callForUnstoredValues: { key in
            hasCalledCount += 1
            return "Z"
        })
        injection.a = "A"
        XCTAssertEqual(injection.a, "A")
        XCTAssertEqual(hasCalledCount, 0)
    }
    
    func testExtendInjectionResetValue() {
        var injection = InjectionValues()
        injection.a = "A"
        injection.resetToDefault(key: AKey.self)
        XCTAssertEqual(injection.a, "a")
        XCTAssertEqual(injection[AKey.self], "a")
    }


    func testExtendInjectionSetValueClosure() {
        var injection = InjectionValues()
        injection.set(key: AKey.self) { "A" }
        XCTAssertEqual(injection.a, "A")
        XCTAssertEqual(injection[AKey.self], "A")
    }

    func testPropertyWrapperComputed() {
        class Bar : Injectable {
            init(injection: InjectionValues) {
                self.injection = injection
            }
            let injection: InjectionValues
            @Injection(\.a) var a
        }
        var injection = InjectionValues()
        injection.set(key: AKey.self) { "A" }
        let bar = Bar(injection: injection)
        XCTAssertEqual(bar.a, "A")
    }
    
// I would like to be able to make this work but don't currently know a
// mechanism to support structs being Injectable. This is a nice to have if
// anyone has a solution it would be great.
//    func injectableStruct() {
//        struct Baz : Injectable {
//            let injection = InjectionValues()
//        }
//    }
    
    static var allTests = [
        ("testDefaultValue", testDefaultValue),
        ("testDefaultValueComputed", testDefaultValueComputed),
        ("testSetValue", testSetValue),
        ("testDefaultObject", testDefaultObject),
        ("testSetObject", testSetObject),
        ("testExtendInjectionDefaultValue", testExtendInjectionDefaultValue),
        ("testExtendInjectionSetValue", testExtendInjectionSetValue),
        ("testExtendInjectionSetValueSubscript", testExtendInjectionSetValueSubscript),
        ("testPropertyWrapperDefault", testPropertyWrapperDefault),
        ("testPropertyWrapperStored", testPropertyWrapperStored),
        ("testCallForUnstoredNil", testCallForUnstoredNil),
        ("testCallForUnstoredReturn", testCallForUnstoredReturn),
        ("testCallForUnstoredNoCallWhenStored", testCallForUnstoredNoCallWhenStored),
        ("testExtendInjectionSetValueClosure", testExtendInjectionSetValueClosure),
        ("testPropertyWrapperComputed", testPropertyWrapperComputed),
    ]
}
