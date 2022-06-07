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
    var zones: [Zone]!
    
    let mkSpanSetting =  MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01) //초기 축적도
    let mkInitialCoordinate = CLLocationCoordinate2D(latitude: 37.54330366639085, longitude: 127.04455548501139) //서울숲

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        locationManager.delegate = self
    
        getLocationUsagePermission()
        
        let locationAuthorization = CLLocationManager.authorizationStatus()
        if locationAuthorization == .authorizedWhenInUse || locationAuthorization == .authorizedAlways {
            //findMyLocation()
            mapView.setRegion(MKCoordinateRegion(center: mkInitialCoordinate, span: mkSpanSetting), animated: true )
        } else {
            mapView.setRegion(MKCoordinateRegion(center: mkInitialCoordinate, span: mkSpanSetting), animated: true )
        }
        
        
        let APIServiceIns = APIService()
        APIServiceIns.requestZones{
            zones in
            self.zones = zones
            //핀 만들기
            DispatchQueue.main.async {
                self.addPin(zones: self.zones)
            }
         
        }
        
        
        // bar button 설정
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "ic24_back")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "ic24_back")
        
      

    }
    
    private func addPin( zones: [Zone]) {
        
        for zone in zones {
            
            let pin = ZoneAnnotation(zone: zone)
            mapView.addAnnotation(pin)
        }
    }

    
    @IBAction func touchUpInsideFavoriteZoneButton(_ sender: UIButton) {
        
    }

    
    @IBAction func touchUpInsideMyLocationButton() {
        print(#function)
       findMyLocation()
    }
    
    func findMyLocation() {
        
        guard let currentLocation = locationManager.location else {
            getLocationUsagePermission()
            print("location failed")
            return
        }
        
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true)
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

extension MainViewController: CLLocationManagerDelegate {
    
    func getLocationUsagePermission() {
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    //MARK: - 위치 권한 설정
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
//            findMyLocation()
        case .authorizedWhenInUse:
            print("wheninuse")
//            findMyLocation()
            locationManager.startUpdatingLocation()
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
}

extension MainViewController: MKMapViewDelegate {

    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard !annotation.isKind(of: MKUserLocation.self) else {
                    // 유저 위치를 나타낼때는 기본 파란 그 점 아시죠? 그거 쓰고싶으니까~ 요렇게 해주시고 만약에 쓰고싶은 어노테이션이 있다면 그녀석을 리턴해 주시면 되긋죠? 하하!
            let MyLocationAnnotationView: MKAnnotationView = MKAnnotationView()
            MyLocationAnnotationView.image = UIImage(named: "img_current")
                    return MyLocationAnnotationView
        }
        //우리가 만들고 싶은 커스텀 어노테이션을 만들어 줍시다. 그냥 뿅 생길 수 없겠죠? 보여주고 싶은 모양을 뷰로 짜준다고 생각하시면 됩니다.
        //즉시 인스턴스로 만들어 줘 보겠습니다요. 어떻게 생겼을지는 아직 안정했지만 일단 커스텀이라는 식별자?를 가진 뷰로 만들어 줬습니다.
        //마커 어노테이션뷰 라는 어노테이션뷰를 상속받는 뷰가 따로있습니다. 풍선모양이라고 하는데 한번 만들어 보시는것도 좋겠네요! 테두리가 있고 안에 내용물을 바꾸는 식으로 설정이 되는듯 해요.
        var annotationView = self.mapView.dequeueReusableAnnotationView(withIdentifier: "Custom")
        
        if annotationView == nil {
            //없으면 하나 만들어 주시고
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "Custom")
//            annotationView?.canShowCallout = true
            
//            //callOutView를 통해서 추가적인 액션을 더해줄수도 있겠죠! 와 무지 간편합니다!
//            let miniButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
//            miniButton.setImage(UIImage(systemName: "person"), for: .normal)
//            miniButton.tintColor = .blue
//            annotationView?.rightCalloutAccessoryView = miniButton
            
        } else {
            //있으면 등록된 걸 쓰시면 됩니다.
            annotationView?.annotation = annotation
        }
        
        annotationView?.image = UIImage(named: "img_zone_shadow")
        
        //상황에 따라 다른 annotationView를 리턴하게 하면 여러가지 모양을 쓸 수도 있겠죠?
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        //ZoneAnnotation으로 형 변환
        if let zoneAnnotation = view.annotation as? ZoneAnnotation {
            
            print("Zone Clicked. ZoneId: \(zoneAnnotation.zone)")
            
            let carListVC = CarListViewController()
            carListVC.selectedZone = zoneAnnotation.zone
            
            //뒤로가기 버튼 설정
            let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
            self.navigationItem.backBarButtonItem = backBarButtonItem
            
            
            navigationController?.pushViewController(carListVC, animated: true)
            
        } else {
            print("Error: Not ZoneAnnotation")
        }
        
        //해당 Zone Car List 호출
    }
}
