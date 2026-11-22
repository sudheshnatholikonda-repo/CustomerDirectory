import Foundation

struct Customer: Decodable, Identifiable{
  
    let id: Int
    let name: String
    let email: String
}
