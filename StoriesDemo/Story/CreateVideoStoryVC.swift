//
//  CreateVideoStoryVC.swift
//  Kishor
//
//  Created by Macbook Pro on 03/11/2019.
//  Copyright © MygenomeBox. All rights reserved.
//


import UIKit
import MMPlayerView
import AVFoundation
import SDWebImage


class CreateVideoStoryVC: BaseVC {
    
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var captionTxtView: UITextView!
    @IBOutlet weak var contentImgView: UIImageView!
    
    
    var videoLinkString:String? = ""
    private var aspectConstraint: NSLayoutConstraint?
    
    
    lazy var mmPlayerLayer: MMPlayerLayer = {
        let l = MMPlayerLayer()
        l.cacheType = .memory(count: 200)
        l.coverFitType = .fitToPlayerView
        l.videoGravity = AVLayerVideoGravity.resizeAspect
        return l
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()

    }
  
    
    @IBAction func sendPressed(_ sender: Any) {
      //  self.createStory()
    }
    
    func setupUI(){
        self.title = NSLocalizedString("Add Story", comment: "Add Story")

        self.mmPlayerLayer.playView = self.contentImgView
       // mmPlayerLayer.replace(cover:  CoverView.instantiateFromNib())
        mmPlayerLayer.showCover(isShow: true)
        
        self.mmPlayerLayer.set(url: URL(string:(videoLinkString!)))
        self.mmPlayerLayer.resume()
        
        mmPlayerLayer.getStatusBlock { [weak self] (status) in
            switch status {
            case .failed( _):
                print("Failed")
            case .ready:
                print("Ready to Play")
            case .playing:
                print("Playing")
            case .pause:
                print("Pause")
            case .end:
                print("End")
            default: break
            }
        }
    }
    
      
    
    
}
