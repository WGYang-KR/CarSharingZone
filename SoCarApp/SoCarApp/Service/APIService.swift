//
//  APIService.swift
//  SoCarApp
//
//  Created by WG Yang on 2022/06/05.
//

import Foundation
import RxSwift




class APIService {
    let zonesUrl = "http://localhost:3000/zones"
    let carsUrl = "http://localhost:3000/cars?zones_like="
    
    func loadImage(url: URL) -> Observable<UIImage?> {
        return Observable<UIImage?>.create { emitter in

            let task = URLSession.shared.dataTask(with: url) { data, _, _ in

                guard let data = data else {
                    emitter.onNext(nil)
                    emitter.onCompleted()
                    return
                }

                let image = UIImage(data: data)
                emitter.onNext(image)
                emitter.onCompleted()
            }
            task.resume()

            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    func requestZones(_ completion: @escaping ([Zone]) -> Void) {
        guard let url = URL(string: zonesUrl) else {
            print("URL Error")
            return
        }
        let session = URLSession(configuration: .default)
        let dataTask: URLSessionDataTask = session.dataTask(with: url){
            data, response, error in
            
            if let error = error { print(error) ; return }
            guard let data = data else {
                print("The data is empty")
                return
            }
            
            do {
                let zones : [Zone] = try JSONDecoder().decode([Zone].self, from: data)
                completion(zones)
            } catch(let error) {
                print(error)
                return
            }
            
        }
        dataTask.resume()
    }
    
    func requestCars(_ zoneID: String, _ completion: @escaping ([Car])-> Void) {
        
        guard let url = URL(string: carsUrl+zoneID ) else {
            print("URL Error")
            return
        }
        let session = URLSession(configuration: .default)
        let dataTask: URLSessionDataTask = session.dataTask(with: url){
            data, response, error in
            
            if let error = error { print(error) ; return }
            guard let data = data else {
                print("The data is empty")
                return
            }
            
            do {
                let cars : [Car] = try JSONDecoder().decode([Car].self, from: data)
                completion(cars)
            } catch(let error) {
                print(error)
                return
            }
            
        }
        dataTask.resume()
    }
    
}
