
import UIKit
import MapKit

final class SearchCitiesViewController: UIViewController {
    
    var presenter: SearchCitiesPresenterProtocol?
    private let searchBar: UISearchBar = {
        
        let searchBar = UISearchBar()
        
        searchBar.showsCancelButton = true
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Search"
        searchBar.prompt = "Add City"
        searchBar.backgroundColor = .white
        
        if let btnCancel = searchBar.value(forKey: "cancelButton") as? UIButton {
            btnCancel.setTitle("Cancel", for: .normal)
            btnCancel.isEnabled = true
        }
        
        return searchBar
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var searchCompleter: MKLocalSearchCompleter = MKLocalSearchCompleter()
    private var searchResults: [MKLocalSearchCompletion] = [MKLocalSearchCompletion]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "Cell")
        
        searchBar.delegate = self
        searchCompleter.delegate = self
        
        view.addSubview(searchBar)
        view.addSubview(tableView)
        
        setupConstraints ()
    }
    
    func setupConstraints () {
        searchBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        searchBar.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        searchBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
}


extension SearchCitiesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = searchResults[indexPath.row].title
        cell.detailTextLabel?.text = searchResults[indexPath.row].subtitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.global().async { [unowned self] in
            presenter?.updateSearchResults(with: self.searchResults[indexPath.row] )

        }
        
    }
}

extension SearchCitiesViewController:  UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchText = searchBar.text, searchText != "" else {
            searchResults.removeAll()
            return
        }
        
        searchCompleter.queryFragment = searchText
        searchCompleter.pointOfInterestFilter = .excludingAll
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
    }
}


extension SearchCitiesViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}


class CustomTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
