//
//  SearchVC.swift
//  PGProject
//
//  Created by ZiyoMukhammad Usmonov on 19/11/22.
//

import UIKit


class SearchVC: UIViewController {
    
    let logoImageView = UIImageView()
    let sinceIdTextField = PGTextField()
    let callToActionButton = PGButton(color: .systemGreen, title: "Get users", systemImageName: "person.3")
    
    var isSinceIdEntered: Bool { return !sinceIdTextField.text!.isEmpty }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addsubViews(logoImageView, sinceIdTextField, callToActionButton)

        
        configureImageView()
        configureTextField()
        configureCallToActionButton()
        createDismissKeyboardTapGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sinceIdTextField.text = ""
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    @objc func pushGitHubUsersVC() {
        guard isSinceIdEntered else {
            presentPGAlertOnMainThread(title: "Empty id number", message: "Please enter user id", buttonTitle: "Ok")
             return
        }
        sinceIdTextField.resignFirstResponder()
        let githubUsersVC = GitHubUsersVC(sinceId: Int(sinceIdTextField.text!)!)
        navigationController?.pushViewController(githubUsersVC, animated: true)
    }
    
    func configureImageView() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = Images.ghLogo
        
        let topConstraintConstant: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? 20 : 80

        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topConstraintConstant),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    func configureTextField() {
        sinceIdTextField.delegate = self
        NSLayoutConstraint.activate([
            sinceIdTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),
            sinceIdTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            sinceIdTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            sinceIdTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configureCallToActionButton() {
        callToActionButton.addTarget(self, action: #selector(pushGitHubUsersVC), for: .touchUpInside)
        NSLayoutConstraint.activate([
            callToActionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            callToActionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            callToActionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            callToActionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}


extension SearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushGitHubUsersVC()
        return true
    }
}
