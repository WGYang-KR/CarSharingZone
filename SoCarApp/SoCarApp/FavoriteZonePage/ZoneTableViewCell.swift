//
//  ZoneTableViewCell.swift
//  SoCarApp
//
//  Created by WG Yang on 2022/06/07.
//

import UIKit

class ZoneTableViewCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var aliasLabel: UILabel!
    var zoneID: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
