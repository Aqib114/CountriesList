import UIKit

class CustomTableViewCell: UITableViewCell {

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
        print("Updating checkbox image. Is selected: \(checkBoxButton.isSelected)")
        let imageName = checkBoxButton.isSelected ? "checkmark.square.fill" : "square"
        let image = UIImage(systemName: imageName)
        
        // Set the image and the color
        checkBoxButton.setImage(image?.withRenderingMode(.alwaysTemplate), for: .normal)
        checkBoxButton.tintColor = checkBoxButton.isSelected ? .systemBlue : .systemGray
    }

    
}
