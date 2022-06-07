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
    lazy var favoriteZones: [String] = {
        if let zones = UserDefaults.standard.array(forKey: userDefaultKey) as? [String]
        {
            print("기존 zoneList")
            return zones
        } else {
            print("새로운 zoneList")
            return [String]()
        }
      
    }()
    
    func isFavoriteZone(zoneID: String) -> Bool {
        
        return favoriteZones.contains(zoneID)
    }

    
    //즐겨찾는 존 번호 추가
    func addFavorite(zoneID: String) {
        if !favoriteZones.contains(zoneID) {
            print("존 번호 추가")
            self.favoriteZones.append(zoneID)
            UserDefaults.standard.set(self.favoriteZones, forKey: userDefaultKey)
            print("\(#function): list = \(self.favoriteZones)")
        }
    }
    //즐겨찾는 존 번호 제거
    func removeFavorite(zoneID: String) {
        if let index = self.favoriteZones.firstIndex(of: zoneID) {
            self.favoriteZones.remove(at: index)
            UserDefaults.standard.set(self.favoriteZones, forKey: userDefaultKey)
            print("\(#function): list = \(self.favoriteZones)")
        }
    }
    
}
