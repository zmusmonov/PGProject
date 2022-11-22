//
//  UserOrganizationVC.swift
//  PGProject
//
//  Created by ZiyoMukhammad Usmonov on 22/11/22.
//

import UIKit

class UserOrganizationVC: PGDataLoadingVC {
    
    let tableView = UITableView()
    var organiztions: [UserOrganization] = []
    var url: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .blue
        configureVC()
        getOrganizations()
        configureTableView()
    }
    
    func getOrganizations() {
        
        NetworkManager.shared.performApiCall(urlString: url, expextingReturnType: [UserOrganization].self) { [weak self] response in
            guard let self = self else { return }

            switch response {
            case .success(let organizations):
                self.updateUI(with: organizations)
            case .failure(let error):
                self.presentPGAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }

    }
    
    func updateUI(with organizations: [UserOrganization]) {
        if organizations.isEmpty {
            DispatchQueue.main.async {
                self.showEmptyStateView(with: "User has no organizations.", in: self.view)
            }
        } else {
            self.organiztions = organizations
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.view.bringSubviewToFront(self.tableView)
            }
        }
    }
    
    
    private func configureVC() {
        view.backgroundColor = .systemBackground
        title = "Organizations"
        navigationController?.navigationBar.prefersLargeTitles = true
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
        
    }

    @objc func dismissVC() {
        dismiss(animated: true)
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        
        tableView.frame         = view.bounds
        tableView.rowHeight     = 80
        tableView.delegate      = self
        tableView.dataSource    = self
        
        tableView.register(UserOrganizationCell.self, forCellReuseIdentifier: UserOrganizationCell.reuseID)
    }
}

extension UserOrganizationVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return organiztions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserOrganizationCell.reuseID) as! UserOrganizationCell
        let organization = organiztions[indexPath.row]
        cell.set(organization: organization)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let organization = organiztions[indexPath.row]
        guard let url = URL(string: "https://github.com/\(organization.login)") else {
            presentPGAlertOnMainThread(title: "Invalid URL", message: "The URL attached to this user is invalid", buttonTitle: "Ok")
            return
        }
        presentSafariVC(with: url)

    }
}
