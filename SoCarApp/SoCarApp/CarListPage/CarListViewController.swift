//
//  CarListViewController.swift
//  SoCarApp
//
//  Created by WG Yang on 2022/06/06.
//

import UIKit
import RxSwift
import RxCocoa

class CarListViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    var selectedZone: Zone! //선택된 Zone
    
    let carListCellIdentifier = "CarListCell"
    let zoneInfoCellIdentifier = "ZoneInfoCell"
    
    var headerList = [String]() //섹션 헤더
    var carListInSection = [[Car]]() //섹션 내 차량 리스트
    
    var isFavoriteZone = false
    var headerFavoriteButton: UIButton!
    let favoriteZoneManager = FavoriteZoneManager()
    
    var diposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //print(selectedZone)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "CarListTableViewCell", bundle: nil), forCellReuseIdentifier: carListCellIdentifier)
        
        let headerView = ZoneInfoTableHeader(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 70), zone: selectedZone)
        headerView.zoneNameLabel.text = self.selectedZone.name
        headerView.zoneAliasLabel.text = self.selectedZone.alias
        tableView.tableHeaderView = headerView
   
        
        // Do any additional setup after loading the view.
        APIService.requestCars(selectedZone.id){
            cars in
            self.figureHeaderCarList(cars: cars)
        }
        
        
    }

    //MARK: - 차량 종류별 섹션 헤더, 섹션 리스트 생성
    func figureHeaderCarList(cars:[Car]) {
       
        DispatchQueue.global().async {
           
            var dicCars = [String : [Car]]()
            
            for car in cars {
                
                if var oldCarList:[Car] = dicCars[car.category] {
                    oldCarList.append(car)
                    dicCars[car.category] = oldCarList
                } else {
                    let newCarList = [car]
                    dicCars[car.category] = newCarList
                }
            }
            
            for (key,value) in dicCars {
                self.headerList.append(key)
                self.carListInSection.append(value)
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

}

extension CarListViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return headerList.count
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headerList[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return carListInSection[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 
        guard let cell = tableView.dequeueReusableCell(withIdentifier: carListCellIdentifier, for: indexPath) as? CarListTableViewCell else {
                print("Error: \(#function)")
                return CarListTableViewCell()
        }
            
        let car = carListInSection[indexPath.section][indexPath.row]
        //cell.carImageView
        cell.carNameLabel.text = car.name
        cell.carDescriptionLabel.text = car.description
        
     
        return cell
            
    }
    
   
}

extension CarListViewController: UITableViewDelegate {
    
}
