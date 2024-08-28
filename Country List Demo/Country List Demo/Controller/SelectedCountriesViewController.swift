import UIKit

class SelectedCountriesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var selectedCountries: [Country] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CustomTableViewCell")
        tableView.reloadData()
    }
}

extension SelectedCountriesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedCountries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath)
        cell.textLabel?.text = selectedCountries[indexPath.row].name
        return cell
    }
}
