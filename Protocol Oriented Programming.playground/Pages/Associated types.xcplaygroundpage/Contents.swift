/*:
 # Associated Types
 
 Shows how to add associated types to a protocol and set a typealias in the implementation.
 */

protocol DataProvider {
    associatedtype ItemType
    
    var allKeys: [String] { get }
    
    func item(for key: String) -> ItemType?
    mutating func set(item: ItemType, for key: String)
}

extension DataProvider {
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

struct AnyDataProvider: DataProvider {
    typealias ItemType = Any
    
    private var items = [String: Any]()
    
    var allKeys: [String] {
        return Array(items.keys)
    }
    
    func item(for key: String) -> Any? {
        return items[key]
    }
    
    mutating func set(item: Any, for key: String) {
        items[key] = item
    }
}

struct StringDataProvider: DataProvider {
    typealias ItemType = String
    
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

var anyDataProvider = AnyDataProvider()

anyDataProvider.set(item: "Bar", for: "Foo")
anyDataProvider.set(item: "B", for: "A")

anyDataProvider.item(for: "Foo")

anyDataProvider.itemsFiltered(by: "oo")
anyDataProvider.itemsSortedAlphabetically()

var stringDataProvider = StringDataProvider()
stringDataProvider.set(item: "Foo", for: "Bar")
stringDataProvider.item(for: "Bar")

stringDataProvider.set(item: "9", for: "Blah")
stringDataProvider.item(for: "Blah")

//: Not working anymore because of associatedtypes usage, could be fixed with Type Erasures, see file in this playground

//var dataProviders = [anyDataProvider as DataProvider, stringDataProvider as DataProvider]
//dataProviders.forEach({ print($0.item(for: "Foo") ?? "not found") })


//: [Next](@next)
