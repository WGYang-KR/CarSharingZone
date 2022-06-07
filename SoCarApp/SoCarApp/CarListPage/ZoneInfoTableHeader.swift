//
//  ZoneInfoTableHeader.swift
//  SoCarApp
//
//  Created by WG Yang on 2022/06/06.
//

import UIKit
import RxSwift
import RxCocoa

class ZoneInfoTableHeader: UIView {
    @IBOutlet var zoneNameLabel: UILabel!
    @IBOutlet var zoneAliasLabel: UILabel!
    @IBOutlet var favoriteButton: UIButton!
    
    var currentZone: Zone!
    var isFavorite: BehaviorSubject<Bool>!
    let favoriteZoneManager = FavoriteZoneManager()
    var disposeBag = DisposeBag()
    
    
    
  override init(frame: CGRect) {
        super.init(frame: frame)
        
   }
   
  required init?(coder: NSCoder) {
       super.init(coder: coder)
   }
    
    convenience init(frame: CGRect, zone: Zone) {
        self.init(frame: frame)
        self.currentZone = zone
        loadView()
        bindUI()
    }
   
   private func loadView() {
       let view = Bundle.main.loadNibNamed("ZoneInfoTableHeader",
                                      owner: self,
                                      options: nil)?.first as! UIView
       view.frame = bounds
       self.addSubview(view)
   }

    private func bindUI() {
       
        let zoneID = currentZone.id
        let initialStatus = favoriteZoneManager.isFavoriteZone(zoneID: zoneID)
        isFavorite = BehaviorSubject(value: initialStatus)
        
        //버튼 탭시 true false 토글 . isFavorite 변수와 바인딩
        self.favoriteButton.rx.tap
            .scan(initialStatus){lastState, newState in !lastState}
            .bind(to: self.isFavorite )
            .disposed(by: disposeBag)
        
        //isFavorite 변수 상태에 따라 버튼아이콘/목록에서 제거,추가 바인딩
        self.isFavorite.subscribe(
            onNext:{
                b in
                print("isFavorite Changed: \(b)")
                if b {
                    if let favorite_blue = UIImage(named: "_ic24_favorite_blue") {
                        self.favoriteButton.setImage(favorite_blue, for: .normal)
                    }
                    self.favoriteZoneManager.addFavorite(zoneID: zoneID)
                } else {
                    if let favorite_gray = UIImage(named: "_ic24_favorite_gray") {
                        self.favoriteButton.setImage(favorite_gray, for: .normal)
                    }
                    self.favoriteZoneManager.removeFavorite(zoneID: zoneID)
                }
            }).disposed(by: disposeBag)
        
   
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
