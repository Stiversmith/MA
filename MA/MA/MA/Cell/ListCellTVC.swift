//
//  ListCellTVC.swift
//  MA
//
//  Created by Aliaksandr Yashchuk on 1/8/24.
//

import UIKit

class ListCellTVC: UITableViewCell {

    @IBOutlet weak var number: UILabel!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
