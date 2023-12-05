//
//  WordCellTVC.swift
//  MA
//
//  Created by Aliaksandr Yashchuk on 11/16/23.
//

import UIKit

class WordCellTVC: UITableViewCell {
    
    @IBOutlet weak var arrowImage: UIImageView!
    
    private let checkBoxImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "empty_checkbox"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var isFilled: Bool = false {
        didSet {
            checkBoxImageView.image = isFilled ? UIImage(named: "filled_checkbox") : UIImage(named: "empty_checkbox")
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Добавьте создание и настройку вашего wordLabel
        let wordLabel = UILabel()
        wordLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(wordLabel)
        
        // ... настройте constraints для wordLabel
        
        // Добавьте позиционирование checkBoxImageView и wordLabel на ячейке
        // Например:
        contentView.addSubview(checkBoxImageView)
        NSLayoutConstraint.activate([
            checkBoxImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            checkBoxImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkBoxImageView.widthAnchor.constraint(equalToConstant: 20),
            checkBoxImageView.heightAnchor.constraint(equalToConstant: 20),
            
            wordLabel.leadingAnchor.constraint(equalTo: checkBoxImageView.trailingAnchor, constant: 16),
            wordLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            wordLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
