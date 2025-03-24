import UIKit

class MainScreenViewController: UIViewController {
    
    private let cocktailsAPI: CocktailsAPI = FakeCocktailsAPI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let scrollView = UIScrollView()
        view.addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        let label = UILabel()
        label.numberOfLines = 0
        scrollView.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        label.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true

        cocktailsAPI.fetchCocktails { result in
            if case let .success(data) = result {
                if let jsonString = String(data: data, encoding: .utf8) {
                    DispatchQueue.main.async {
                        label.text = jsonString
                    }
                }
            }
        }
    }
}
