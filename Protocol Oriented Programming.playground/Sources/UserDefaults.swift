import Foundation

public class PGUserDefaults {
    private var items = [String: Any]()
    
    public static let standard = PGUserDefaults()
    
    private init() {
        
    }
    
    public func set(_ value: Int, forKey defaultName: String) {
        items[defaultName] = value
    }
    
    public func set(_ value: Bool, forKey defaultName: String) {
        items[defaultName] = value
    }
    
    public func set(_ value: Any?, forKey key: String) {
        items[key] = value
    }
    
    public func string(forKey defaultName: String) -> String? {
        return items[defaultName] as? String
    }
    
    public func bool(forKey defaultName: String) -> Bool {
        return (items[defaultName] as? Bool) ?? false
    }
    
    public func value(forKey key: String) -> Any? {
        return items[key]
    }
}
