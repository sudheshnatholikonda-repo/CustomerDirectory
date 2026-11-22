//
//  CustomerViewController.swift
//  CustomerDirectory
//
//  Created by Sudheshna Tholikonda on 18/11/26.
//

import UIKit

@MainActor
final class CustomerViewController: UIViewController {

    // MARK: - Properties

    private let viewModel: CustomerViewModel

    private let tableView = UITableView()
    private let loadButton = UIButton(type: .system)

        // MARK: - Initializer

    init(viewModel: CustomerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
     required init?(coder: NSCoder) {
         fatalError("Use init(viewModel:) instead")
     }

    // MARK: - Lifecycle

       override func viewDidLoad() {
           super.viewDidLoad()

           title = "Customers"
           view.backgroundColor = .systemBackground

           setupUI()

           tableView.dataSource = self
           tableView.delegate = self

           viewModel.delegate = self
       }

       // MARK: - UI Setup

       private func setupUI() {
           loadButton.setTitle("Load Customers", for: .normal)

           loadButton.addTarget(
               self,
               action: #selector(loadButtonTapped),
               for: .touchUpInside
           )

           let stackView = UIStackView(
               arrangedSubviews: [tableView, loadButton]
           )

           stackView.axis = .vertical
           stackView.spacing = 12

           view.addSubview(stackView)

           stackView.translatesAutoresizingMaskIntoConstraints = false

           NSLayoutConstraint.activate([
               stackView.topAnchor.constraint(
                   equalTo: view.safeAreaLayoutGuide.topAnchor
               ),
               stackView.leadingAnchor.constraint(
                   equalTo: view.leadingAnchor,
                   constant: 16
               ),
               stackView.trailingAnchor.constraint(
                   equalTo: view.trailingAnchor,
                   constant: -16
               ),
               stackView.bottomAnchor.constraint(
                   equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                   constant: -16
               ),

               loadButton.heightAnchor.constraint(equalToConstant: 50)
           ])

           tableView.register(
               UITableViewCell.self,
               forCellReuseIdentifier: "CustomerCell"
           )
       }

       // MARK: - Button Action

       @objc private func loadButtonTapped() {
           Task {
               await viewModel.loadCustomers()
           }
       }


}

// MARK: - UITableViewDataSource

extension CustomerViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView,numberOfRowsInSection section: Int) -> Int {
        viewModel.customers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: "CustomerCell",
            for: indexPath
        )

        let customer = viewModel.customers[indexPath.row]

        var content = cell.defaultContentConfiguration()
        content.text = customer.name
        content.secondaryText = customer.email

        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator

        return cell
    }
}

// MARK: - UITableViewDelegate

extension CustomerViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath,animated: true)

        let customer = viewModel.customers[indexPath.row]

        print("Selected customer: \(customer.name)")
    }
}

extension CustomerViewController: CustomerViewModelDelegate {

    func didLoadCustomers() {
        tableView.reloadData()
    }

    func didFailLoadingCustomers(_ error: Error) {
        let alert = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )

        alert.addAction(
            UIAlertAction(title: "OK", style: .default)
        )

        present(alert, animated: true)
    }
}
