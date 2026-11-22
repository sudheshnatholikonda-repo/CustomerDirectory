import Foundation

protocol CustomerViewModelDelegate: AnyObject {
    func didLoadCustomers()
    func didFailLoadingCustomers(_ error: Error)
}
