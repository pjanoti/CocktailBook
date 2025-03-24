//
//  Untitled.swift
//  CocktailBook
//
//  Created by prema janoti on 24/03/25.
//

import SwiftUI

struct CocktailListView: View {
    
    @StateObject private var viewModel = CocktailViewModel(api: FakeCocktailsAPI())
    
    var body: some View {
        NavigationView {
            if viewModel.isLoading {
                ProgressView("Loading Cocktails...")
                    .padding()
            } else if filteredCocktails.isEmpty {
                Text("No cocktails available")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                VStack {
                    Picker("Filter", selection: $viewModel.selectedFilter) {
                        Text("All").tag(FilterType.all)
                        Text("Alcoholic").tag(FilterType.alcoholic)
                        Text("Non-Alcoholic").tag(FilterType.nonAlcoholic)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    
                    List(filteredCocktails, id: \.id) { cocktail in
                        NavigationLink(destination: CocktailDetailView(viewModel: viewModel, cocktail: cocktail)) {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(cocktail.name)
                                        .font(.headline)
                                        .foregroundColor(cocktail.isFavorite ? .purple : .primary) // Highlight favorite
                                    
                                    Spacer()
                                    
                                    if cocktail.isFavorite {
                                        Image(systemName: "heart.fill")
                                            .foregroundColor(.purple)
                                    }
                                }
                                HStack {
                                    Image(systemName: "clock")
                                    Text(String("\(cocktail.preparationMinutes) min"))
                                        .foregroundColor(.gray)
                                }
                                .foregroundColor(.gray)
                                Text(cocktail.shortDescription)
                                    .font(.body)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .listStyle(.plain)
                }
                .navigationTitle("All Cocktails")
                .onChange(of: viewModel.selectedFilter) { _ in
                    viewModel.applyFilter()
                }
            }
        }
        .navigationViewStyle(.stack)
    }
    
    // Filtered cocktails based on selection
    private var filteredCocktails: [Cocktail] {
        let sortedCocktails = viewModel.cocktails.sorted { (c1, c2) in
            if c1.isFavorite == c2.isFavorite {
                return c1.name.localizedCompare(c2.name) == .orderedAscending // Sort alphabetically
            }
            return c1.isFavorite && !c2.isFavorite // Favorites first
        }
        
        switch viewModel.selectedFilter {
        case .all:
            return sortedCocktails
        case .alcoholic:
            return sortedCocktails.filter { $0.type == "alcoholic" }
        case .nonAlcoholic:
            return sortedCocktails.filter { $0.type == "non-alcoholic" }
        }
    }
    
}

#Preview {
    CocktailListView()
}

