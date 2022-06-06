//
//  CarListViewController.swift
//  SoCarApp
//
//  Created by WG Yang on 2022/06/06.
//

import UIKit

class CarListViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    var selectedZone: Zone! //선택된 Zone
    
    let carListCellIdentifier = "CarListCell"
    let zoneInfoCellIdentifier = "ZoneInfoCell"
    
    var carList: [Car] = [Car]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //print(selectedZone)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "CarListTableViewCell", bundle: nil), forCellReuseIdentifier: carListCellIdentifier)
        tableView.register(UINib(nibName: "ZoneInfoTableViewCell", bundle: nil), forCellReuseIdentifier: zoneInfoCellIdentifier
        )
        
        // Do any additional setup after loading the view.
        APIService.requestCars("16"){
            cars in
            self.carList = cars
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            print("cars:\(cars)")
        }
    }


}

extension CarListViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        switch section {
        
        case 0:
            return 1
        case 1:
            return carList.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   
        let sectionNum = indexPath.section
        switch sectionNum {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: zoneInfoCellIdentifier, for: indexPath) as? ZoneInfoTableViewCell else {
                print("Error: \(#function)")
                return ZoneInfoTableViewCell()
            }
            
            cell.zoneNameLabel.text = selectedZone.name
            cell.zoneAliasLabel.text = selectedZone.alias
            
            return cell
            
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: carListCellIdentifier, for: indexPath) as? CarListTableViewCell else {
                print("Error: \(#function)")
                return CarListTableViewCell()
            }
            
            let car = carList[indexPath.row]
    //        cell.carImageView
            cell.carNameLabel.text = car.name
            cell.carDescriptionLabel.text = car.description
      
            return cell
            
        default:
            return UITableViewCell()
            
        }
    }
    
   
}

extension CarListViewController: UITableViewDelegate {
    
    
}
