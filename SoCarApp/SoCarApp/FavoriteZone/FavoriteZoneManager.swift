//
//  FavoriteZoneManager.swift
//  SoCarApp
//
//  Created by WG Yang on 2022/06/06.
//

import Foundation


class FavoriteZoneManager {
    
    let favoriteZonesKey = "favoriteZones"
    //즐겨찾기 목록
    lazy var favoriteZones: Set<String> = {
        if let zones = UserDefaults.standard.object(forKey: favoriteZonesKey) as? Set<String>
        {
            return zones
        } else {
            return Set<String>()
        }
      
    }()
    
    //즐겨찾기 추가
    func addFavorite(zoneID: String) {
        self.favoriteZones.insert(zoneID)
        UserDefaults.standard.set(self.favoriteZones, forKey: favoriteZonesKey)

    }
    //즐겨찾기 제거
    func removeFavorite(zoneID: String) {
        self.favoriteZones.remove(zoneID)
        UserDefaults.standard.set(self.favoriteZones, forKey: favoriteZonesKey)
    }
    
}
