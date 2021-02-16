/// Create a key that conforms to this protocol
/// Any type that conforms to SwiftUI's EnvironmentKey can adopt this conformance without changes and vice-versa.
public protocol InjectionKey {
    associatedtype Value
    /// By implementing this both the type and the mechanism to get an instance if nothing specific has been set in the InjectionValues
    static var defaultValue: Value { get }
}

/// Like EnvironmentValues but this is to be manually passed through your application and set as the
/// `injection` property on any class that you want to be able to use the `@Injection` property
/// wrapper it to get the necessary values from the
public struct InjectionValues {
    let callForUnstoredValues: ((Any) -> Any?)?
    
    /// Create new empty environment
    /// The normal behaviour is for any values that aren't in the stored dictionary just to return the defaultValue
    /// from the key type itself. Optionally you can pass a closure to handle unstored values. If it returns a value
    /// the value must be of the correct type for the ke
    /// This is mostly for testing so that you can ensure only the keys you expect to be accessed are accessed
    public init(callForUnstoredValues: ((Any) -> Any?)? = nil) {
        self.callForUnstoredValues = callForUnstoredValues
    }

    private var dict: [String: () -> (Any) ] = [:]

    /// You can call this directly but much nicer to extend InjectionValues and add a computed property to
    /// get/set it for you which is anyway required to get the `@Injection`property wrapper working
    public subscript<K>(key: K.Type) -> K.Value where K : InjectionKey {
        get {
            // If this force unwrap ever fails this whole design is wrong
            let storedValue = dict[K.dictKey].map { $0() as! K.Value }
            if let unstoredValueClosure = callForUnstoredValues,
               storedValue == nil,
               let closureResult = unstoredValueClosure(key) {
                assert(closureResult is K.Value)
                return (closureResult as? K.Value) ?? K.defaultValue
            }
            return storedValue ?? K.defaultValue
        }
        set {
            dict[K.dictKey] = { newValue as Any }
        }
    }

    /// This allows you to override with a closue so that differnent values can be computed each time if you want.
    /// This subscirpt should be used where you want a non-default computed value
    public mutating func set<K>(key: K.Type, _ closure: @escaping () -> (K.Value)) where K : InjectionKey {
        dict[K.dictKey] = closure
    }
    
    /// Remove item from the dictionary and go back to using the defaultValues for that key.
    public mutating func resetToDefault<K>(key: K.Type) where K : InjectionKey {
        dict[K.dictKey] = nil
    }
}

/// Conform to this  and you can then add `@Injection` wrapped properties to your class
public protocol Injectable : class {
    /// This is where the `@Injection` properties will actually look up their values. You will often want to
    /// inject this in the init. You can also create an empty one, expose a mutable var or even have this implemetned with a computed var
    /// potentially to access a shared app injection if you want.
    ///
    /// Note: InjectionValues is a value type which means if it isn't a computed var accessing a shared instance a copy will made when it is set.
    var injection: InjectionValues { get }
}

/// The `@Injection` property wrapper can be added to classes conforming to Injectable
/// and takes a keypath argument into InjectionValues (you should extend InjectionValues with with properties
/// that you want to be able read from the Injection
@frozen @propertyWrapper public struct Injection<Value> {

    public let keyPath: KeyPath<InjectionValues, Value>

    @inlinable public init(_ key: KeyPath<InjectionValues, Value>) {
        keyPath = key
    }

    @inlinable public static subscript<OuterSelf : Injectable> (
        _enclosingInstance instance: OuterSelf,
        wrapped wrappedKeyPath: KeyPath<OuterSelf, Value>,
        storage storageKeyPath: KeyPath<OuterSelf, Self>) -> Value {
        get {
            let keypath = instance[keyPath: storageKeyPath].keyPath
            return instance.injection[keyPath: keypath]
        }
    }

    @available(*, unavailable, message: "Expected subscript to be used")
    @inlinable public var wrappedValue: Value {
        get { fatalError() }
    }
}

extension InjectionKey {
    fileprivate static var dictKey: String {
        return String(reflecting: Self.self)
    }
}
