//
//  FavoriteZoneViewController.swift
//  SoCarApp
//
//  Created by WG Yang on 2022/06/07.
//

import UIKit

class FavoriteZoneViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    let zoneCellIdentifier = "ZoneCell"
    var mainPageViewController: MainViewController!
    var favoriteZones =  [Zone]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        installHeader()
        tableView.register(UINib(nibName: "ZoneTableViewCell", bundle: nil), forCellReuseIdentifier: zoneCellIdentifier)
        
        loadFavoriteZones()
       
    }
    
    func loadFavoriteZones() {
        let apiService = APIService()
        let favoriteZoneManager = FavoriteZoneManager()
        let zoneIDList = favoriteZoneManager.favoriteZones
        //모든 존 정보 받기
        apiService.requestZones(){
            allZones in
            DispatchQueue.global().async {
                print("Favorite Zones:")
                for zoneID in zoneIDList {
                   
                    if let zone = allZones.first(where: {$0.id == zoneID}) {
                        self.favoriteZones.append(zone)
                        print("\(zoneID)")
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        
    }
    
    @IBAction func touchUpSideCloseButton() {
    
        self.dismiss(animated: true)
    }
    
    func installHeader() {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 70))
        
        let headerLabel = UILabel()
        headerLabel.text = "쏘카존 즐겨찾기"
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.adjustsFontForContentSizeCategory = false
        headerLabel.font = .systemFont(ofSize: 24)
        
        headerView.addSubview(headerLabel)
        
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 24),
            headerLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 24),
            headerView.trailingAnchor.constraint(equalTo: headerLabel.trailingAnchor, constant: 24),
            headerView.bottomAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 24)
               ])
    
        self.tableView.tableHeaderView = headerView
    }

}

extension FavoriteZoneViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.favoriteZones.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: zoneCellIdentifier, for: indexPath) as? ZoneTableViewCell else {
            print(#function)
            return UITableViewCell()
        }
        
        let zone = self.favoriteZones[indexPath.row]
        cell.zoneID = zone.id
        cell.nameLabel.text = zone.name
        cell.aliasLabel.text = zone.alias
        
        return cell
    }
    
    
}
extension FavoriteZoneViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let zoneIDWillMove = favoriteZones[indexPath.row].id
        self.dismiss(animated: true){
            self.mainPageViewController.openCarListPage(zoneID: zoneIDWillMove)
        }
    }
    
}
