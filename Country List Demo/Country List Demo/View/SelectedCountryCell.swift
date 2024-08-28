import UIKit

class SelectedCountryCell: UITableViewCell {

    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var countryNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateCheckBoxImage()
    }

    func configure(with country: Country) {
        countryNameLabel.text = country.name
        checkBoxButton.isSelected = country.isSelected
        updateCheckBoxImage()
    }

    func updateCheckBoxImage() {
        let imageName = checkBoxButton.isSelected ? "checkmark.square.fill" : "square"
        checkBoxButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
}
