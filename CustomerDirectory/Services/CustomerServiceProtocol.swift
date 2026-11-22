import Foundation

protocol CustomerServiceProtocol {
    func fetchCustomers() async throws -> [Customer]
}
