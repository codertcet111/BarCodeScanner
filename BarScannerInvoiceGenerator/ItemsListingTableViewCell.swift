//
//  ItemsListingTableViewCell.swift
//  BarScannerInvoiceGenerator
//
//  Created by Admin on 01/01/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class ItemsListingTableViewCell: UITableViewCell {
    @IBOutlet weak var cellMainView: UIView!
    @IBOutlet weak var itemNumber: UILabel!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemRemoveBtn: UIButton!
    @IBOutlet weak var priceText: UILabel!
}
