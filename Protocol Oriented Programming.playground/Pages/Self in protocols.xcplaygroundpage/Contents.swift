/*:
 # Self in protocols
 
 Shows how to user Self in protocol context
 */

protocol FileLoadable {
    static func loadFromFile() -> Self
}

protocol DataProvider {
    associatedtype ItemType
    associatedtype KeyType
    
    var allKeys: [KeyType] { get }
    
    func item(for key: KeyType) -> ItemType?
    mutating func set(item: ItemType, for key: KeyType)
}

extension DataProvider where KeyType == String {
    func itemsFiltered(by searchTerm: String) -> [ItemType] {
        return allKeys
            .filter({ $0.contains(searchTerm) })
            .flatMap({ item(for: $0) })
    }
    
    func itemsSortedAlphabetically() -> [ItemType] {
        return allKeys
            .sorted()
            .flatMap({ item(for: $0) })
    }
}

struct StringDataProvider: DataProvider, FileLoadable {
    internal static func loadFromFile() -> StringDataProvider {
        // Loading here...
        return StringDataProvider()
    }
    
    typealias ItemType = String
    typealias KeyType = String
    
    private var items = [String: String]()
    
    var allKeys: [String] {
        return Array(items.keys)
    }
    
    func item(for key: String) -> String? {
        return items[key]
    }
    
    mutating func set(item: String, for key: String) {
        items[key] = item
    }
}

var stringDataSource = StringDataProvider()
stringDataSource.set(item: "Foo", for: "Bar")
stringDataSource.item(for: "Bar")

// This is not working with FileLoadable as return... USE Self
var newStringDataSource = StringDataProvider.loadFromFile()
newStringDataSource.set(item: "Blah", for: "Foo")
newStringDataSource.item(for: "Foo")


//: [Next](@next)
