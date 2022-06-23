//
//  CarListTableViewCell.swift
//  SoCarApp
//
//  Created by WG Yang on 2022/06/06.
//

import UIKit

class CarListTableViewCell: UITableViewCell {

    @IBOutlet var carImageView: UIImageView!
    @IBOutlet var carNameLabel: UILabel!
    @IBOutlet var carDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
