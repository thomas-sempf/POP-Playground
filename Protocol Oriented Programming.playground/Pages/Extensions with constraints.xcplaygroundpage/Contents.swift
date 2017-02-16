/*:
 # Extensions with constraints
 
 Shows how to add extensions with constains concering an associated type
 */
import UIKit

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

extension DataProvider where KeyType == IndexPath {
    func allItems(inSection section: Int) -> [ItemType] {
        return allKeys
            .filter({ $0.section == section })
            .flatMap({ item(for: $0) })
    }
}

// Table View Data Source

struct TableViewDataSource: DataProvider {
    typealias ItemType = UIColor
    typealias KeyType = IndexPath
    
    private var items: [IndexPath: UIColor] = [
        IndexPath(row: 0, section: 0): .black,
        IndexPath(row: 1, section: 0): .yellow,
        IndexPath(row: 2, section: 0): .blue
    ]
    
    var allKeys: [IndexPath] {
        return items.enumerated().map({ IndexPath(row: $0.offset, section: 0) })
    }
    
    func item(for key: IndexPath) -> UIColor? {
        return items[key]
    }
    
    mutating func set(item: UIColor, for key: IndexPath) {
        items[key] = item
    }
}

var tableViewDataSource = TableViewDataSource()
tableViewDataSource.item(for: IndexPath(row: 0, section: 0))
tableViewDataSource.allKeys
tableViewDataSource.allItems(inSection: 1)
tableViewDataSource.allItems(inSection: 0)

struct StringDataProvider: DataProvider {
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

stringDataSource.set(item: "9", for: "Blah")
stringDataSource.item(for: "Blah")

//: [Next](@next)
