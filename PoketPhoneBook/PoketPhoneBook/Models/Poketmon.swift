//
//  Poket.swift
//  PoketPhoneBook
//
//  Created by Watson22_YJ on 12/9/24.
//

import Foundation

// MARK: - 포켓몬 데이터 모델

struct Poketmon: Codable {
    let id: Int?
    let name: String?
    let height, weight: Int?
    let sprites: Sprites?
}
// MARK: - Sprites
struct Sprites: Codable {
    let other: Other?
}
// MARK: - Other
struct Other: Codable {
    let home: Home?
}
// MARK: - Home
struct Home: Codable {
    let imageUrl: String?

    enum CodingKeys: String, CodingKey {
        case imageUrl = "front_shiny"
    }
}
