//
//  CocktailViewModelTests.swift
//  CocktailBook
//
//  Created by prema janoti on 24/03/25.
//

import XCTest
import Combine
@testable import CocktailBook

final class CocktailViewModelTests: XCTestCase {
    
    var viewModel: CocktailViewModel!
    var mockAPI: MockCocktailsAPI!
    var cancellables: Set<AnyCancellable> = []
    
    override func setUp() {
        super.setUp()
        mockAPI = MockCocktailsAPI()
        viewModel = CocktailViewModel(api: mockAPI)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // Test Initial State
    func testInitialState() {
        XCTAssertTrue(viewModel.cocktails.isEmpty, "Cocktails should be empty initially")
        XCTAssertEqual(viewModel.selectedFilter, .all, "Default filter should be All")
        XCTAssertTrue(viewModel.isLoading, "Loading state should be true initially")
    }
    
    func testFetchCocktails() {
        let expectation = XCTestExpectation(description: "Fetch cocktails from API")
        
        viewModel.$cocktails
            .dropFirst() // Ignore the initial empty state
            .sink { cocktails in
                XCTAssertEqual(cocktails.count, 3, "Mock API should return 3 cocktails")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        mockAPI.sendMockCocktails() // Simulate API response
        wait(for: [expectation], timeout: 3.0)
    }
  
    // Test Toggling Favorites
    func testToggleFavorite() {
       
        if let cocktail = viewModel.cocktails.first {
            
            XCTAssertFalse(cocktail.isFavorite, "Cocktail should not be favorite by default")
            
            // Toggle favorite
            viewModel.toggleFavorite(for: cocktail)
            XCTAssertTrue(viewModel.cocktails.first!.isFavorite, "Cocktail should now be marked as favorite")
            
            // Toggle again to remove favorite
            viewModel.toggleFavorite(for: cocktail)
            XCTAssertFalse(viewModel.cocktails.first!.isFavorite, "Cocktail should no longer be favorite")
        }
    }
}


class MockCocktailsAPI: CocktailsAPI {
    
    private let subject = PassthroughSubject<Data, CocktailsAPIError>()
    
    var cocktailsPublisher: AnyPublisher<Data, CocktailsAPIError> {
        return subject.eraseToAnyPublisher()
    }
    
    func fetchCocktails(_ handler: @escaping (Result<Data, CocktailsAPIError>) -> Void) {
        let mockData = generateMockCocktailData()
        handler(.success(mockData))
    }
    
    func sendMockCocktails() {
        let mockData = generateMockCocktailData()
        subject.send(mockData)
    }
    
    private func generateMockCocktailData() -> Data {
        let mockCocktails: [Cocktail] = [
            Cocktail(id: "1", name: "Mojito", type: "alcoholic", shortDescription: "Refreshing mint cocktail", longDescription: "A classic mint cocktail", preparationMinutes: 5, imageName: "mojito", ingredients: ["Mint", "Rum", "Sugar"]),
            Cocktail(id: "2", name: "Martini", type: "alcoholic", shortDescription: "Classic strong cocktail", longDescription: "An iconic gin-based cocktail", preparationMinutes: 3, imageName: "martini", ingredients: ["Gin", "Vermouth"]),
            Cocktail(id: "3", name: "Virgin Pina Colada", type: "non-alcoholic", shortDescription: "Tropical and creamy", longDescription: "A coconut and pineapple treat", preparationMinutes: 4, imageName: "pina_colada", ingredients: ["Coconut", "Pineapple"])
        ]
        
        let encoder = JSONEncoder()
        do {
            return try encoder.encode(mockCocktails)
        } catch {
            print("Failed to encode mock cocktails: \(error)")
            return Data()
        }
    }
}
