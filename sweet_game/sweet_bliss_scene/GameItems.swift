//
//  GameItems.swift
//  sweet_game
//
//  Created by Yevhen Khyzhniak on 29.02.2024.
//

import Foundation

enum GameItems: String, CaseIterable, Hashable {
    case bomb
    case cake
    case candyOne
    case candyTwo
    case candyTree
    case chocolate
    case cookie
    case donut
    case marshmallow
    case сaterpillar
    case chupachups
    
    var image: String {
        switch self {
        case .bomb:
            return "bomb"
        case .cake:
            return "cake"
        case .candyOne:
            return "candy_one"
        case .candyTwo:
            return "candy_two"
        case .candyTree:
            return "candy_three"
        case .chocolate:
            return "chocolate"
        case .cookie:
            return "cookie"
        case .donut:
            return "donut"
        case .marshmallow:
            return "marshmallow"
        case .сaterpillar:
            return "сaterpillar"
        case .chupachups:
            return "chupachups"
        }
    }
}

extension GameItems: Identifiable {
    
    var id: GameItems {
        return self
    }
}
