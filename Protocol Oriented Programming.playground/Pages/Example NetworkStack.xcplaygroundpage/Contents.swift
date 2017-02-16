/*:
 # Example Networkstack
 
 Rough example how to do a network stack with protocols
 */


import Foundation

public enum HTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

protocol Endpoint {
    var baseUrl: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: [String: Any] { get }
    var headers: [String: String] { get }
}

extension Endpoint {
    var headers: [String: String] { return [:] }
    
    var parameters: [String: Any] { return [:] }
    
    func encodedQuery(query: String) -> String {
        return query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    }
}

protocol Decodable {
    static func parse(data: Data) -> Self?
}

protocol Request: Endpoint {
    associatedtype Response: Decodable
    
    var body: String? { get }
    var retryCount: Int { get }
}

extension Request {
    var body: String? { return nil }
    var retryCount: Int { return 0 }
}

class NetworkOperation {

    func send<T: Request>(_ requestToSend: T, completion: @escaping (T.Response?) -> Void) {
        // ... Here network request code...
        /*
        case .success(let data):
        if let result = T.Response.parse(data: data) {
            completion(result)
        } else {
            completion(nil)
        }
         */
    }
}

//: Request object

struct AppVersionInformation {
    let pList: String
    let version: String
}

extension AppVersionInformation: Decodable {
    static func parse(data: Data) -> AppVersionInformation? {
        guard let jsonDict = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any],
            let pList = jsonDict["PList"] as? String,
            let version = jsonDict["Version"] as? String
            else {
                return nil
        }
        
        return AppVersionInformation(pList: pList, version: version)
    }
}

struct MyCustomRequest: Request {
    typealias Response = AppVersionInformation
    
    var baseUrl: String { return "https://test.se" }
    var path: String { return "/appversion" }
    var method: HTTPMethod { return .get }
}

//: [Next](@next)