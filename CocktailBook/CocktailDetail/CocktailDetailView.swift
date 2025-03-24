//
//  CocktailDetailView.swift
//  CocktailBook
//
//  Created by prema janoti on 24/03/25.
//

import SwiftUI

@MainActor
struct CocktailDetailView: View {
    
    @StateObject var viewModel: CocktailViewModel
    var cocktail: Cocktail
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Image(cocktail.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: 250)
                    .clipped()
                
                Text(cocktail.name)
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 8)
                
                HStack {
                    Image(systemName: "clock")
                    Text("\(cocktail.preparationMinutes) min")
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 4)
                
                Text(cocktail.longDescription)
                
                Text("Ingredients")
                    .font(.headline)
                    .padding(.top)
                
                ForEach(cocktail.ingredients, id: \.self) { ingredient in
                    HStack {
                        Image(systemName: "chevron.right")
                        Text(ingredient)
                    }
                    .padding(.vertical, 2)
                }
                
                Spacer()
            } .padding()
        }
        .navigationTitle("Cocktail Details")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    viewModel.toggleFavorite(for: cocktail)
                }) {
                    Image(systemName: cocktail.isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(.purple)
                        .font(.largeTitle)
                }
            }
        }
    }
}
