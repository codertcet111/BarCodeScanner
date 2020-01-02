//
//  GatherReceiverInfoViewController.swift
//  BarScannerInvoiceGenerator
//
//  Created by Admin on 02/01/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class GatherReceiverInfoViewController: UIViewController {

    //MARK: Outlets
    var totalCost: Double = 0.0
    var totalItems: Int = 0
    //item: Name, price: Price, productCode: ProductCode
    var itemsArray: [[String: String]] = []
    var discountOption: Int = 0 //0: Percentage, 1: Flat Discount
    var discountValue: Double = 0
    var gstTextString = "GST Tax "
    var totalDiscountTextString = "Total Discount"
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var receiverName: UITextField!
    @IBOutlet weak var receiverEmail: UITextField!
    @IBOutlet weak var discountOptionBtn: UIButton!
    @IBAction func discountOptionAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "Discount Option", message: nil, preferredStyle: .alert)
        
        let closure = { (action: UIAlertAction!) -> Void in
            self.discountOption = (action.title ?? "\(discountPercentageText)") == discountPercentageText ? 0 : 1
            self.discountOptionBtn.setTitle("\(action.title ?? "\(discountPercentageText)")", for: .normal)
            self.discountOptionValueField.text = "0"
        }
        for field in [discountPercentageText, discountFlatDiscountText] {
            alert.addAction(UIAlertAction(title: field, style: .default, handler: closure))
        }
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: {(_) in }))
        self.present(alert, animated: false, completion: nil)
    }
    
    @IBOutlet weak var discountOptionValueField: UITextField!
    @IBOutlet weak var proceedBtn: UIButton!
    @IBAction func ProceedAction(_ sender: UIButton) {
        
        if self.discountOption == 0 && Double(self.discountOptionValueField.text ?? "0")! > 100.0{
            self.showToast(message: "Incorrect Percentage")
            return
        }
        
        if self.discountOption == 1 && Double(self.discountOptionValueField.text ?? "0")! > self.totalCost{
            self.showToast(message: "Incorrect Discount!")
            return
        }
        
        var discountIsTheir = false
        for item in itemsArray{
            if item["item"] == totalDiscountTextString{
                discountIsTheir = true
            }
        }
        if !discountIsTheir{
            self.addDiscountAmount()
        }
        
        if self.receiverName.text == ""{
            self.showToast(message: "Name is missing")
        }else if self.receiverEmail.text == ""{
            self.showToast(message: "Email is missing")
        }else{
            self.performSegue(withIdentifier: "idSeguePresentPreview", sender: self)
        }
    }
    
    func addDiscountAmount(){
        if Double(self.discountOptionValueField.text ?? "0") == 0.0{
            return
        }else{
            let discountValue = Double(self.discountOptionValueField.text ?? "0.0")!
            let discountAmount = self.discountOption == 0 ? (discountValue * self.totalCost * 0.01) : (discountValue)
            itemsArray.append(["item": totalDiscountTextString, "price": "\(discountAmount)", "productCode": " "])
            self.totalCost -= discountAmount
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.proceedBtn.layer.cornerRadius = 10.0
        self.discountOptionBtn.layer.cornerRadius = 10.0
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "idSeguePresentPreview" {
                let previewViewController = segue.destination as! PreviewViewController
                let date = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "dd.MM.yyyy"
                var taxIsTheir = false
                for item in itemsArray{
                    if item["item"] == gstTextString{
                        taxIsTheir = true
                    }
                }
                if !taxIsTheir{
                    let gstTax = (self.totalCost * 0.18)
                    itemsArray.append(["item": gstTextString, "price": "\(gstTax)", "productCode": "18.0 %"])
                    self.totalCost += gstTax
                }
                previewViewController.invoiceInfo = ["invoiceNumber": "\(Int.random(in: 1000000 ... 6000000))", "invoiceDate": "\(formatter.string(from: date))", "recipientInfo": "Not an Address", "items": itemsArray, "totalAmount": "\(self.totalCost)", "receiverName": self.receiverName.text ?? "", "receiverEmail": self.receiverEmail.text ?? ""]
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
