//
//  CocktailViewModel.swift
//  CocktailBook
//
//  Created by prema janoti on 24/03/25.
//

import SwiftUI
import Combine

class CocktailViewModel: ObservableObject {
    
    @Published var cocktails: [Cocktail] = []
    @Published var filteredCocktails: [Cocktail] = []
    @Published var selectedFilter: FilterType = .all
    @Published var isLoading: Bool = true
    
    private var cancellables = Set<AnyCancellable>()
    private let api: CocktailsAPI
    
    init(api: CocktailsAPI) {
        self.api = api
        fetchCocktails()
    }
    
    func fetchCocktails() {
        api.cocktailsPublisher
            .decode(type: [Cocktail].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    print("Failed to fetch cocktails")
                }
            }, receiveValue: { [weak self] cocktails in
                self?.isLoading = false
                self?.cocktails = cocktails
                self?.applyFilter()
            })
            .store(in: &cancellables)
    }
    
    func applyFilter() {
        switch selectedFilter {
        case .alcoholic:
            filteredCocktails = cocktails.filter { $0.type == "alcoholic" }
        case .nonAlcoholic:
            filteredCocktails = cocktails.filter { $0.type == "non-alcoholic" }
        default:
            filteredCocktails = cocktails
        }
    }
    
    func toggleFavorite(for cocktail: Cocktail) {
        if let index = cocktails.firstIndex(where: { $0.id == cocktail.id }) {
            cocktails[index].isFavorite.toggle()
            objectWillChange.send()
        }
    }
}
