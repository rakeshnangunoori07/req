//
//  ViewController.swift
//  Task
//
//  Created by Swaminath-Ojas on 20/09/19.
//  Copyright © 2019 Swaminath-Ojas. All rights reserved.
//

import UIKit

var accounts = [[String: Any]]()
var accountName = [Int]()
var currency = [String]()

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var collView: UICollectionView!
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return accountName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collView.dequeueReusableCell(withReuseIdentifier: "collCell", for: indexPath as IndexPath) as! collCell
        
        cell.accountNamelbl.text = "\(accountName[indexPath.row])"
        cell.currencyLbl.text = currency[indexPath.row]
        return cell
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        startTimer()
        
        // Do any additional setup after loading the view.
    }
    func getData() {
        
        let url = URL(string: "http://115.112.122.100:5001/service/v1/account/153")!
        
        let session = URLSession.shared
        
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    print(json)
                    
                    let list = json["list"] as! [[String: Any]]
                    print(list)
                    for objs in list {
                        let numbers = objs["account_no"] as! Int
                        accountName.append(numbers)
                        let currencies = objs["currency"] as! String
                        currency.append(currencies)
                    }
                    DispatchQueue.main.async {
                        self.collView.reloadData()

                    }
                    
                    print(accountName)
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        
        task.resume()

    }

    func startTimer() {
        
        let timer =  Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(self.scrollAutomatically), userInfo: nil, repeats: true)
    }
    
    
    @objc func scrollAutomatically(_ timer1: Timer) {
        
        if let coll  = collView {
            for cell in coll.visibleCells {
                let indexPath: IndexPath? = coll.indexPath(for: cell)
                if ((indexPath?.row)! < accountName.count - 1){
                    let indexPath1: IndexPath?
                    indexPath1 = IndexPath.init(row: (indexPath?.row)! + 1, section: (indexPath?.section)!)
                    
                    coll.scrollToItem(at: indexPath1!, at: .right, animated: true)
                }
                else{
                    let indexPath1: IndexPath?
                    indexPath1 = IndexPath.init(row: 0, section: (indexPath?.section)!)
                    coll.scrollToItem(at: indexPath1!, at: .left, animated: true)
                }
                
            }
        }
    }
}

class collCell: UICollectionViewCell {
    
    @IBOutlet weak var accountNamelbl: UILabel!
    @IBOutlet weak var currencyLbl: UILabel!
    
    
}
