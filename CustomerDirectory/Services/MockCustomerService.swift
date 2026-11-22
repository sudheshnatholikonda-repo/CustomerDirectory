import Foundation

final class MockCustomerService: CustomerServiceProtocol {

    func fetchCustomers() async throws -> [Customer] {

        return [
            Customer(
                id: 1,
                name: "John Smith",
                email: "john@example.com"
            ),
            Customer(
                id: 2,
                name: "Sarah Wilson",
                email: "sarah@example.com"
            ),
            Customer(
                id: 3,
                name: "David Lee",
                email: "david@example.com"
            )
        ]
    }
}
