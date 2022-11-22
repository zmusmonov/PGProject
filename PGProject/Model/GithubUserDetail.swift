//
//  GithubUserDetail.swift
//  PGProject
//
//  Created by ZiyoMukhammad Usmonov on 21/11/22.
//

import Foundation

struct GithubUserDetail: Codable {
    let login: String
    let id: Int
    let avatarUrl: String
    var name: String?
    var location: String?
    var bio: String?
    let publicRepos: Int
    let publicGists: Int
    let htmlUrl: String
    let following: Int
    let followers: Int
    let createdAt: Date
    let organizationsUrl: String
}
