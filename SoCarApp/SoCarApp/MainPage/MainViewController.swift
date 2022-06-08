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
    lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        // desiredAccuracy는 위치의 정확도를 설정함.
        // 높으면 배터리 많이 닳음.
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        return manager
     }()
    
    var zones = [Zone]()
    
    let defaultSpan = 0.01 //기본 축적도
    let defaultMKCoSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    let mkInitialCoordinate = CLLocationCoordinate2D(latitude: 37.54330366639085, longitude: 127.04455548501139) //서울숲

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        locationManager.delegate = self
        
        //MARK: 위치권한 확인 및 초기 위치 설정
        getLocationUsagePermission()
        let locationAuthorization = CLLocationManager.authorizationStatus()
        if locationAuthorization == .authorizedWhenInUse || locationAuthorization == .authorizedAlways {
            findMyLocation()
        } else {
            mapView.setRegion(MKCoordinateRegion(center: mkInitialCoordinate, span: defaultMKCoSpan), animated: true )
        }
        
        //MARK: 쏘카존 핀 추가
        self.installPin()
        
        //MARK: 뒤로가기 버튼 설정
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "ic24_back")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "ic24_back")
        
    }
    
    
    func installPin() {
        self.mapView.removeAnnotations(self.mapView.annotations)
        
        if self.zones.isEmpty {
            let APIServiceIns = APIService()
            APIServiceIns.requestZones{
                zones in
                self.zones = zones
                //핀 만들기
                DispatchQueue.main.async {
                    self.addPin()
                }
             
            }
        } else {
            self.addPin()
        }
    }
    
    private func addPin() {
        for zone in self.zones {
            
            let pin = ZoneAnnotation(zone: zone)
            mapView.addAnnotation(pin)
        }
    }

    
    //MARK: - '즐겨찾기 존' 버튼 클릭
    @IBAction func touchUpInsideFavoriteZoneButton(_ sender: UIButton) {
        let favoriteZoneVC = FavoriteZoneViewController()
        favoriteZoneVC.mainPageViewController = self
        favoriteZoneVC .modalPresentationStyle = .overFullScreen
        favoriteZoneVC .modalTransitionStyle = .crossDissolve
        self.present(favoriteZoneVC, animated: true)
    }

    //MARK: - '현재 위치' 버튼 클릭
    @IBAction func touchUpInsideMyLocationButton() {
        print(#function)
       findMyLocation()
    }
    
    func findMyLocation() {
        guard let currentCoordinate = locationManager.location?.coordinate else {
            getLocationUsagePermission()
            checkUserLocationServicesAuthorization()
            print("location failed")
            return
        }
        mapView.showsUserLocation = true
        let region = MKCoordinateRegion(center: currentCoordinate, span: defaultMKCoSpan)
    
        self.mapView.setRegion(region, animated: true)
        //MARK: 위치 이동 후 가끔 핀이 클릭되지 않는 문제.
        //MARK: 화면 이동 후 핀 새로고침. (다른 해결법?)
        self.installPin()
//        mapView.setUserTrackingMode(.follow, animated: true)
    }
    
    //MARK: - 특정 핀 위치로 이동 후 목록 열기
    func openCarListPage(zoneID: String) {
        
        //zoneID에 해당하는 annotation 찾아서 이동.
        if let zonePin = self.mapView.annotations.first(where: { annotation in
            if let zoneAnnot = annotation as? ZoneAnnotation {
                if  zoneAnnot.zone.id == zoneID { return true }
            }
            return false }
        ) {
//            print("\(zonePin.title)으로 이동 시작.")
            //zonePin 위치로 이동
            UIView.animate(withDuration: 0.5) {
                self.moveLocation(latitudeValue: zonePin.coordinate.latitude, longtudeValue: zonePin.coordinate.longitude, delta: self.defaultSpan)
//                print("\(zonePin.title)으로 화면 이동 시작.")
            } completion: { _ in
                //carList 열기
//                print("\(zonePin.title)으로 화면 이동 완료.")
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
                    print("Annotion: \(zonePin). 차량 목록 열기.")
                    self.mapView.selectAnnotation(zonePin, animated: true)
                })
            }
           
            

            
        } else {
            
            print("해당 Pin 찾을 수 없음")
        }
 
    }
    
    //MARK: - 특정 좌표로 이동
    func moveLocation(latitudeValue: CLLocationDegrees, longtudeValue: CLLocationDegrees, delta span: Double) {
        let pLocation = CLLocationCoordinate2DMake(latitudeValue, longtudeValue)
        let pSpanValue = MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span)
        let pRegion = MKCoordinateRegion(center: pLocation, span: pSpanValue)
        self.mapView.setRegion(pRegion, animated: true)
    }

}

