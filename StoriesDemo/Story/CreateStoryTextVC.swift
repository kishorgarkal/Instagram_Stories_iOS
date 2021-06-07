//
//  CreateStoryTextVC.swift
//  Kishor
//
//  Created by Macbook Pro on 03/11/2019.
//  Copyright © MygenomeBox. All rights reserved.
//

import UIKit

class CreateStoryTextVC: BaseVC {
    
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var contentTxtView: UITextView!
    @IBOutlet weak var messageContainerVIew: UIView!
    @IBOutlet weak var textColorBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var captionTxtView: UITextView!
    
    @IBOutlet weak var fontTextCollectionView: UICollectionView!
    @IBOutlet weak var contextTxtViewBGColorCollectionView: UICollectionView!
    
    let placeholder = NSLocalizedString("Type Something", comment: "")
    
    
    let font = [
        UIFont(name: "BoutrosMBCDinkum-Medium", size: 22),
        UIFont(name: "Bryndan-Write", size: 22),
        UIFont(name: "Hacen Sudan", size: 22),
        UIFont(name: "Harmattan-Regular", size: 22),
        UIFont(name: "ionicons", size: 22),
        UIFont(name: "Norican-Regular", size: 22),
        UIFont(name: "Oswald-Heavy", size: 22),
        UIFont(name: "Roboto-Medium", size: 22)
    ]
    
    let gradientColorBG = [
        [UIColor.hexStringToUIColor(hex: "#ef5350"),UIColor.hexStringToUIColor(hex: "#b71c1c")],
        [UIColor.hexStringToUIColor(hex: "#EC407A"),UIColor.hexStringToUIColor(hex: "#880E4F")],
        [UIColor.hexStringToUIColor(hex: "#AB47BC"),UIColor.hexStringToUIColor(hex: "#4A148C")],
        [UIColor.hexStringToUIColor(hex: "#5C6BC0"),UIColor.hexStringToUIColor(hex: "#1A237E")],
        [UIColor.hexStringToUIColor(hex: "#29B6F6"),UIColor.hexStringToUIColor(hex: "#01579B")],
        [UIColor.hexStringToUIColor(hex: "#26A69A"),UIColor.hexStringToUIColor(hex: "#004D40")],
        [UIColor.hexStringToUIColor(hex: "#9CCC65"),UIColor.hexStringToUIColor(hex: "#33691E")],
        [UIColor.hexStringToUIColor(hex: "#FFEE58"),UIColor.hexStringToUIColor(hex: "#F57F17")],
        [UIColor.hexStringToUIColor(hex: "#FF7043"),UIColor.hexStringToUIColor(hex: "#BF360C")],
        [UIColor.hexStringToUIColor(hex: "#BDBDBD"),UIColor.hexStringToUIColor(hex: "#424242")],
        [UIColor.hexStringToUIColor(hex: "#78909C"),UIColor.hexStringToUIColor(hex: "#263238")],
        [UIColor.hexStringToUIColor(hex: "#6ec052"),UIColor.hexStringToUIColor(hex: "#28c4f3")],
        [UIColor.hexStringToUIColor(hex: "#fcca5b"),UIColor.hexStringToUIColor(hex: "#ed4955")],
        [UIColor.hexStringToUIColor(hex: "#3033c6"),UIColor.hexStringToUIColor(hex: "#fb0049")]
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
 
    @IBAction func savePressed(_ sender: Any) {
      // // self.createStory()
    }
    
    @IBAction func closePressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func setupUI(){
        self.title = NSLocalizedString("Add Story", comment: "Add Story")

        self.navigationController?.isNavigationBarHidden = true
        self.fontTextCollectionView.dataSource = self
        self.fontTextCollectionView.delegate = self
        
        self.contextTxtViewBGColorCollectionView.dataSource = self
        self.contextTxtViewBGColorCollectionView.delegate = self
        
        self.contextTxtViewBGColorCollectionView.register(UINib(nibName: "PPColorItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PPColorItemCollectionViewCellID")
        self.fontTextCollectionView.register(UINib(nibName: "PPFontItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PPFontItemCollectionViewCellID")
        
        self.messageContainerVIew.applyGradient(colours: [self.gradientColorBG[0][0],self.gradientColorBG[0][1]], start:  CGPoint(x: 0.0, y: 1.0), end: CGPoint(x: 1.0, y: 1.0))
        self.contentTxtView.font = self.font[0]
        
        self.contentTxtView.text = self.placeholder
        self.contentTxtView.textColor = UIColor.white
        
        self.contentTxtView.delegate = self
        
        self.captionTxtView.layer.cornerRadius = 10
        self.captionTxtView.layer.borderColor = UIColor.lightGray.cgColor
        self.captionTxtView.layer.borderWidth = 1.0
    }

   
    
}
extension CreateStoryTextVC  : UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == self.placeholder{
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = self.placeholder
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text == self.placeholder{
            textView.text = ""
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        
        if updatedText.isEmpty {
            textView.text = self.placeholder
        } else {
            return true
        }
        
        return false
    }
}

extension CreateStoryTextVC : UICollectionViewDataSource , UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.fontTextCollectionView {
            return self.font.count
        }
        return self.gradientColorBG.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.fontTextCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PPFontItemCollectionViewCellID", for: indexPath) as! PPFontItemCollectionViewCell
            cell.titleLbl.font = self.font[indexPath.row]
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PPColorItemCollectionViewCellID", for: indexPath) as! PPColorItemCollectionViewCell
        cell.bgView.applyGradient(colours: [self.gradientColorBG[indexPath.row][0],self.gradientColorBG[indexPath.row][1]], start: CGPoint(x: 0.0, y: 1.0), end: CGPoint(x: 1.0, y: 1.0))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == self.contextTxtViewBGColorCollectionView {
            (cell as! PPColorItemCollectionViewCell).bgView.applyGradient(colours: [self.gradientColorBG[indexPath.row][0],self.gradientColorBG[indexPath.row][1]], start: CGPoint(x: 0.0, y: 1.0), end: CGPoint(x: 1.0, y: 1.0))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.contextTxtViewBGColorCollectionView {
            self.messageContainerVIew.applyGradient(colours: [self.gradientColorBG[indexPath.row][0],self.gradientColorBG[indexPath.row][1]], start: CGPoint(x: 0.0, y: 1.0), end: CGPoint(x: 1.0, y: 1.0))
        }else{
            self.contentTxtView.font = self.font[indexPath.row]
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == self.fontTextCollectionView {
            return CGSize(width: 100 , height: collectionView.frame.size.height)
        }
        return CGSize(width: 100 , height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
}
