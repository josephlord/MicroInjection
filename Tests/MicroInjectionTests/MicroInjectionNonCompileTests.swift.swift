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

/// The intention of these tests is to prove that invalid usage will not compile. To use this uncomment the tests
/// and check that they don't compile
final class MicroInjectionCompileFailTests: XCTestCase {
    
//    func testSetWrongTypeValue() {
//        struct TestKey : InjectionKey {
//            static var defaultValue = 5
//        }
//        var injection = InjectionValues()
//        injection[TestKey.self] = "a"
//    }

//    func testExtendInjectionSetWrongTypeValue() {
//        var injection = InjectionValues()
//        injection.a = 3
//    }
    
//    func testPropertyWrapperWrongType() {
//        class Bar : Injectable {
//            let injection = InjectionValues()
//            @Injection(\.a) var a: Int
//        }
//    }
    
//    func testPropertyWrapperWrite() {
//        class Bar : Injectable {
//            let injection = InjectionValues()
//            @Injection(\.a) var a
//        }
//        let b = Bar()
//        b.a = "Can't write"
//    }
    
//    func testPropertyNonInjectableType() {
//        class Bar {
//            let injection = InjectionValues()
//            @Injection(\.a) var a
//        }
//    }
}
