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
            return R.image.bomb.name
        case .cake:
            return R.image.cake.name
        case .candyOne:
            return R.image.candy_one.name
        case .candyTwo:
            return R.image.candy_two.name
        case .candyTree:
            return R.image.candy_three.name
        case .chocolate:
            return R.image.chocolate.name
        case .cookie:
            return R.image.cookie.name
        case .donut:
            return R.image.donut.name
        case .marshmallow:
            return R.image.marshmallow.name
        case .сaterpillar:
            return R.image.сaterpillar.name
        case .chupachups:
            return R.image.chupachups.name
        }
    }
}

extension GameItems: Identifiable {
    
    var id: GameItems {
        return self
    }
}
