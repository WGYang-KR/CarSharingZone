//
//  FavoriteZoneManager.swift
//  SoCarApp
//
//  Created by WG Yang on 2022/06/06.
//

import Foundation


class FavoriteZoneManager {
    
    let userDefaultKey = "favoriteZoneList"
    
    
    //즐겨찾는 존 번호 목록
    lazy var favoriteZones: Set<String> = {
        if let zones = UserDefaults.standard.object(forKey: userDefaultKey) as? Set<String>
        {
            print("기존 zoneList")
            return zones
        } else {
            print("새로운 zoneList")
            return Set<String>()
        }
      
    }()
    
    func isFavoriteZone(zoneID: String) -> Bool {
        
        return favoriteZones.contains(zoneID)
    }

    
    //즐겨찾는 존 번호 추가
    func addFavorite(zoneID: String) {
        self.favoriteZones.insert(zoneID)
        print("존 번호 추가")
        UserDefaults.standard.set(self.favoriteZones, forKey: userDefaultKey)

        print("\(#function): list = \(self.favoriteZones)")
    }
    //즐겨찾는 존 번호 제거
    func removeFavorite(zoneID: String) {
        if isFavoriteZone(zoneID: zoneID) {
            self.favoriteZones.remove(zoneID)
        }
        UserDefaults.standard.set(self.favoriteZones, forKey: userDefaultKey)
        print("\(#function): list = \(self.favoriteZones)")
    }
    
}
