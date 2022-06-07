//
//  FavoriteZoneViewController.swift
//  SoCarApp
//
//  Created by WG Yang on 2022/06/07.
//

import UIKit

class FavoriteZoneViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    let ZoneCellIdentifier = "ZoneCell"
    var mainPageViewController: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        installHeader()
        
        tableView.register(UINib(nibName: "ZoneTableViewCell", bundle: nil), forCellReuseIdentifier: ZoneCellIdentifier)
        
       
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
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}
extension FavoriteZoneViewController: UITableViewDelegate {
    
}
