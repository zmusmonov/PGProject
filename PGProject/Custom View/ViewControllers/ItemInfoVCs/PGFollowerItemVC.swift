//
//  PGFollowerItemVC.swift
//  PGProject
//
//  Created by ZiyoMukhammad Usmonov on 22/11/22.
//

import Foundation

protocol PGFollowerItemInfoVCDelegate: AnyObject {
    func didTapGetFollower(for user: GithubUserDetail)
}

class PGFollowerItemVC: PGItemInfoVC {
    
    weak var delegate: PGFollowerItemInfoVCDelegate!

    init(user: GithubUserDetail, delegate: PGFollowerItemInfoVCDelegate) {
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
        itemInfoViewOne.set(itemInfoType: .followers, withCount: user.followers)
        itemInfoInfoTwo.set(itemInfoType: .following, withCount: user.following)
        actionButton.set(color: .systemGreen, title: "User organizations", systemImageName: "person.3")
    }
    
    override func actionButtonTapped() {
        delegate.didTapGetFollower(for: user)
    }
}
