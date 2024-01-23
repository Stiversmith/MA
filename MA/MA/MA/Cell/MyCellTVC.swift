
import RealmSwift
import UIKit

class MyCellTVC: UITableViewCell {
    
    var translateCompletion: ((String) -> Void)?
    var previousTitle: String?

    
    @IBOutlet weak var numberLbl: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var actIndic: UIActivityIndicatorView!
    @IBOutlet weak var translateBtn: UIButton!
    
    override func awakeFromNib() {
            super.awakeFromNib()
            translateBtn.addTarget(self, action: #selector(translateButtonTapped), for: .touchUpInside)
        }

        @objc func translateButtonTapped() {
            guard let word = titleLabel.text else { return }
            translateCompletion?(word)
        }

        func showActivityIndicator() {
            actIndic.startAnimating()
        }
        
        func hideActivityIndicator() {
            actIndic.stopAnimating()
        }
    }
