//
//  ZoneAnnotation.swift
//  SoCarApp
//
//  Created by WG Yang on 2022/06/06.
//

import Foundation
import MapKit

class ZoneAnnotation: MKPointAnnotation {
    
    private var _zone: Zone!
    var zone: Zone {
        get {
            return _zone
        }
        set(value) {
            _zone = value
            let zoneCoordi = CLLocationCoordinate2D(latitude: _zone.location.lat, longitude: _zone.location.lng)
            self.coordinate = zoneCoordi
            self.title = value.name
            self.subtitle = value.alias

        }
    }
    
    private override init() {
        super.init()
    }
    
    convenience init(zone: Zone) {
        self.init()
        self.zone = zone
    }

}
