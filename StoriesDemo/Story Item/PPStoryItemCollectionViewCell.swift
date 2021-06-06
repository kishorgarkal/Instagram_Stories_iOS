//
//  PPStoryItemCollectionViewCell.swift
//  Kishor
//
//  Created by DoughouzLight on 05/01/2019.
//  Copyright © 2019 DoughouzLight. All rights reserved.
//

import UIKit

class PPStoryItemCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var profileNameLbl: UILabel!
    @IBOutlet weak var profileImgView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
       // self.profileImgView.isCircular()
       // self.profileImg.isCircular()
        self.profileImgView.applyGradient(colours: [UIColor.startColor,UIColor.mainColor,UIColor.startColor], start: CGPoint(x: 0.0, y: 1.0), end: CGPoint(x: 1.0, y: 1.0), borderColor: UIColor.magenta)
        self.profileImg.isCircular(borderColor: UIColor.clear)
        //applyGradient(colours: [self.gradientColorBG[0][0],self.gradientColorBG[0][1]], start:  CGPoint(x: 0.0, y: 1.0), end: CGPoint(x: 1.0, y: 1.0))
    }
    
//    func bind(item : StoryItem,row : Int){
//        
//        self.profileNameLbl.text = item.username!
//        
//        self.profileImg.sd_setImage(with: URL(string: item.avatar!),
//                                    placeholderImage: UIImage(named: "img_profile_placeholder")) {  (image, error, cacheType, url) in
//                                        
//                                        
//                                        if error != nil {
//                                            self.profileImg.image = UIImage(named: "img_profile_placeholder")
//                                        }else{
//                                            self.profileImg.image = image!
//                                        }
//                                        
//                                        
//        }
//    }
    
}
