import Foundation

@MainActor
final class CustomerViewModel {
 
    // MARK: Properties
    private let service: any CustomerServiceProtocol
    
    weak var delegate: CustomerViewModelDelegate?

    private(set) var customers: [Customer] = []
    // MARK: Initializer
    init(service: any CustomerServiceProtocol) {
         self.service = service
     }
    // MARK: Methods
    func loadCustomers() async {
        do {
            customers = try await service.fetchCustomers()
            delegate?.didLoadCustomers()

        } catch {
            delegate?.didFailLoadingCustomers(error)
        }
    }
}
