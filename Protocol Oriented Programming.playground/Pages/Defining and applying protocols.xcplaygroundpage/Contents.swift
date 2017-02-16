/*:
 # Defining and applying protocols

   Simple protocol, like we have in Obj-C/C#,etc.
 
   Can contain variables definitions and functions
 
*/
protocol DataProvider {
    var allKeys: [String] { get }
    
    func item(for key: String) -> Any?
    
    mutating func set(item: Any, for key: String)
}

//: Simple data provider struct adapting to the protocol
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

//: Usage of the protocol
var anyDataProvider = AnyDataProvider()

anyDataProvider.set(item: "Bar", for: "Foo")
anyDataProvider.set(item: "B", for: "A")

anyDataProvider.item(for: "Foo")

//: [Next](@next)
