//
//  CitySelectorCell.swift
//  BirthdayCircle
//
//  Created by Lin on 15/2/15.
//  Copyright (c) 2015年 Lin. All rights reserved.
//

import UIKit

@objc(CitySelectorCell)
class CitySelectorCell: XLFormBaseCell, UIPickerViewDelegate, UIPickerViewDataSource, XLFormInlineRowDescriptorCell {
    var provinces: NSArray!
    var areas: NSArray!
    var citys: NSArray!
    
    var pickerView: UIPickerView! {
        if self.pickerView != nil {
            return self.pickerView
        }
        let view = UIPickerView()
        view.delegate = self
        view.dataSource = self
        return view
    }
    var inlineRowDescriptor: XLFormRowDescriptor!
    
    override func canBecomeFirstResponder() -> Bool {
        return self.inlineRowDescriptor == nil
    }
    
    override func canResignFirstResponder() -> Bool {
        return true
    }
    
    
    override func configure() {
        super.configure()
        
        provinces = NSArray(contentsOfFile: NSBundle.mainBundle().pathForResource("area.plist", ofType: nil)!)
        citys = (provinces[0] as NSDictionary)["cities"] as NSArray
        areas = (citys[0] as NSDictionary)["areas"] as NSArray
        
        self.contentView.addSubview(self.pickerView)
        layout(pickerView) { pickerView in
            pickerView.centerX == pickerView.superview!.centerX; return
        }
        
    }
    
    override func update() {
        super.update()
    }
    
    override class func formDescriptorCellHeightForRowDescriptor(rowDescriptor: XLFormRowDescriptor!) -> CGFloat {
        return 216.0
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        switch component {
        case 0:
            return (provinces[row] as NSDictionary)["state"] as String
        case 1:
            return (citys[row] as NSDictionary)["city"] as String
        case 2:
            if areas.count > 0 {
                return areas[row] as String
            }
        default:
            break
        }
        return ""
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            citys = (provinces[row] as NSDictionary)["cities"] as NSArray
            pickerView.selectRow(0, inComponent: 1, animated: true)
            pickerView.reloadComponent(1)
            
            areas = (citys[0] as NSDictionary)["areas"] as NSArray
            pickerView.selectRow(0, inComponent: 2, animated: true)
            pickerView.reloadComponent(2)
        case 1:
            areas = (citys[row] as NSDictionary)["areas"] as NSArray
            pickerView.selectRow(0, inComponent: 2, animated: true)
            pickerView.reloadComponent(2)
        default:
            break
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return provinces.count
        case 1:
            return citys.count
        case 2:
            return areas.count
        default:
            return 0
        }
    }
    
    
}
