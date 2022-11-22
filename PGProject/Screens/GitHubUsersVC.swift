//
//  GitHubUsersVC.swift
//  PGProject
//
//  Created by ZiyoMukhammad Usmonov on 19/11/22.
//

import UIKit

class GitHubUsersVC: PGDataLoadingVC {
    
    enum Section {
        case main
    }
    var sinceId: Int!
    var githubUsers: [GitHubUser] = []
    var filteredGithubUsers: [GitHubUser] = []
    var page = 1
    var hasMoreUsers = true
    var isSearching = false
    var isLoadingMoreUsers = false

    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, GitHubUser>!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureSearchController()
        configureCollectionView()
        getGithubUsers(sinceId: sinceId, page: page)
        configureDataSource()
    }
    
    init(sinceId: Int) {
        super.init(nibName: nil, bundle: nil)
        self.sinceId = sinceId
        title = "Users since ID: \(sinceId)"
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func configureVC() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(GithubUserCell.self, forCellWithReuseIdentifier: GithubUserCell.reuseId)
    }

    func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search for a username"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }
    
    func getGithubUsers(sinceId: Int, page: Int) {
        showLoadingView()
        isLoadingMoreUsers = true
        
        let urlString = NetworkManager.shared.endPointForGithubUsers(for: sinceId)
        NetworkManager.shared.performApiCall(urlString: urlString, expextingReturnType: [GitHubUser].self) { [weak self] result in
            guard let self = self else { return }
            self.dismissLoadingView()
            
            switch result {
            case .success(let users):
                self.updateUI(with: users)
            case .failure(let error):
                self.presentPGAlertOnMainThread(title: "Bad stuff happened", message: error.rawValue, buttonTitle: "OK")
            }
        }
        self.isLoadingMoreUsers = false
    }
    
    func updateUI(with githubUsers: [GitHubUser]) {
        if githubUsers.count < 20 { self.hasMoreUsers = false }
        self.githubUsers.append(contentsOf: githubUsers)
        if self.githubUsers.isEmpty {
            let message = "Since this id there is no GitHub users. Please try with lower id number"
            DispatchQueue.main.async { self.showEmptyStateView(with: message, in: self.view) }
            return
        }
        self.updateData(on: self.githubUsers)
    }
    
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, GitHubUser>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, githubUser) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GithubUserCell.reuseId, for: indexPath) as! GithubUserCell
            cell.set(githubUser: githubUser)
            
            return cell
        })
    }
    
    func updateData(on githubUsers: [GitHubUser]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, GitHubUser>()
        snapshot.appendSections([.main])
        snapshot.appendItems(githubUsers)
        DispatchQueue.main.async { self.dataSource.apply(snapshot, animatingDifferences: true) }
    }
}


extension GitHubUsersVC: UICollectionViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentheight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentheight - height {
            guard hasMoreUsers, !isLoadingMoreUsers else { return }
            getGithubUsers(sinceId: (sinceId + page * 20), page: page)

            page += 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeArray = isSearching ? filteredGithubUsers : githubUsers
        let githubUser = activeArray[indexPath.row]
        
        let destinationVC = UserInfoVC()
        destinationVC.username = githubUser.login
        let navController = UINavigationController(rootViewController: destinationVC)
        present(navController, animated: true)
    }
}

extension GitHubUsersVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            isSearching = false
            filteredGithubUsers.removeAll()
            updateData(on: githubUsers)
            return
        }
        isSearching = true
        filteredGithubUsers = githubUsers.filter{ $0.login.lowercased().contains(filter.lowercased()) }
        updateData(on: filteredGithubUsers)
    }
}
