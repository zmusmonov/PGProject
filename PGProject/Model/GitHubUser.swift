//
//  GitHubUser.swift
//  PGProject
//
//  Created by ZiyoMukhammad Usmonov on 21/11/22.
//

import Foundation

struct GitHubUser: Codable {
    let uuid = UUID()

    private enum CodingKeys : String, CodingKey { case login, id, avatarUrl }

    var login: String
    var id: Int
    var avatarUrl: String
}

extension GitHubUser: Hashable {
    static func ==(lhs: GitHubUser, rhs: GitHubUser) -> Bool {
        return lhs.uuid == rhs.uuid
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
