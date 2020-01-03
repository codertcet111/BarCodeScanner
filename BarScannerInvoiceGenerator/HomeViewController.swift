//
//  HomeViewController.swift
//  BarScannerInvoiceGenerator
//
//  Created by Admin on 01/01/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import BarcodeScanner

class HomeViewController: UIViewController {

    //MARK: Variables and Constants
    var totalCost: Double = 0.0
    var totalItems: Int = 0
    //item: Name, price: Price, productCode: ProductCode
    var itemsArray: [[String: String]] = []
    
    //MARK: Outlets
    @IBOutlet weak var refreshList: UIButton!
    
    @IBAction func refreshListAction(_ sender: UIButton) {
        UIView.animate(withDuration: 1) {
            self.totalCost = 0.0
            self.totalItems = 0
            self.priceText.text = "\(self.totalCost)"
            self.loadViewIfNeeded()
            self.itemsArray = []
            self.itemsListingTable.reloadData()
        }
    }
    @IBOutlet weak var scaneButton: UIButton!
    @IBAction func scaneAction(_ sender: UIButton) {
        let viewController = BarcodeScannerViewController()
        viewController.codeDelegate = self
        viewController.errorDelegate = self
        viewController.dismissalDelegate = self
        navigationController?.pushViewController(viewController, animated: true)
    }
    @IBOutlet weak var generateInvoiceAndMail: UIButton!
    @IBAction func generateAndInvoiceMailAction(_ sender: UIButton) {
        self.itemsArray = [["item": "Bottle", "price": "200", "productCode": "X1123"], ["item": "Bottle 2", "price": "100", "productCode": "X1123"]]
        self.totalCost = 300.0
        if self.itemsArray.count != 0{
            self.performSegue(withIdentifier: "gatherReceiverDataSegue", sender: self)
        }else{
            self.showToast(message: "No Items")
        }
    }
    @IBOutlet weak var totalPriceTextLabel: UILabel!
    
    @IBOutlet weak var itemsLabelText: UILabel!
    
    @IBOutlet weak var itemsListingTable: UITableView!
    @IBOutlet weak var priceText: UILabel!
    
    //MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.beutifyView()
    }
    
    func beutifyView(){
        self.scaneButton.layer.cornerRadius = 10.0
        self.generateInvoiceAndMail.layer.cornerRadius = 10.0
        self.refreshList.layer.cornerRadius = 10.0
    }
    
    @objc func removeItemFromArray(_ sender : UIButton){
       //print(sender.tag)
        if self.itemsArray.indices.contains(sender.tag){
            UIView.animate(withDuration: 1) {
                let tempItemCost = Double(self.itemsArray[sender.tag]["price"] ?? "0.0") ?? 0.0
                self.totalCost -= tempItemCost
                self.totalItems -= 1
                self.priceText.text = "\(String(format:"%.2f", self.totalCost))"
                self.loadViewIfNeeded()
                self.itemsArray.remove(at: sender.tag)
                self.itemsListingTable.reloadData()
            }
        }
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "gatherReceiverDataSegue" {
                let nextViewController = segue.destination as! GatherReceiverInfoViewController
//                var taxIsTheir = false
//                for item in itemsArray{
//                    if item["item"] == "GST Tax (18.0 %)"{
//                        taxIsTheir = true
//                    }
//                }
//                if !taxIsTheir{
//                    let gstTax = (self.totalCost * 0.18)
//                    itemsArray.append(["item": gstTextString, "price": "\(gstTax)", "productCode": "18.0 %"])
//                    self.totalCost += gstTax
//                }
                nextViewController.itemsArray = self.itemsArray
                nextViewController.totalItems = self.totalItems
                nextViewController.totalCost = self.totalCost
            }
        }
    }
    
    func showToast(message : String) {

        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }

}

//MARK: TableView Delegates implemented
extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemsListingTableViewCell") as! ItemsListingTableViewCell
        cell.selectionStyle = .none
        if self.itemsArray.indices.contains(indexPath.row) {
            let tempItem = self.itemsArray[indexPath.row]
            cell.itemName.text = tempItem["productCode"]
            cell.priceText.text = tempItem["price"]
            cell.itemNumber.text = "\(indexPath.row + 1)"
            cell.itemRemoveBtn.tag = indexPath.row
            cell.itemRemoveBtn.addTarget(self, action: #selector(self.removeItemFromArray(_:)), for: .touchUpInside)
        }
        return cell
    }
    
    
}

extension HomeViewController: BarcodeScannerCodeDelegate {
   func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
     print(code)
    //Add scanned item to self.itemsArray
    //Fecth price, name and ProductCode for product from code received and append it into array
    var tempCost = 0.0
    var tempName = ""
    var tempProductCode = ""
    //
    //Fetch data from code
    let productInfoArray = code.components(separatedBy: "\n")
    if productInfoArray.count == 3{
        if productInfoArray.indices.contains(0){
            tempName = productInfoArray[0]
        }
        if productInfoArray.indices.contains(1){
            tempCost = Double(productInfoArray[1]) ?? 0.0
        }
        if productInfoArray.indices.contains(2){
            tempProductCode = productInfoArray[2]
        }
    }
    //
    self.itemsArray.append(["item": tempName,"price": "\(tempCost)","productCode": tempProductCode])
    self.totalCost += tempCost
    self.totalItems += 1
    //Reoad items table View
    self.itemsListingTable.reloadData()
    self.priceText.text = "\(String(format:"%.2f", totalCost))"
    self.loadViewIfNeeded()
    //controller.reset()
    controller.dismiss(animated: true, completion: nil)
    self.navigationController?.popViewController(animated: true)
   }
}
extension HomeViewController: BarcodeScannerErrorDelegate {
  func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error) {
    print(error)
  }
}
extension HomeViewController: BarcodeScannerDismissalDelegate {
  func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
    controller.dismiss(animated: true, completion: nil)
  }
}
