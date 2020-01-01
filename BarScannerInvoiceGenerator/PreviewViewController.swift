//
//  PreviewViewController.swift
//  BarScannerInvoiceGenerator
//
//  Created by Admin on 01/01/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import WebKit
import MessageUI

class PreviewViewController: UIViewController, WKNavigationDelegate, WKUIDelegate{
    
    var invoiceInfo: [String: Any]!
    var invoiceComposer: InvoiceComposer!
    var HTMLContent: String!
    
    
    @IBOutlet weak var webPreview: WKWebView!
    @IBOutlet weak var mailInvoiceBtn: UIButton!
    @IBAction func MailInvoiceAction(_ sender: UIButton) {
        invoiceComposer.exportHTMLContentToPDF(HTMLContent: HTMLContent)
        sendEmail()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.webPreview.navigationDelegate = self
        webPreview.navigationDelegate = self
        webPreview.uiDelegate = self
        self.mailInvoiceBtn.layer.cornerRadius = 10.0
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createInvoiceAsHTML()
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mailComposeViewController = MFMailComposeViewController()
            mailComposeViewController.setSubject("Invoice")
            let fileData = NSData(contentsOfFile: invoiceComposer.pdfFilename)
            mailComposeViewController.addAttachmentData(fileData! as Data, mimeType: "application/pdf", fileName: "Invoice")
            present(mailComposeViewController, animated: true, completion: nil)
        }
    }

    func createInvoiceAsHTML() {
        invoiceComposer = InvoiceComposer()
        if let invoiceHTML = invoiceComposer.renderInvoice(invoiceNumber: invoiceInfo["invoiceNumber"] as! String,
                                                           invoiceDate: invoiceInfo["invoiceDate"] as! String,
                                                           recipientInfo: invoiceInfo["recipientInfo"] as! String,
                                                           items: invoiceInfo["items"] as! [[String: String]],
                                                           totalAmount: invoiceInfo["totalAmount"] as! String) {
     
//            webPreview.loadHTMLString(invoiceHTML, baseURL: NSURL(string: invoiceComposer.pathToInvoiceHTMLTemplate!)!)
            webPreview.loadHTMLString(invoiceHTML, baseURL: Bundle.main.bundleURL)
            HTMLContent = invoiceHTML
        }
    }


}
