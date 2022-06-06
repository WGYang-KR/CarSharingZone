//
//  MainViewController.swift
//  SoCarApp
//
//  Created by WG Yang on 2022/06/04.
//

import UIKit
import MapKit

class MainViewController: UIViewController {

    @IBOutlet var mapView: MKMapView!
    
    var zones: [Zone]!
    
    let mkSpanSetting =  MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01) //초기 축적도
    let mkInitialCoordinate = CLLocationCoordinate2D(latitude: 37.54330366639085, longitude: 127.04455548501139) //서울숲

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
    
        mapView.setRegion(MKCoordinateRegion(center: mkInitialCoordinate, span: mkSpanSetting), animated: true )
        
        APIService.requestZones{
            zones in
            self.zones = zones
            print(self.zones)
        }
        
        //핀 만들기
        

    }
    
    @IBAction func touchUpInsideFavoriteZoneButton(_ sender: UIButton) {
        
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MainViewController: MKMapViewDelegate {
    
}
