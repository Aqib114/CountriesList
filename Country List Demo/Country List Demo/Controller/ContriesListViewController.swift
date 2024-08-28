import UIKit

class ContriesListViewController: UIViewController {
    
    @IBOutlet weak var clearAllButton: UIButton!
    @IBOutlet weak var selectAllButton: UIButton!
    @IBOutlet weak var countrySearchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var showSelectedButton: UIButton!
    var filteredCountries: [Country] = []
    var countryData = CountryData()
    var refreshControl = UIRefreshControl()
    var searchText = ""
    
    
    @IBAction func selectAllButtonPressed(_ sender: Any) {
        for (key, var countries) in countryData.countriesByLetter {
            for i in 0..<countries.count {
                countries[i].isSelected = true
            }
            countryData.countriesByLetter[key] = countries
        }
        updateShowSelectedButton()
        tableView.reloadData()
    }

    @IBAction func clearAllButonPressed(_ sender: Any) {
        for (key, var countries) in countryData.countriesByLetter {
            for i in 0..<countries.count {
                countries[i].isSelected = false
            }
            countryData.countriesByLetter[key] = countries
        }
        updateShowSelectedButton()
        tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomTableViewCell")
        countryData.loadCountries()
        showSelectedButton.isHidden = true
        refreshControl.attributedTitle = NSAttributedString(string : "Loading...")
        refreshControl.addTarget(self, action: #selector(pullToRefresh(sender: )), for: .valueChanged)
        tableView.refreshControl = refreshControl
        countrySearchBar.delegate = self
        countrySearchBar.returnKeyType = UIReturnKeyType.done

        tableView.reloadData()
    }
    
    @objc func pullToRefresh(sender : UIRefreshControl){
        sender.endRefreshing()
        tableView.reloadData()
    }
    
    public func updateShowSelectedButton() {
        let hasSelected = countryData.countriesByLetter.flatMap { $0.value }.contains { $0.isSelected }
        showSelectedButton.isHidden = !hasSelected
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSelectedCountriesSegue" {
            let destinationVC = segue.destination as! SelectedCountriesViewController
            destinationVC.selectedCountries = countryData.countriesByLetter.flatMap { $0.value }.filter { $0.isSelected }
        }
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        countrySearchBar.endEditing(true)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.endEditing(true)
    }
}

extension ContriesListViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return countryData.sectionTitles.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionKey = countryData.sectionTitles[section]
        return countryData.countriesByLetter[sectionKey]?.filter {
            self.searchText.isEmpty || $0.name.lowercased().hasPrefix(self.searchText.lowercased())
        }.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
        let sectionKey = countryData.sectionTitles[indexPath.section]
        if let filteredCountries = countryData.countriesByLetter[sectionKey]?.filter({
            self.searchText.isEmpty || $0.name.lowercased().hasPrefix(self.searchText.lowercased())
        }) {
            let country = filteredCountries[indexPath.row]
            cell.configure(with: country)
            
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionKey = countryData.sectionTitles[indexPath.section]
        if var countries = countryData.countriesByLetter[sectionKey] {
            let filteredCountries = countries.filter {
                self.searchText.isEmpty || $0.name.lowercased().hasPrefix(self.searchText.lowercased())
            }
            var country = filteredCountries[indexPath.row]
            country.isSelected.toggle()
            if let index = countries.firstIndex(where: { $0.name == country.name }) {
                countries[index] = country
            }
            countryData.countriesByLetter[sectionKey] = countries
            tableView.reloadRows(at: [indexPath], with: .automatic)
            updateShowSelectedButton()
        }
    }
}

extension ContriesListViewController: UISearchBarDelegate {
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        tableView.reloadData()
    }
}


