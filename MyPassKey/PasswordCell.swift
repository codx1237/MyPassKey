//
//  PasswordCell.swift
//  MyPassKey
//
//  Created by Fırat Ören on 24.04.2024.
//

import UIKit

class PasswordCell: UITableViewCell {

    
    @IBOutlet weak var pLabel: UILabel!
    var pp: String?
    var tapped = false
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if let p = pp {
            pLabel.text = p
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
