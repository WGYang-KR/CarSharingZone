//
//  ZoneInfoTableViewCell.swift
//  SoCarApp
//
//  Created by WG Yang on 2022/06/06.
//

import UIKit

class ZoneInfoTableViewCell: UITableViewCell {

    @IBOutlet var zoneNameLabel: UILabel!
    @IBOutlet var zoneAliasLabel: UILabel!
    @IBOutlet var favoriteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
