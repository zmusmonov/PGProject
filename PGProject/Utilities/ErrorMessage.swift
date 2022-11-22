//
//  ErrorMessage.swift
//  PGProject
//
//  Created by ZiyoMukhammad Usmonov on 21/11/22.
//

import Foundation

enum PGError: String, Error {
    case invalidId = "This id is invalid"
    case unableToComplete = "unable to complete your request. please check your internet connection"
    case invalidResponse = "invalid response from server"
    case invalidData = "The data received from server is invalid. Please, try again"
}
