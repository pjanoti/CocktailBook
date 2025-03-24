//
//  CocktailModel.swift
//  CocktailBook
//
//  Created by prema janoti on 24/03/25.
//

import Foundation

// Define filter options
enum FilterType: String, CaseIterable {
    case all = "All"
    case alcoholic = "Alcoholic"
    case nonAlcoholic = "Non-Alcoholic"
}

struct Cocktail: Identifiable, Codable {
    let id: String
    let name: String
    let type: String
    let shortDescription: String
    let longDescription: String
    let preparationMinutes: Int
    let imageName: String
    let ingredients: [String]
    var isFavorite: Bool {
        get {
            UserDefaults.standard.bool(forKey: "favorite_\(id)")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "favorite_\(id)")
        }
    }
    
    // Custom decoder to provide default value
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        type = try container.decode(String.self, forKey: .type)
        shortDescription = try container.decode(String.self, forKey: .shortDescription)
        longDescription = try container.decode(String.self, forKey: .longDescription)
        preparationMinutes = try container.decode(Int.self, forKey: .preparationMinutes)
        imageName = try container.decode(String.self, forKey: .imageName)
        ingredients = try container.decode([String].self, forKey: .ingredients)
    }
    
    init(id: String, name: String, type: String, shortDescription: String, longDescription: String, preparationMinutes: Int, imageName: String, ingredients: [String]) {
            self.id = id
            self.name = name
            self.type = type
            self.shortDescription = shortDescription
            self.longDescription = longDescription
            self.preparationMinutes = preparationMinutes
            self.imageName = imageName
            self.ingredients = ingredients
        }
}
