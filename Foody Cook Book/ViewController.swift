//
//  ViewController.swift
//  Foody Cook Book
//
//  Created by Arijit Das on 18/02/21.
//

import UIKit
import SDWebImage

class ViewController: UIViewController, UISearchBarDelegate, MealDetailsDelegate {
    
    private let reuseIdentifier = "mealDetailsCell"
    
    @IBOutlet var tblMeal: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    var isSearchEnabled = false
    var Api: ApiManager = ApiManager.sharedInstance
    var global = Global.sharedInstance
    
    var arrFirstLetter: [String] = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.placeholder = "Enter search keyword"
        searchBar.layer.cornerRadius = 30
        searchBar.barStyle = .default
        searchBar.returnKeyType = .search
        searchBar.showsCancelButton = true
        
        if #available(iOS 13.0, *) {
            searchBar.searchTextField.backgroundColor = .white
        } else {
            // Fallback on earlier versions
        }
        
        configureTableView()
        for item in arrFirstLetter {
            randomMealDetails(firstLetter: item)
        }
    }
    
    func configureTableView() {
        tblMeal.delegate = self
        tblMeal.dataSource = self
        tblMeal.separatorColor = .clear
        tblMeal.showsVerticalScrollIndicator = false
        tblMeal.tableFooterView = nil
        
        tblMeal.register(UINib(nibName: "MealDetailsCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if (searchBar.text!.count > 0) {
            isSearchEnabled = true
            searchDetails(mealName: searchBar.text!)
        }
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        isSearchEnabled = false
        self.tblMeal.reloadData()
        searchBar.resignFirstResponder()
    }
    
    func saveMeal(index: Int) {
        if (isSearchEnabled) {
            let meal = self.global.searchDetailsArr[index]
            if (self.global.storeDetailsArr.contains(where: {$0["strMeal"] as? String ?? "" == meal["strMeal"] as? String ?? ""})) {
                if let indexNew = self.global.storeDetailsArr.firstIndex(where: {$0["strMeal"] as? String ?? "" == meal["strMeal"] as? String ?? ""}) {
                    self.global.storeDetailsArr.remove(at: indexNew)
                }
            } else {
                self.global.storeDetailsArr.append(meal)
            }
        } else {
            let meal = self.global.mealDetailsArr[index]
            if (self.global.storeDetailsArr.contains(where: {$0["strMeal"] as? String ?? "" == meal["strMeal"] as? String ?? ""})) {
                if let indexNew = self.global.storeDetailsArr.firstIndex(where: {$0["strMeal"] as? String ?? "" == meal["strMeal"] as? String ?? ""}) {
                    self.global.storeDetailsArr.remove(at: indexNew)
                }
            } else {
                self.global.storeDetailsArr.append(meal)
            }
        }
        self.tblMeal.reloadData()
    }

    //MARK: Api Method
    
    func randomMealDetails(firstLetter: String) {
        if (global.mealDetailsArr.count == 0) {
            self.global.startLoading()
            Api.getRandomMealDetails(firstLetter: firstLetter, completionHandler: { (responseJson, error) in
                print("\(String(describing: responseJson))")

                if (error != nil) {
                    print("\(String(describing: error?.localizedDescription))")
                } else {
                    if let jsonResult: [String : Any] = responseJson as? [String : Any] {
                        //print(jsonResult)

                        let dictJson: [String : Any] = jsonResult.strippingNulls()

                        let meals = dictJson["meals"] as! [[String : Any]]

                        //print("meals: \(meals)")
                        
                        for meal in meals {
                            print("meal: \(meal)")
                            
                            self.global.mealDetailsArr.append(meal)
                        }
                        
                        self.tblMeal.reloadData()
                        self.global.stopLoading()
                    }
                }
            })
        }
    }
    
    func searchDetails(mealName: String) {
        Api.getSearchMealDetails(mealName: mealName, completionHandler: { (responseJson, error) in
            print("\(String(describing: responseJson))")

            if (error != nil) {
                print("\(String(describing: error?.localizedDescription))")
            } else {
                if let jsonResult: [String : Any] = responseJson as? [String : Any] {
                    //print(jsonResult)

                    let dictJson: [String : Any] = jsonResult.strippingNulls()

                    if (dictJson.allKeys().contains("meals")) {
                        let meals = dictJson["meals"] as! [[String : Any]]

                        //print("meals: \(meals)")
                        
                        if (meals.count > 0) {
                            for meal in meals {
                                print("meal: \(meal)")
                                
                                self.global.searchDetailsArr.append(meal)
                            }
                        } else {
                            self.global.searchDetailsArr = []
                        }
                    } else {
                        self.global.searchDetailsArr = []
                    }
                    
                    self.tblMeal.reloadData()
                }
            }
        })
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (isSearchEnabled) {
            return self.global.searchDetailsArr.count
        } else {
            return self.global.mealDetailsArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (isSearchEnabled) {
            if (self.global.searchDetailsArr.count > 0) {
                return 100
            } else {
                return 0
            }
        } else {
            if (self.global.mealDetailsArr.count > 0) {
                return 100
            } else {
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MealDetailsCell
        
        cell.selectionStyle = .none
        
        if (isSearchEnabled) {
            if (self.global.searchDetailsArr.count > 0) {
                
                let meal = self.global.searchDetailsArr[indexPath.row]
                
                cell.delegate = self
                cell.favBtn.tag = indexPath.row
                
                cell.imgMeal.sd_setImage(with: URL(string: meal["strMealThumb"] as? String ?? "")!, placeholderImage: UIImage(named: "logo"))
                cell.imgMeal.contentMode = .scaleAspectFill
                
                cell.titleMeal.text = meal["strMeal"] as? String ?? ""
                cell.descriptionMeal.text = meal["strInstructions"] as? String ?? ""
                cell.descriptionMeal.numberOfLines = cell.descriptionMeal.calculateMaxLines()
                
                if (self.global.storeDetailsArr.count > 0) {
                    if (self.global.storeDetailsArr.contains(where: {$0["strMeal"] as? String ?? "" == meal["strMeal"] as? String ?? ""})) {
                        cell.favBtn.setImage(UIImage(named: "favHover"), for: .normal)
                    } else {
                        cell.favBtn.setImage(UIImage(named: "fav"), for: .normal)
                    }
                } else {
                    cell.favBtn.setImage(UIImage(named: "fav"), for: .normal)
                }
            }
        } else {
            if (self.global.mealDetailsArr.count > 0) {
                
                let meal = self.global.mealDetailsArr[indexPath.row]
                
                cell.delegate = self
                cell.favBtn.tag = indexPath.row
                
                cell.imgMeal.sd_setImage(with: URL(string: meal["strMealThumb"] as? String ?? "")!, placeholderImage: UIImage(named: "logo"))
                cell.imgMeal.contentMode = .scaleAspectFill
                
                cell.titleMeal.text = meal["strMeal"] as? String ?? ""
                cell.descriptionMeal.text = meal["strInstructions"] as? String ?? ""
                cell.descriptionMeal.numberOfLines = cell.descriptionMeal.calculateMaxLines()
                
                if (self.global.storeDetailsArr.count > 0) {
                    if (self.global.storeDetailsArr.contains(where: {$0["strMeal"] as? String ?? "" == meal["strMeal"] as? String ?? ""})) {
                        cell.favBtn.setImage(UIImage(named: "favHover"), for: .normal)
                    } else {
                        cell.favBtn.setImage(UIImage(named: "fav"), for: .normal)
                    }
                } else {
                    cell.favBtn.setImage(UIImage(named: "fav"), for: .normal)
                }
            }
        }
        
        return cell
    }
}


