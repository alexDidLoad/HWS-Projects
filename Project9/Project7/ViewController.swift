//
//  ViewController.swift
//  Project7
//
//  Created by Alexander Ha on 9/27/20.
//

import UIKit

class ViewController: UITableViewController {
    
    
    var petitions = [Petition]()
    var filteredPetitions = [Petition]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let filterButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(filterPetitions))
        let aboutButton = UIBarButtonItem(title: "About", style: .plain, target: self, action: #selector(showCredits))
        let resetButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reset))
        navigationItem.rightBarButtonItems = [filterButton, resetButton]
        navigationItem.leftBarButtonItems = [aboutButton]
        
        performSelector(inBackground: #selector(fetchJSON), with: nil)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPetitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = filteredPetitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            //code below will reload UITableView on the main thread.
            tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        } else {
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        }
    }
    
    @objc func fetchJSON() {
        let urlString: String
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
        } else {
            urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=1000&limit=100"
        }
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                filteredPetitions = self.petitions
                return
            }
        }
        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
    }
    
    @objc func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again." , preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    @objc func reset() {
        filteredPetitions = petitions
        tableView.reloadData()
    }
    
    @objc func showCredits() {
        let ac = UIAlertController(title: "Info", message: "This data comes from the \n'We The People' \nAPI of the Whitehouse", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Okay", style: .default))
        present(ac, animated: true)
    }
    
    @objc func filterPetitions() {
        let ac = UIAlertController(title: "Find Petitions", message: nil, preferredStyle: .alert)
        let searchAction = UIAlertAction(title: "Search", style: .default) {
            [weak self, weak ac] action in
            guard let search = ac?.textFields?[0].text else { return }
            self?.searchPressed(search)
        }
        ac.addTextField()
        ac.addAction(searchAction)
        present(ac, animated: true)
    }
    
    func searchPressed(_ filterString: String) {
        filteredPetitions.removeAll(keepingCapacity: true)
        for petition in petitions {
            if petition.title.contains(filterString) {
                filteredPetitions.append(petition)
                tableView.reloadData()
            }
        }
    }
}

