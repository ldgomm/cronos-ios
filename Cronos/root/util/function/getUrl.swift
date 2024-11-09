//
//  getUrl.swift
//  Sales
//
//  Created by José Ruiz on 24/7/24.
//

import Foundation

func getUrl(endpoint: String, id: String? = nil, keywords: String? = nil) -> URL {
    var components = URLComponents(string: "https://www.sales.premierdarkcoffee.com/\(endpoint)")!
    if let id {
        components.queryItems = [URLQueryItem(name: "id", value: id)]
    }
    if let keywords {
        components.queryItems = [URLQueryItem(name: "keywords", value: keywords)]
    }
    print("URL: \(String(describing: components.url!))")
    return components.url!
}
