//
//  File.swift
//  
//
//  Created by Yevhen Khyzhniak on 30.10.2023.
//

import Foundation

extension URL {
  func addEndpoint(endpoint: String) -> URL {
    return URL(string: endpoint, relativeTo: self)!
  }

  func addParams(params: [String: String?]?) -> URL {
    guard let params = params else {
      return self
    }
    var urlComp = URLComponents(url: self, resolvingAgainstBaseURL: true)!
    var queryItems = [URLQueryItem]()
    for (key, value) in params {
        if let value {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
    }
    urlComp.queryItems = queryItems
    return urlComp.url!
  }
}
