//
//  Redirect.swift
//
//
//  Created by Yevhen Khyzhniak on 30.10.2023.
//

import Foundation

public enum AppError: Error, Codable {
    case emptyHttpResponse
    case emptyRedirectUrl
    case notConnectedToInternet
    case lostServerConnect
    case apiError(code: Int, message: String)
}

public protocol RedirectLogic {
    func getRedirectionUrl(_ request: URLRequest) async throws -> URL
}

public final class RedirectLogicImpl: RedirectLogic {
    
    public init() {
        
    }
    
    public func getRedirectionUrl(_ request: URLRequest) async throws -> URL {
        let (_, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else { throw AppError.emptyHttpResponse }
        guard let redirectURL = httpResponse.url else { throw AppError.emptyRedirectUrl }
        return redirectURL
    }
    
}
