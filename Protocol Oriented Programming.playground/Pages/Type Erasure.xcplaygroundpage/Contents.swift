/*:
 # Type Erasures
 
 Don't use them ;-)
 
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

struct StringDataSource: DataProvider {
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

struct StringDataSource2: DataProvider {
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

var stringDataSource = StringDataSource()
stringDataSource.set(item: "Bar", for: "Foo")
stringDataSource.item(for: "Bar")

var stringDataSourceTwo = StringDataSource2()

//var stringDS = [stringDataSource, stringDataSourceTwo]

//stringDS.forEach({ print($0.item(for: "")) })

class AnyDataProviderBoxBase<T>: DataProvider {
    var allKeys: [String] { fatalError() }
    
    func item(for key: String) -> T? {
        fatalError()
    }
    
    func set(item: T, for key: String) {
        fatalError()
    }
}

final class _DataProviderBox<Base: DataProvider>: AnyDataProviderBoxBase<Base.ItemType> {
    var base: Base
    
    init(_ base: Base) {
        self.base = base
    }
    
    override func item(for key: String) -> Base.ItemType? {
        return base.item(for: key)
    }
    
    override func set(item: Base.ItemType, for key: String) {
        base.set(item: item, for: key)
    }
}

class AnyDataProvider<T>: DataProvider {
    var _box: AnyDataProviderBoxBase<T>
    
    var allKeys: [String] { return _box.allKeys }
    
    func item(for key: String) -> T? {
        return _box.item(for: key)
    }
    
    func set(item: T, for key: String) {
        return _box.set(item: item, for: key)
    }
    
    // We constrain the initializer's associated type to match
    // our generic parameter... basically using the type system
    // to "pass" a type in to the function.
    init<U: DataProvider>(_ base: U) where U.ItemType == T {
        _box = _DataProviderBox(base)
    }
}

let anyDS = [AnyDataProvider(stringDataSource), AnyDataProvider(stringDataSourceTwo)]

anyDS.forEach({ print($0.item(for: "Foo") ?? "Not found") })

//: [Next](@next)
