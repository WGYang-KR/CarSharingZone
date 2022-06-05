//
//  Zone.swift
//  SoCarApp
//
//  Created by WG Yang on 2022/06/04.
//

import Foundation

struct Zone: Codable {
    struct Location: Codable {
        let lat: Double
        let lng: Double
    }
    
    let id: String
    let name: String
    let alias: String
    let location: Location
}


/*
"zones": [
    {
        "id": "11",
        "name": "서울숲역 1번출구",
        "alias": "COW&6DOG 앞 주차장",
        "location": {
            "lat": 37.543095,
            "lng": 127.046822
        }
    },
 */

