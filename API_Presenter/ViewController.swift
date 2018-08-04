//
//  ViewController.swift
//  API_Presenter
//
//  Created by Daniel Kawalsky on 8/4/18.
//  Copyright © 2018 Daniel Kawalsky. All rights reserved.
//



/*
curl https://rest.coinapi.io/v1/assets --request GET --header "X-CoinAPI-Key: 3D49C6B5-7CA5-4B45-ADFD-A89E03A2D724"
*/

import UIKit

class ViewController: UITableViewController {

    var symbolArray = [String] ()
    var priceArray =  [Int] ()
    
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
    
    func parseJSON() {
        let url = URL(string: "https://rest.coinapi.io/v1/assets")
        
        var urlRequest = URLRequest(url: url!);
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("3D49C6B5-7CA5-4B45-ADFD-A89E03A2D724", forHTTPHeaderField: "X-CoinAPI-Key")
        print(urlRequest)
        
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
            // To pick up where I left off: https://stackoverflow.com/questions/46852680/urlsession-doesnt-pass-authorization-key-in-header-swift-4
            // https://docs.coinapi.io/#list-all-assets
            
//            print(json.first)
            var top = 25, i = 0
            for jsonObj in json {
                self.symbolArray.append(jsonObj["asset_id"] as! String)
//                self.priceArray.append(jsonObj) Doesn't happen here.
//                Happens in another call (after all symbols gathered) as parameters in the request for the price
                i += 1
                if (i >= top) {
                    break
                }
            }
            print(self.symbolArray)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
        
        task.resume()
    }

}

extension ViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoinCell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = self.symbolArray[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.symbolArray.count
    }
    
}


