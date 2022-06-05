//
//  Car.swift
//  SoCarApp
//
//  Created by WG Yang on 2022/06/04.
//

import Foundation

struct Car: Codable {
    let id: String
    let name: String
    let description: String
    let category: String
    let zones: [String]
}
/*
 - EV: 전기
 - COMPACT: 소형
 - COMPACT_SUV: 소형 SUV
 - SEMI_MID_SUV: 준중형 SUV
 - SEMI_MID_SEDAN: 준중형 세단
 - MID_SUV: 중형 SUV
 - MID_SEDAN: 중형 세단
 */
/* "cars": [
    {
        "id": "1",
        "name": "볼트EV",
        "description": "SMART CROSSOVER BOLT EV",
        "imageUrl": "https://image.socar.kr/car_image/car074.png",
        "category": "EV",
        "zones": [
            "13",
            "16",
            "21",
            "26"
        ]
    },
*/
