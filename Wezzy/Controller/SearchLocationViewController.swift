//
//  SearchLocationViewController.swift
//  Wezzy
//
//  Created by admin on 26.08.2021.
//

import UIKit
import MapKit

class SearchLocationViewController: UIViewController {

    //MARK: - public properties
    
    weak var delegate: ManageLocationDelegate?
    
    //MARK: - private properties
    private let mainColor = UIColor.systemGray5
    private var completions = [MKLocalSearchCompletion]()
    private let completer = MKLocalSearchCompleter()
    
    private let searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.searchBarStyle = .minimal
        return bar
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = mainColor
        completer.delegate = self
        configureSearchBar()
        configureTableView()
        configureKeyboardAdjustment()
    }
    
    //MARK: - layout configuration
    private func configureSearchBar() {
        searchBar.backgroundColor = mainColor
        
        view.addSubview(searchBar)
        searchBar.delegate = self
        searchBar.becomeFirstResponder()
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            searchBar.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            searchBar.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10)
        ])
    }
    
    private func configureTableView() {
        tableView.backgroundColor = mainColor
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    //MARK: - keyboard adjustment
    private func configureKeyboardAdjustment() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc private func adjustForKeyboard(notification: Notification) {
        let userInfo = notification.userInfo!

        let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            tableView.contentInset = UIEdgeInsets.zero
        } else {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        tableView.scrollIndicatorInsets = tableView.contentInset
    }
    
}

//MARK: - UISearchBarDelegate
extension SearchLocationViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        completer.queryFragment = searchText
    }
}

//MARK: - UITableViewDelegate & DataSource
extension SearchLocationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        completions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResult = completions[indexPath.row]
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.backgroundColor = mainColor
        cell.textLabel?.text = searchResult.title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let completion = completions[indexPath.row]
        let searchRequest = MKLocalSearch.Request(completion: completion)
        
        let search = MKLocalSearch(request: searchRequest)
        DispatchQueue.global().async { [weak self] in
            search.start { (response, error) in
                
                DispatchQueue.main.async {
                    self?.dismiss(animated: true)
                }
                
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    guard let response = response else { return }
                    let mapItem = response.mapItems[0]
                    mapItem.name = completion.title
                    self?.delegate?.addLocation(mapItem: mapItem)
                }
            }
        }
    }
}

//MARK: - MKLocalSearchCompleterDelegate
extension SearchLocationViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            //City names typically contain at least one comma
            self?.completions = completer.results.filter { $0.title.contains(",") }
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
}
