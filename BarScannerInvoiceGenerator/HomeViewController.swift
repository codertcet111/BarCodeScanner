//
//  HomeViewController.swift
//  BarScannerInvoiceGenerator
//
//  Created by Admin on 01/01/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    //MARK: Variables and Constants
    var totalCost: Double = 0.0
    var totalItems: Int = 0
    //At 0: Name, 1: Price, 2: Code
    var itemsArray: [[String]] = []
    
    //MARK: Outlets
    @IBOutlet weak var scaneButton: UIButton!
    @IBAction func scaneAction(_ sender: UIButton) {
        
    }
    @IBOutlet weak var generateInvoiceAndMail: UIButton!
    @IBAction func generateAndInvoiceMailAction(_ sender: UIButton) {
        
    }
    @IBOutlet weak var totalPriceTextLabel: UILabel!
    
    @IBOutlet weak var itemsLabelText: UILabel!
    
    @IBOutlet weak var itemsListingTable: UITableView!
    @IBOutlet weak var priceText: UILabel!
    
    //MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @objc func removeItemFromArray(_ sender : UISwitch!){
       //print(sender.tag)
        if self.itemsArray.indices.contains(sender.tag){
            self.itemsArray.remove(at: sender.tag)
        }
    }

}

//MARK: TableView Delegates implemented
extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemsListingTableViewCell") as! ItemsListingTableViewCell
        if self.itemsArray.indices.contains(indexPath.row) {
            let tempItem = self.itemsArray[indexPath.row]
            cell.itemName.text = tempItem[0]
            cell.priceText.text = tempItem[1]
            cell.itemNumber.text = "\(indexPath.row)"
            cell.itemRemoveBtn.tag = indexPath.row
            cell.itemRemoveBtn.addTarget(self, action: #selector(self.removeItemFromArray(_:)), for: .valueChanged)
        }
        return cell
    }
    
    
}
