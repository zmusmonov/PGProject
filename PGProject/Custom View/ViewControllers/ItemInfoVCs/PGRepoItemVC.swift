//
//  PGRepoItemVC.swift
//  PGProject
//
//  Created by ZiyoMukhammad Usmonov on 22/11/22.
//

import Foundation

protocol PGRepoItemInfoVCDelegate: AnyObject {
    func didTapGitHubProfile(for user: GithubUserDetail)
}

class PGRepoItemVC: PGItemInfoVC {
    
    weak var delegate: PGRepoItemInfoVCDelegate!
    
    init(user: GithubUserDetail, delegate: PGRepoItemInfoVCDelegate) {
        super.init(user: user)
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureItems()
    }
    
    private func configureItems() {
        itemInfoViewOne.set(itemInfoType: .repos, withCount: user.publicRepos)
        itemInfoInfoTwo.set(itemInfoType: .gists, withCount: user.publicGists)
        actionButton.set(color: .systemPurple, title: "GitHub Profile", systemImageName: "person")
    }
    
    override func actionButtonTapped() {
        delegate.didTapGitHubProfile(for: user)
    }
}
