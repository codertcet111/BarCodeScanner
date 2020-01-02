//
//  CustomPrintPageRenderer.swift
//  BarScannerInvoiceGenerator
//
//  Created by Admin on 01/01/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class CustomPrintPageRenderer: UIPrintPageRenderer {

    let A4PageWidth: CGFloat = 595.2
    
    let A4PageHeight: CGFloat = 841.8
    
    override init() {
        super.init()
     
        // Specify the frame of the A4 page.
        let pageFrame = CGRect(x: 0.0, y: 0.0, width: A4PageWidth, height: A4PageHeight)
     
        // Set the page frame.
        self.setValue(NSValue(cgRect: pageFrame), forKey: "paperRect")
     
        // Set the horizontal and vertical insets (that's optional).
        self.setValue(NSValue(cgRect: pageFrame), forKey: "printableRect")
        self.headerHeight = 50.0
        self.footerHeight = 50.0
    }
    
    override func drawHeaderForPage(at pageIndex: Int, in headerRect: CGRect) {
        // Specify the header text.
        let headerText: NSString = "Dad Of Cad"
     
        // Set the desired font.
        let font = UIFont(name: "Arial-BoldItalicMT", size: 10.0)
     
        // Specify some text attributes we want to apply to the header text.
        let textAttributes = [NSAttributedString.Key.font: font!, NSAttributedString.Key.foregroundColor: UIColor(red: 243.0/255, green: 82.0/255.0, blue: 30.0/255.0, alpha: 1.0), NSAttributedString.Key.kern: 7.5] as [NSAttributedString.Key : Any]
     
        // Calculate the text size.
        let textSize = getTextSize(text: headerText as String, font: nil, textAttributes: textAttributes)
     
        // Determine the offset to the right side.
        let offsetX: CGFloat = 10.0
     
        // Specify the point that the text drawing should start from.
        let pointX = headerRect.size.width - textSize.width - offsetX
        let pointY = headerRect.size.height/2 - textSize.height/2
     
        // Draw the header text.
        headerText.draw(at: CGPoint(x: pointX, y: pointY), withAttributes: textAttributes)
    }

    func getTextSize(text: String, font: UIFont!, textAttributes: [NSAttributedString.Key: Any]! = nil) -> CGSize {
        let testLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: self.paperRect.size.width, height: footerHeight))
        if let attributes = textAttributes {
            testLabel.attributedText = NSAttributedString(string: text, attributes: attributes)
        }
        else {
            testLabel.text = text
            testLabel.font = font!
        }
        testLabel.sizeToFit()
        return testLabel.frame.size
    }
    
    
    override func drawFooterForPage(at pageIndex: Int, in footerRect: CGRect) {
        let footerText: NSString = "Powered by Cortex Solutions!  cortexsolutions.co.in"
     
        let font = UIFont(name: "Noteworthy-Bold", size: 14.0)
        let textSize = getTextSize(text: footerText as String, font: font!)
     
        let centerX = footerRect.size.width/2 - textSize.width/2
        let centerY = footerRect.origin.y + self.footerHeight/2 - textSize.height/2
        let attributes = [NSAttributedString.Key.font: font!, NSAttributedString.Key.foregroundColor: UIColor(red: 205.0/255.0, green: 205.0/255.0, blue: 205.0/255, alpha: 1.0)]
     
        footerText.draw(at: CGPoint(x: centerX, y: centerY), withAttributes: attributes)
    }
}
