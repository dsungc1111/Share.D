//
//  ProductModel.swift
//  Agewise
//
//  Created by 최대성 on 8/15/24.
//

import Foundation


enum NetworkError: Error {
    case invalidURL
    case unknownResponse
    case statusError
    case expierdRefreshToken
}

struct Product: Decodable, Hashable {
    let total: Int
    let start: Int
    let display: Int
    var items: [ProductDetail]
}

struct ProductDetail: Decodable, Hashable {
    var title: String
    let link: String
    let mallName: String
    let image: String
    let lprice: String
    let productId: String
}
