
//
//  BaseVC.swift
//  Kishor
//
//  Created by Macbook Pro on 18/10/2019.
//  Copyright © MygenomeBox. All rights reserved.
//

import UIKit
import Toast_Swift
import JGProgressHUD
import SwiftEventBus
import ContactsUI
import Async
import SDWebImage



class BaseVC: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var hud : JGProgressHUD?
//    var bannerView: GADBannerView!
//       var interstitial: GADInterstitial!
    
    //    private var noInternetVC: NoInternetDialogVC!
    var userId:String? = nil
    var sessionId:String? = nil
    var contactNameArray = [String]()
    var contactNumberArray = [String]()
    var deviceID:String? = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
            
        }
        
        
        

    
  
   
    
    
    func showProgressDialog(text: String) {
        hud = JGProgressHUD(style: .dark)
        hud?.textLabel.text = text
        hud?.show(in: self.view)
    }
    
    func dismissProgressDialog(completionBlock: @escaping () ->()) {
        hud?.dismiss()
        completionBlock()
        
    }
   
      
}

