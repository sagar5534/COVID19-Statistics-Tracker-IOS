//
//  ViewController.swift
//  Covid-19 Stats
//
//  Created by Sagar on 2020-03-25.
//  Copyright © 2020 Sagar. All rights reserved.
//

import UIKit
import Alamofire
import CountryKit


typealias Country = [String: [CountryElement]]

struct CountryElement: Codable {
    let date: String
    let confirmed, deaths: Int
    let recovered: Int?
}


class MainView: UIViewController {
    
    @IBOutlet weak var CountryTable: UITableView!
    @IBOutlet weak var SearchBar: UISearchBar!
    @IBOutlet weak var CurrentDate: UILabel!
    
    let kit = CountryKit()

    var CountryData: [(key: String, value: [CountryElement])]?
    var SearchData: [(key: String, value: [CountryElement])]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CountryTable.delegate = self
        CountryTable.dataSource = self

        SearchBar.delegate = self

        let url = "https://pomber.github.io/covid19/timeseries.json"
        
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default).responseString { response in
                        
                switch response.result {
                case .success(let value):
                    //let JSON = value as! NSDictionary
                    //print(JSON)
                  
                    let jsonData = value.data(using: .utf8)!
                    let x = try! JSONDecoder().decode(Country.self, from: jsonData)
                    
                    self.CountryData = x.sorted(){ $0.value[$0.value.count-1].confirmed > $1.value[$1.value.count-1].confirmed }
                    self.SearchData = self.CountryData
                    self.CountryTable.reloadData()
                    
                case .failure(let error):
                    print(error)
                }
            }
        
        //Date
        let date = Date()
        CurrentDate.text = date.title
        
    }

                
}

extension MainView: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SearchData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
        
        let largeNumber = 31908551587
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        
        let cell:CountryCell = self.CountryTable.dequeueReusableCell(withIdentifier: "CountryCell") as! CountryCell
        
        let flag = kit.searchByName((SearchData?[indexPath.item].key)!)?.emoji ?? "🏳️"
        
        cell.Ranking.text = "\(CountryData!.firstIndex(where: { $0.key == SearchData![indexPath.item].key })! + 1) \(flag)"
       
        cell.Name.text = SearchData?[indexPath.item].key
        
        let total = numberFormatter.string(from: NSNumber(value:SearchData![indexPath.item].value[SearchData![indexPath.item].value.count-1].confirmed))
        cell.TotalCases.text = "Total: " + total!
        
        let new = numberFormatter.string(from: NSNumber(value:SearchData![indexPath.item].value[SearchData![indexPath.item].value.count-1].confirmed - SearchData![indexPath.item].value[SearchData![indexPath.item].value.count-2].confirmed))
        cell.NewCases.setTitle("  +" + new! + " Cases  ", for: .normal)
        
        let dead = numberFormatter.string(from: NSNumber(value:SearchData![indexPath.item].value[SearchData![indexPath.item].value.count-1].deaths - SearchData![indexPath.item].value[SearchData![indexPath.item].value.count-2].deaths))
        
        if dead == "0"{
            cell.DeadCases.setTitle("", for: .normal)
            cell.DeadCases.isHidden = true
        }else{
            cell.DeadCases.setTitle("  -" + dead! + " Deaths  ", for: .normal)
            cell.DeadCases.isHidden = false
        }
        
        return cell
            
    }
    
    
    
}

extension MainView: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.SearchData = self.CountryData
        searchBar.endEditing(true)
        self.SearchBar.endEditing(true)
        self.CountryTable.reloadData()

    }
    
   
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.SearchData = searchText.isEmpty ? self.CountryData : self.CountryData!.filter{
            $0.key.contains(searchText)
        }

        self.CountryTable.reloadData()
    }
    
}

extension Date {
    var title: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd"
        return dateFormatter.string(from: self)
    }
    
}


