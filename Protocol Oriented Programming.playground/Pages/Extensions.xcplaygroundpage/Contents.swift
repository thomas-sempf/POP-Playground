/*: 
 # Extensions

 ### Overloading rules
 
 * IF the inferred type of a variable is the protocol:
    * AND the method is defined in the original protocol
        * THEN the runtime type’s implementation is called, irrespective of whether there is a default implementation in the extension.
    * AND the method is not defined in the original protocol,
        * THEN the default implementation is called.
 * ELSE IF the inferred type of the variable is the type
    * THEN the type’s implementation is called.
*/


protocol DataProvider {
    var allKeys: [String] { get }
    
    func item(for key: String) -> Any?
    mutating func set(item: Any, for key: String)
}

//: Extension of the protocol with utility functions
extension DataProvider {
    func itemsFiltered(by searchTerm: String) -> [Any] {
        return allKeys
            .filter({ $0.contains(searchTerm) })
            .flatMap({ item(for: $0) })
    }
    
    func itemsSortedAlphabetically() -> [Any] {
        return allKeys
            .sorted()
            .flatMap({ item(for: $0) })
    }
}

struct AnyDataProvider: DataProvider {
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

var anyDataProvider = AnyDataProvider()

anyDataProvider.set(item: "Bar", for: "Foo")
anyDataProvider.set(item: "B", for: "A")

anyDataProvider.item(for: "Foo")

//: Usage of utility functions
anyDataProvider.itemsFiltered(by: "oo")
anyDataProvider.itemsSortedAlphabetically()


//: String based adaption of the DataProvider protocol

struct StringDataProvider: DataProvider {
    private var items = [String: String]()
    
    var allKeys: [String] {
        return Array(items.keys)
    }
    
    func item(for key: String) -> Any?/*String?*/ {
        return items[key]
    }
    
    mutating func set(item: Any/*String*/, for key: String) {
        guard let stringItem = item as? String else {
            fatalError("False Type")
        }
        items[key] = stringItem
    }
}

var stringDataProvider = StringDataProvider()
stringDataProvider.set(item: "Bar", for: "Foo")
stringDataProvider.item(for: "Bar")


//: Array with DataProvider(s)
var dataProviders: [DataProvider] = [anyDataProvider, stringDataProvider]
dataProviders.forEach({ print($0.item(for: "Foo") ?? "not found") })


//: Here we have a fatal error because we are trying to set the wrong type into the StringDataProvider
//stringDataProvider.set(item: 9, for: "Blah")
stringDataProvider.item(for: "Blah")

//: [Next](@next)
