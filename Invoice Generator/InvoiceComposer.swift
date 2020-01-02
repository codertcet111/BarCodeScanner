//
//  InvoiceComposer.swift
//  BarScannerInvoiceGenerator
//
//  Created by Admin on 01/01/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class InvoiceComposer: NSObject {
    let pathToInvoiceHTMLTemplate = Bundle.main.path(forResource: "invoice", ofType: "html")
    
    let pathToSingleItemHTMLTemplate = Bundle.main.path(forResource: "single_item", ofType: "html")

    let pathToLastItemHTMLTemplate = Bundle.main.path(forResource: "last_item", ofType: "html")

    let senderInfo = "Dad Of Cad<br>211, Western Edge II<br>Behind Metro Super market<br>Borivali east, Mumbai - 400066<br>gaurav@dadofcad.com<br>PAN : CATPS2150L | GSTIN : 27CATPS2150L1Z2<br>"

    let dueDate = ""

    let paymentMethod = "Current A/c name : DAD OF CAD<br>A/c no : 333705500055<br>Bank : ICICI<br>IFSC : ICIC0003337<br>Branch : Borivali TATA Power Branch<br>"

//    let logoImageURL = "https://www.appcoda.com/wp-content/uploads/2015/12/blog-logo-dark-400.png"
    
    let logoImageURL = "DOCLogoPNG.png"
    
    var invoiceNumber: String!
    
    var receiverInfo: String!
    
    var pdfFilename: String!

//    var invoiceNumber = "\(Int.random(in: 1000000 ... 6000000))"
//
//    var pdfFilename = "DadOfCad_\(Date())"
    
    override init() {
        super.init()
        self.invoiceNumber = "\(Int.random(in: 1000000 ... 6000000))"
    }
    
    func exportHTMLContentToPDF(HTMLContent: String) {
        let printPageRenderer = CustomPrintPageRenderer()
     
        let printFormatter = UIMarkupTextPrintFormatter(markupText: HTMLContent)
        printPageRenderer.addPrintFormatter(printFormatter, startingAtPageAt: 0)
     
        let pdfData = drawPDFUsingPrintPageRenderer(printPageRenderer: printPageRenderer)
     
        pdfFilename = "\(AppDelegate.getAppDelegate().getDocDir())/Invoice\(invoiceNumber ?? "00").pdf"
        pdfData?.write(toFile: pdfFilename, atomically: true)
     
        print(pdfFilename!)
    }


    func drawPDFUsingPrintPageRenderer(printPageRenderer: UIPrintPageRenderer) -> NSData! {
        let data = NSMutableData()
     
        UIGraphicsBeginPDFContextToData(data, CGRect.zero, nil)
     
        UIGraphicsBeginPDFPage()
     
        printPageRenderer.drawPage(at: 0, in: UIGraphicsGetPDFContextBounds())
     
        UIGraphicsEndPDFContext()
     
        return data
    }
    
    
    func renderInvoice(invoiceNumber: String, invoiceDate: String, recipientInfo: String, items: [[String: String]], totalAmount: String, receiverName: String, receiverEmail: String) -> String! {
        // Store the invoice number for future use.
           self.invoiceNumber = invoiceNumber
        self.receiverInfo = "\(receiverName)<br>\(receiverEmail)<br>"
           do {
               // Load the invoice HTML template code into a String variable.
               var HTMLContent = try String(contentsOfFile: pathToInvoiceHTMLTemplate!)
        
               // Replace all the placeholders with real values except for the items.
               // The logo image.
            let image = UIImage(named:"DOCLogoPNG") // Your Image
            let imageData = image!.pngData() ?? nil
            let base64String = imageData?.base64EncodedString() ?? "" // Your String Image
               HTMLContent = HTMLContent.replacingOccurrences(of: "#LOGO_IMAGE#", with: "<img src='data:image/png;base64,\(String(describing: base64String) )'>")
        
               // Invoice number.
               HTMLContent = HTMLContent.replacingOccurrences(of: "#INVOICE_NUMBER#", with: invoiceNumber)
        
               // Invoice date.
               HTMLContent = HTMLContent.replacingOccurrences(of: "#INVOICE_DATE#", with: invoiceDate)
        
               // Due date (we leave it blank by default).
               HTMLContent = HTMLContent.replacingOccurrences(of: "#DUE_DATE#", with: dueDate)
        
               // Sender info.
               HTMLContent = HTMLContent.replacingOccurrences(of: "#SENDER_INFO#", with: senderInfo)
        
               // Recipient info.
               HTMLContent = HTMLContent.replacingOccurrences(of: "#RECIPIENT_INFO#", with: receiverInfo)
        
               // Payment method.
               HTMLContent = HTMLContent.replacingOccurrences(of: "#PAYMENT_METHOD#", with: paymentMethod)
        
               // Total amount.
               HTMLContent = HTMLContent.replacingOccurrences(of: "#TOTAL_AMOUNT#", with: totalAmount)
            
               // The invoice items will be added by using a loop.
                  var allItems = ""
           
                  // For all the items except for the last one we'll use the "single_item.html" template.
                  // For the last one we'll use the "last_item.html" template.
                  for i in 0..<items.count {
                      var itemHTMLContent: String!
           
                      // Determine the proper template file.
                      if i != items.count - 1 {
                          itemHTMLContent = try String(contentsOfFile: pathToSingleItemHTMLTemplate!)
                      }
                      else {
                          itemHTMLContent = try String(contentsOfFile: pathToLastItemHTMLTemplate!)
                      }
           
                      // Replace the description and price placeholders with the actual values.
                      itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#ITEM_DESC#", with: "\(items[i]["item"]!) (\(items[i]["productCode"]!))")
           
                      // Format each item's price as a currency value.
                      let formattedPrice = AppDelegate.getAppDelegate().getStringValueFormattedAsCurrency(items[i]["price"]!)
                      itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#PRICE#", with: formattedPrice)
           
                      // Add the item's HTML code to the general items string.
                      allItems += itemHTMLContent
                  }
           
                  // Set the items.
                  HTMLContent = HTMLContent.replacingOccurrences(of: "#ITEMS#", with: allItems)
           
                  // The HTML code is ready.
                  return HTMLContent
        
           }
           catch {
               print("Unable to open and use HTML template files.")
           }
        
           return nil
    }
}
