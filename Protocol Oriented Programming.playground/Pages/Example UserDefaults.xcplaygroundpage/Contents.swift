/*:
 # More typesafe UserDefaults

 Example of POP to make the usage of UserDefaults more typesafe
 */


//: BAD, stringly typed
PGUserDefaults.standard.set(true, forKey: "FooBar")
PGUserDefaults.standard.bool(forKey: "BarFoo")

//: Better approach using protocols

protocol BoolDataProvider {
    associatedtype BoolKeyType: RawRepresentable // Protocol to suppoert enums later on

    func item(for key: BoolKeyType) -> Bool?
    mutating func set(item: Bool, for key: BoolKeyType)
}

extension BoolDataProvider where BoolKeyType.RawValue == String {
    func item(for key: BoolKeyType) -> Bool? {
        return PGUserDefaults.standard.bool(forKey: key.rawValue)
    }
    
    func set(item: Bool, for key: BoolKeyType) {
        PGUserDefaults.standard.set(item, forKey: key.rawValue)
    }
}

enum AppSettingsBool: String {
    case isUserLoggedIn
    case isAllCached
    case hasFirstSetupFinished
}

extension PGUserDefaults: BoolDataProvider {
    typealias BoolKeyType = AppSettingsBool
}

PGUserDefaults.standard.set(item: true, for: .isAllCached)
PGUserDefaults.standard.item(for: .isAllCached)

PGUserDefaults.standard.set(item: true, for: .hasFirstSetupFinished)
PGUserDefaults.standard.item(for: .hasFirstSetupFinished)

protocol StringDataProvider {
    associatedtype StringKeyType: RawRepresentable
    
    func item(for key: StringKeyType) -> String?
    mutating func set(item: String, for key: StringKeyType)
}

extension StringDataProvider where StringKeyType.RawValue == String {
    func item(for key: StringKeyType) -> String? {
        return PGUserDefaults.standard.string(forKey: key.rawValue)
    }
    
    func set(item: String, for key: StringKeyType) {
        PGUserDefaults.standard.set(item, forKey: key.rawValue)
    }
}

enum AppSettingsString: String {
    case userName
    case userPassword
}


extension PGUserDefaults: StringDataProvider {
    typealias StringKeyType = AppSettingsString
}

PGUserDefaults.standard.set(item: "Thomas", for: .userName)
PGUserDefaults.standard.item(for: .userName)

PGUserDefaults.standard.set(item: "blah", for: .userPassword)
PGUserDefaults.standard.item(for: .userPassword)

//: [Next](@next)
