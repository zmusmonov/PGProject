//
//  NetworkManager.swift
//  PGProject
//
//  Created by ZiyoMukhammad Usmonov on 21/11/22.
//

import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    private let basecUrl = "https://api.github.com/users"
    
    let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func performApiCall<T: Codable>(urlString: String, expextingReturnType: T.Type, completed: @escaping((Result<T, PGError>) -> Void)) {
        guard let url = URL(string: urlString) else {
            completed(.failure(.invalidId))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _  = error {
                completed(.failure(.unableToComplete))
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy    = .iso8601
                let objc = try decoder.decode(T.self, from: data)
                completed(.success(objc))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        task.resume()
    }
    
    func endPointForGithubUsers(for sinceId: Int) -> String {
        return basecUrl + "?since=\(sinceId)&per_page=20)"
    }
    
    func endPointForUserInfo(for username: String) -> String {
        return basecUrl + "/\(username)"
    }

    func downloadImage(from urlString: String, completed: @escaping (UIImage?) -> Void) {
        let cacheKey = NSString(string: urlString)
        
        if let image = cache.object(forKey: cacheKey) {
            completed(image)
            return
        }
        
        guard let url = URL(string: urlString) else {
            completed(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            
            guard let self = self,
                  error == nil,
                  let response = response as? HTTPURLResponse, response.statusCode == 200,
                  let data = data,
                  let image = UIImage(data: data) else {
                completed(nil)
                return
            }
            
            self.cache.setObject(image, forKey: cacheKey)
            completed(image)
        }
        
        task.resume()
    }
    
}
