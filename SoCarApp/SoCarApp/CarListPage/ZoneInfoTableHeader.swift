//
//  ZoneInfoTableHeader.swift
//  SoCarApp
//
//  Created by WG Yang on 2022/06/06.
//

import UIKit

class ZoneInfoTableHeader: UIView {
    @IBOutlet var zoneNameLabel: UILabel!
    @IBOutlet var zoneAliasLabel: UILabel!
    @IBOutlet var favoriteButton: UIButton!
    
    override init(frame: CGRect) {
           super.init(frame: frame)
           loadView()
   }
   
   required init?(coder: NSCoder) {
       super.init(coder: coder)
       loadView()
   }
   
   private func loadView() {
       let view = Bundle.main.loadNibNamed("ZoneInfoTableHeader",
                                      owner: self,
                                      options: nil)?.first as! UIView
       view.frame = bounds
       self.addSubview(view)
   }

  
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
