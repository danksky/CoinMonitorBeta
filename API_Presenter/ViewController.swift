//
//  ViewController.swift
//  API_Presenter
//
//  Created by Daniel Kawalsky on 8/4/18.
//  Copyright © 2018 Daniel Kawalsky. All rights reserved.
//



/*
curl https://rest.coinapi.io/v1/assets --request GET --header "X-CoinAPI-Key: <key>"
*/

/*
curl https://rest.coinapi.io/v1/exchangerate/OMG/USD --request GET --header "X-CoinAPI-Key: <key>"
*/

import UIKit

class ViewController: UITableViewController {

    var symbolArray = [String] ()
    var priceArray =  [Double] ()
    
    let defaultSymbols = ["BTC", "CNY", "ETH", "USD", "LTC", "USDT", "KRW", "XRP", "EUR", "JPY", "BCH", "ETC", "XMR", "NEO", "EOS", "DASH", "ZEC", "TRX", "BNB", "IOTA", "DOGE", "RUB", "QTUM", "XVG", "OMG"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        
        parseJSON()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func parseJSON () {
        let url = URL(string: "https://rest.coinapi.io/v1/assets")

        var urlRequest = URLRequest(url: url!);
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("3D49C6B5-7CA5-4B45-ADFD-A89E03A2D724", forHTTPHeaderField: "X-CoinAPI-Key")
        
        let task = URLSession.shared.dataTask(with: urlRequest) {(data, response, error) in
            
            guard error == nil else {
                print("returning error")
                return
            }
            guard let content = data else {
                print("not returning data")
                return
            }
            
            guard let json = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [[String:Any]] else {
                print("Not containing JSON")
                return
            }
            // https://stackoverflow.com/questions/46852680/urlsession-doesnt-pass-authorization-key-in-header-swift-4
            // https://docs.coinapi.io/#list-all-assets
            
//            print(json.first)
            
            // Change the 'top' value before recording. Don't want to exceed limit!
            var top = 15, i = 0
            for jsonObj in json {
                if ((jsonObj["type_is_crypto"] as! Int) == 1) {
                    var urlRequest = URLRequest(url: URL(string: "https://rest.coinapi.io/v1/exchangerate/" + (jsonObj["asset_id"] as! String) + "/USD")!);
                    urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    urlRequest.setValue("3D49C6B5-7CA5-4B45-ADFD-A89E03A2D724", forHTTPHeaderField: "X-CoinAPI-Key")
                    
                    let task = URLSession.shared.dataTask(with: urlRequest) {(data, response, error) in
                        guard error == nil else {
                            print("returning error")
                            return
                        }
                        guard let content = data else {
                            print("not returning data")
                            return
                        }
                        
                        guard let json = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String:Any] else {
                            print("Not containing JSON")
                            return
                        }
                        
                        self.symbolArray.append(json["asset_id_base"] as! String)
                        self.priceArray.append(json["rate"] as! Double)
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                    task.resume()
                    i += 1
                    if (i >= top) {
                        break
                    }
                }
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    
       
        
        task.resume()
    }

}

extension ViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoinCell", for: indexPath) as! CoinCell
        cell.symbolLabel?.text = self.symbolArray[indexPath.row]
        if (self.priceArray.count >= indexPath.row+1) {
            cell.priceLabel?.text = String(self.priceArray[indexPath.row])
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.symbolArray.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
}


