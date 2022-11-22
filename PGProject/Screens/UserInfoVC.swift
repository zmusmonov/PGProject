//
//  UserInfoVC.swift
//  PGProject
//
//  Created by ZiyoMukhammad Usmonov on 21/11/22.
//

import UIKit

protocol UserInfoVCDelegate: AnyObject {
    func didRequestGithubUsers(for sinceId: Int)
}

class UserInfoVC: PGDataLoadingVC {
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let headerView = UIView()
    let itemViewOne = UIView()
    let itemViewTwo = UIView()
    let dateLabel = PGBodyLabel(textAlignment: .center)
    var itemViews: [UIView] = []

    var username: String!
    weak var delegate: UserInfoVCDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
        configureScrollView()
        layoutUI()
        getUserInfo()
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.pinToEdges(of: view)
        contentView.pinToEdges(of: scrollView)
        
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant:  600)
        ])
    }
    
    func getUserInfo() {
        
        let url = NetworkManager.shared.endPointForUserInfo(for: username)
        
        NetworkManager.shared.performApiCall(urlString: url, expextingReturnType: GithubUserDetail.self) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let user):
                DispatchQueue.main.async { self.configureUIElements(with: user) }
            case .failure(let error):
                self.presentPGAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    
    func configureUIElements(with user: GithubUserDetail) {
        self.add(childVC: PGUserInfoHeaderVC(user: user), to: self.headerView)
        self.add(childVC: PGRepoItemVC(user: user, delegate: self), to: self.itemViewOne)
        self.add(childVC: PGFollowerItemVC(user: user, delegate: self), to: self.itemViewTwo)
        self.dateLabel.text = "GitHub since \(user.createdAt.convertToMonthYearFormat())"
    }
    
    func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }

    func layoutUI() {
        let padding: CGFloat = 20
        let itemHeight: CGFloat = 140
        
        itemViews = [headerView, itemViewOne, itemViewTwo, dateLabel]
        
        for item in itemViews {
            contentView.addSubview(item)
            item.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                item.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
                item.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            ])
        }
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 200),
            
            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),
            
            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
            itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),
            
            dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
}


extension UserInfoVC: PGRepoItemInfoVCDelegate {
    
    func didTapGitHubProfile(for user: GithubUserDetail) {
        guard let url = URL(string: user.htmlUrl) else {
            presentPGAlertOnMainThread(title: "Invalid URL", message: "The URL attached to this user is invalid", buttonTitle: "Ok")
            return
        }
        presentSafariVC(with: url)
    }
}

extension UserInfoVC: PGFollowerItemInfoVCDelegate {
    
    func didTapGetFollower(for user: GithubUserDetail) {
        let destinationVC = UserOrganizationVC()
        destinationVC.url = user.organizationsUrl
        let navController = UINavigationController(rootViewController: destinationVC)
        present(navController, animated: true)
    }
}