//MARK: - Extension: CLLocationManagerDelegate
extension MainViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print(#function)
        checkUserLocationServicesAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

            // the most recent location update is at the end of the array.
            let location: CLLocation = locations[locations.count - 1]
            let longtitude: CLLocationDegrees = location.coordinate.longitude
            let latitude:CLLocationDegrees = location.coordinate.latitude

    }
    
    
    func getLocationUsagePermission() {
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    //MARK: 위치 권한 설정
    func checkCurrentLocationAuthorization(authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        case .restricted:
            print("restricted")
            goSetting()
        case .denied:
            print("denided")
            goSetting()
        case .authorizedAlways:
            print("always")
            findMyLocation()
        case .authorizedWhenInUse:
            print("wheninuse")
            locationManager.startUpdatingLocation()
            findMyLocation()
        @unknown default:
            print("unknown")
        }
        if #available(iOS 14.0, *) {
            let accuracyState = locationManager.accuracyAuthorization
            switch accuracyState {
            case .fullAccuracy:
                print("full")
            case .reducedAccuracy:
                print("reduced")
            @unknown default:
                print("Unknown")
            }
        }
    }
    
    
    //MARK: 사용자에게 '설정'으로 이동 안내
    func goSetting() {
        let alert = UIAlertController(title: "위치권한 요청", message: "설정으로 이동하여 위치 권한을 허용해주세요.", preferredStyle: .alert)
        let settingAction = UIAlertAction(title: "설정", style: .default) { action in
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            // 열 수 있는 url 이라면, 이동
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { UIAlertAction in
            
        }
        alert.addAction(settingAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: 현재 위치 권한
    func checkUserLocationServicesAuthorization() {
        let authorizationStatus: CLAuthorizationStatus
        if #available(iOS 14, *) {
            authorizationStatus = locationManager.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
        if CLLocationManager.locationServicesEnabled() {
            checkCurrentLocationAuthorization(authorizationStatus: authorizationStatus)
        }
    }
}


//MARK: - Extension: MKMapViewDelegate
extension MainViewController: MKMapViewDelegate {
 

    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
//        self.installPin()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard !annotation.isKind(of: MKUserLocation.self) else {
            let MyLocationAnnotationView: MKAnnotationView = MKAnnotationView()
            MyLocationAnnotationView.image = UIImage(named: "img_current")
                    return MyLocationAnnotationView
        }
        
        var annotationView = self.mapView.dequeueReusableAnnotationView(withIdentifier: "Custom")
        
        if annotationView == nil {
            //없으면 하나 만들기
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "Custom")
//            annotationView?.canShowCallout = true

        } else {
            //있으면 등록된 걸 쓰시면 됩니다.
            annotationView?.annotation = annotation
        }
        
        annotationView?.image = UIImage(named: "img_zone_shadow")
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        print(#function)
        //ZoneAnnotation으로 형 변환
        if let zoneAnnotation = view.annotation as? ZoneAnnotation {
            
            print("Zone Clicked. ZoneId: \(zoneAnnotation.zone)")
            
            if navigationController?.visibleViewController != self {
                navigationController?.popToViewController(self, animated: true)
            }
            //차량 목록 페이지 열기
            let carListVC = CarListViewController()
            carListVC.selectedZone = zoneAnnotation.zone
            //뒤로가기 버튼 설정
            let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
            self.navigationItem.backBarButtonItem = backBarButtonItem
            navigationController?.pushViewController(carListVC, animated: true)
            
        } else {
            print("Error: Not ZoneAnnotation")
        }

    }
}
