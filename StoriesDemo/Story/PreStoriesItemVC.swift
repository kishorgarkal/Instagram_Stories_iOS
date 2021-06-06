//
//  PreStoriesItemVC.swift
//  Kishor
//
//  Created by Macbook Pro on 06/06/2021.
//  Copyright © MygenomeBox. All rights reserved.
//


import UIKit
import AVFoundation
import SDWebImage
import IoniconsSwift
import Async
class PreStoriesItemVC: BaseVC {
    
    var pageIndex : Int = 0
    var item: [String] = []
    var items: [String:String] = [:]
    var SPB: SegmentedProgressBar!
    var player: AVPlayer!
    var refreshStories: (() -> Void)?
    
    @IBOutlet weak var trashBtn: UIButton!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var imagePreview: UIImageView!
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    
    var reset = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        self.trashBtn.setImage(Ionicons.trashA.image(50.0, color: UIColor.hexStringToUIColor(hex: "#FFFFFF")), for: UIControl.State.normal)
        
        userProfileImage.layer.cornerRadius = self.userProfileImage.frame.size.height / 2;
        
        self.userProfileImage!.sd_setImage(with: URL(string: items["image"] ?? "")) { (image, error, cacheType, url) in
            if error == nil {
                self.userProfileImage.image = image
            }
        }
        
        lblUserName.text = items["name"] ?? ""
        item = [items["image"] ?? ""]
        
        SPB = SegmentedProgressBar(numberOfSegments: item.count, duration: 5)
        if #available(iOS 11.0, *) {
            SPB.frame = CGRect(x: 18, y: UIApplication.shared.statusBarFrame.height + 5, width: view.frame.width - 35, height: 3)
        } else {
            // Fallback on earlier versions
            SPB.frame = CGRect(x: 18, y: 15, width: view.frame.width - 35, height: 3)
        }
        
        SPB.delegate = self
        SPB.topColor = UIColor.white
        SPB.bottomColor = UIColor.white.withAlphaComponent(0.25)
        SPB.padding = 2
        SPB.isPaused = true
        SPB.currentAnimationIndex = 0
        SPB.duration = getDuration(at: 0)
        view.addSubview(SPB)
        view.bringSubviewToFront(SPB)
        
        let tapGestureImage = UITapGestureRecognizer(target: self, action: #selector(tapOn(_:)))
        tapGestureImage.numberOfTapsRequired = 1
        tapGestureImage.numberOfTouchesRequired = 1
        imagePreview.addGestureRecognizer(tapGestureImage)
        
        let tapGestureVideo = UITapGestureRecognizer(target: self, action: #selector(tapOn(_:)))
        tapGestureVideo.numberOfTapsRequired = 1
        tapGestureVideo.numberOfTouchesRequired = 1
        videoView.addGestureRecognizer(tapGestureVideo)
        
   
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.animate(withDuration: 0.8) {
            self.view.transform = .identity
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.SPB.startAnimation()
            self.playVideoOrLoadImage(index: 0)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        DispatchQueue.main.async {
            self.SPB.currentAnimationIndex = 0
            self.SPB.cancel()
            self.SPB.isPaused = true
            self.resetPlayer()
        }
    }
    
    
    @IBAction func trashPressed(_ sender: Any) {
      //  self.deleteStory(storyID: self.item[self.SPB.currentAnimationIndex].id!)
    }
    @objc func tapOn(_ sender: UITapGestureRecognizer) {
        SPB.skip()
    }
    
    private func getDuration(at index: Int) -> TimeInterval {
        var retVal: TimeInterval = 5.0
       // if item[index].type == "1" {
            retVal = 5.0
//        } else {
//            guard let url = NSURL(string: item[0]) as URL? else { return retVal }
//            let asset = AVAsset(url: URL(string: url) ?? "")
//            let duration = asset.duration
//            retVal = CMTimeGetSeconds(duration)
//        }
        return retVal
    }
    
    private func resetPlayer() {
        if player != nil {
            player.pause()
            player.replaceCurrentItem(with: nil)
            player = nil
        }
    }
    
    //MARK: - Button actions
    @IBAction func close(_ sender: Any) {
        self.refreshStories!()
        self.dismiss(animated: true, completion: {
            
        })
        resetPlayer()
    }
    
    func playVideoOrLoadImage(index: Int) {
        
       // if "item[index].type" == "1" {
            self.SPB.duration = 5
            self.imagePreview.isHidden = false
            self.videoView.isHidden = true
            self.imagePreview!.sd_setImage(with: URL(string: item[index])) { (image, error, cacheType, url) in
                
            }
//        } else {
//            self.imagePreview.isHidden = true
//            self.videoView.isHidden = false
//
//            resetPlayer()
//            guard let url = NSURL(string:  item[index]) as URL? else {return}
//            self.player = AVPlayer(url: url)
//
//            let videoLayer = AVPlayerLayer(player: self.player)
//            videoLayer.frame = view.bounds
//            videoLayer.videoGravity = .resizeAspect
//            self.videoView.layer.addSublayer(videoLayer)
//
//            let asset = AVAsset(url: url)
//            let duration = asset.duration
//            let durationTime = CMTimeGetSeconds(duration)
//
//            self.SPB.duration = durationTime
//            self.player.play()
//        }
    }
    private func deleteStory(storyID:Int){
    
    }
    
}

extension PreStoriesItemVC : SegmentedProgressBarDelegate {
    
    func segmentedProgressBarChangedIndex(index: Int) {
        playVideoOrLoadImage(index: index)
    }
    
    func segmentedProgressBarFinished() {
        print("segmentedProgressBarFinished")
        print(self.pageIndex)
        print(self.items.count)
        
        if  pageIndex == (self.items.count - 1) {
            
            self.dismiss(animated: true, completion: {
                self.refreshStories!()
            })
        } else {
            PPStoriesItemsViewControllerVC.goNextPage(fowardTo: pageIndex + 1)
        }
    }
    
}
