//
//  ExtensionsConstant.swift
//  StoriesDemo
//
//  Created by MYGENOMEBOX INDIA on 05/06/21.
//

import Foundation
import UIKit

extension UIColor {
    
    static func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

extension UIView {
    
    static func makeScreenshot(view:UIView) -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: view.bounds)
        return renderer.image { (context) in
            view.layer.render(in: context.cgContext)
        }
    }
    
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offSet
        self.layer.shadowRadius = radius
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func isRoundedRect(cornerRadius : CGFloat,hasBorderColor : UIColor?){
         self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        
        if hasBorderColor != nil {
            self.layer.borderWidth = 1
            self.layer.borderColor = hasBorderColor!.cgColor
        }
    }
    
    func addShadow(){
        self.clipsToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 3
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 5
    }
    
    func applyGradient(colours: [UIColor], start: CGPoint?, end: CGPoint?,borderColor:UIColor) -> Void {
        
        var gradient: CAGradientLayer!
        
        gradient = CAGradientLayer()
        
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.startPoint = start!
        gradient.endPoint = end!
        gradient.cornerRadius = 10
        gradient.borderColor = borderColor.cgColor
        gradient.borderWidth = 1
        if let topLayer = self.layer.sublayers?.first, topLayer is CAGradientLayer
        {
            topLayer.removeFromSuperlayer()
        }
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func applyGradient(colours: [UIColor], start: CGPoint?, end: CGPoint?) -> Void {
        
        var gradient: CAGradientLayer!
        
        gradient = CAGradientLayer()
        
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.startPoint = start!
        gradient.endPoint = end!
        if let topLayer = self.layer.sublayers?.first, topLayer is CAGradientLayer
        {
            topLayer.removeFromSuperlayer()
        }
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func roundedRect(cornerRadius : CGFloat,borderColor : UIColor){
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = 1
        self.layer.borderColor = borderColor.cgColor
        self.clipsToBounds = true
    }
    
    func isRoundedRect(cornerRadius : CGFloat){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: [.topLeft , .topRight, .bottomLeft, .bottomRight],
                                     cornerRadii: CGSize(width:cornerRadius, height: cornerRadius))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
    
    func isCircular(){
        self.layer.cornerRadius = self.frame.size.width / 2
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.clear.cgColor
        self.clipsToBounds = true
        self.layer.masksToBounds = true
    }
    
    func isCircular(borderColor : UIColor){
        self.layer.cornerRadius = self.bounds.width / 2
        self.layer.borderWidth = 1
        self.layer.borderColor = borderColor.cgColor
        self.clipsToBounds = true
    }
}
extension FileManager{
    
   
    static func deleteFile(_ filePath:URL) {
        guard FileManager.default.fileExists(atPath: filePath.path) else{
            return
        }
        do {
            try FileManager.default.removeItem(atPath: filePath.path)
            print("Remove image success!!")
        }catch{
            fatalError("Unable to delete file: \(error) : \(#function).")
        }
    }
    
//    func saveImageStory(image:UIImage)->Observable<String>{
//        return Observable.create { observer in
//            let documentDirectory: NSString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as NSString
//
//            // Set static name, so everytime image is cloned, it will be named "temp", thus rewrite the last "temp" image.
//            // *Don't worry it won't be shown in Photos app.
//            let imageName = "story.jpg"
//
//
//            let imagePath = documentDirectory.appendingPathComponent(imageName)
//
//            print("File Exist : \(self.fileExists(atPath: imagePath))")
//            print(imagePath)
//
//            if self.fileExists(atPath: imagePath) {
//                do{
//                    try self.removeItem(atPath: imagePath)
//                    print("File removed")
//                }catch{
//                    observer.on(.next("File does't exist"))
//                }
//            }
//
//            // Encode this image into JPEG. *You can add conditional based on filetype, to encode into JPEG or PNG
//            if let data = image.jpegData(compressionQuality: 0.6) {
//                // Save cloned image into document directory
//                do {
//                    try data.write(to: URL(fileURLWithPath: imagePath), options: Data.WritingOptions.atomic)
//                    print("Save image successfully.")
//                    observer.on(.next(imagePath))
//                }catch{
//                    observer.on(.next("Save image failed."))
//                }
//            }
//            return Disposables.create {
//
//            }
//        }
//    }
//
//    func saveImageObs(image:UIImage)->Observable<String>{
//        return Observable.create { observer in
//            let documentDirectory: NSString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as NSString
//
//            // Set static name, so everytime image is cloned, it will be named "temp", thus rewrite the last "temp" image.
//            // *Don't worry it won't be shown in Photos app.
//            let imageName = "profileTemp.jpg"
//
//
//            let imagePath = documentDirectory.appendingPathComponent(imageName)
//
//            print("File Exist : \(self.fileExists(atPath: imagePath))")
//            print(imagePath)
//
//            if self.fileExists(atPath: imagePath) {
//                do{
//                    try self.removeItem(atPath: imagePath)
//                    print("File removed")
//                }catch{
//                    observer.on(.next("File does't exist"))
//                }
//            }
//
//            // Encode this image into JPEG. *You can add conditional based on filetype, to encode into JPEG or PNG
//            if let data = image.jpegData(compressionQuality: 0.6) {
//                // Save cloned image into document directory
//                do {
//                    try data.write(to: URL(fileURLWithPath: imagePath), options: Data.WritingOptions.atomic)
//                    print("Save image successfully.")
//                    observer.on(.next(imagePath))
//                }catch{
//                    observer.on(.next("Save image failed."))
//                }
//            }
//            return Disposables.create {
//
//            }
//        }
//    }
    
    func savePostImage(image:UIImage)->String {
        let documentDirectory: NSString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as NSString
        
        // Set static name, so everytime image is cloned, it will be named "temp", thus rewrite the last "temp" image.
        // *Don't worry it won't be shown in Photos app.
        let imageName = String.randomStringWithLength(length: 10) + ".jpg"
        
        let imagePath = documentDirectory.appendingPathComponent(imageName)
        
        print("File Exist : \(self.fileExists(atPath: imagePath))")
        print(imagePath)
        
//        if self.fileExists(atPath: imagePath) {
//            try! self.removeItem(atPath: imagePath)
//            print("File removed")
//        }
        
        // Encode this image into JPEG. *You can add conditional based on filetype, to encode into JPEG or PNG
        if let data = image.jpegData(compressionQuality: 0.6) {
            // Save cloned image into document directory
            try? data.write(to: URL(fileURLWithPath: imagePath), options: Data.WritingOptions.atomic)
            print("Save image successfully.")
        }
        
        return imagePath
    }
    
    func saveThumbNailImage(image:UIImage)->String{
        
        let documentDirectory: NSString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as NSString
        
        // Set static name, so everytime image is cloned, it will be named "temp", thus rewrite the last "temp" image.
        // *Don't worry it won't be shown in Photos app.
        let imageName = "thumbNail.jpg"
        
        let imagePath = documentDirectory.appendingPathComponent(imageName)
        
        print("File Exist : \(self.fileExists(atPath: imagePath))")
        print(imagePath)
        
        if self.fileExists(atPath: imagePath) {
            try? self.removeItem(atPath: imagePath)
            print("File removed")
        }
        
        // Encode this image into JPEG. *You can add conditional based on filetype, to encode into JPEG or PNG
        if let data = image.jpegData(compressionQuality: 0.6) {
            // Save cloned image into document directory
            try? data.write(to: URL(fileURLWithPath: imagePath), options: Data.WritingOptions.atomic)
            print("Save image successfully.")
        }
        
        return imagePath
    }
    
    func saveImage(image:UIImage)->String{
        
        let documentDirectory: NSString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as NSString
        
        // Set static name, so everytime image is cloned, it will be named "temp", thus rewrite the last "temp" image.
        // *Don't worry it won't be shown in Photos app.
        let imageName = "profileTemp.jpg"
        
        let imagePath = documentDirectory.appendingPathComponent(imageName)
        
        print("File Exist : \(self.fileExists(atPath: imagePath))")
        print(imagePath)
        
        if self.fileExists(atPath: imagePath) {
            try? self.removeItem(atPath: imagePath)
            print("File removed")
        }
        
        // Encode this image into JPEG. *You can add conditional based on filetype, to encode into JPEG or PNG
        if let data = image.jpegData(compressionQuality: 0.6) {
            // Save cloned image into document directory
            try? data.write(to: URL(fileURLWithPath: imagePath), options: Data.WritingOptions.atomic)
            print("Save image successfully.")
        }
        
        return imagePath
    }
    
    func saveImage(image:UIImage){
        let documentDirectory: NSString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as NSString
        
        // Set static name, so everytime image is cloned, it will be named "temp", thus rewrite the last "temp" image.
        // *Don't worry it won't be shown in Photos app.
        let imageName = "profileTemp.jpg"
        let imagePath = documentDirectory.appendingPathComponent(imageName)
        
        print("File Exist : \(self.fileExists(atPath: imagePath))")
        print(imagePath)
        
        if self.fileExists(atPath: imagePath) {
            do{
                try? self.removeItem(atPath: imagePath)
                print("File removed")
            }catch{
                print("File does't exist")
            }
        }
        
        // Encode this image into JPEG. *You can add conditional based on filetype, to encode into JPEG or PNG
        if let data = image.jpegData(compressionQuality: 0.6) {
            // Save cloned image into document directory
            do {
                try? data.write(to: URL(fileURLWithPath: imagePath), options: Data.WritingOptions.atomic)
                print("Save image successfully.")
            }catch{
                print("Save image failed.")
            }
        }
    }
}

extension String {
    
    func arrangeMentionedContacts()->String{
        var temp = ""
        
        for (index, element) in self.replacingOccurrences(of: "@@", with: "@").components(separatedBy: "@").enumerated() {
            print("Item \(index): \(element)")
            
            if index == 0 {
                temp += element
            }else {
                temp += " @\(element)"
            }
        }
        
        return temp
    }
    
    func decodeHtmlEntities()->String?{
        
        guard let data = self.data(using: .utf8) else {
            return nil
        }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return nil
        }
        
        let decodedString = attributedString.string
        return decodedString
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    
    static func randomStringWithLength (length : Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0...length-1).map{ _ in letters.randomElement()! })
    }
    
//    func processDateWithDayAndMinuteAndSecondDifference()-> String{
//        // Sample Data :  "createdAt":"2018-02-01 09:53:38.0"
//        //        print(self)
//
//        let now = Date()
//        let formatter = DateFormatter()
//        formatter.timeZone = TimeZone.current
//        formatter.dateFormat = "yyyy-MM-dd HH:mm"
//        let dateString = formatter.string(from: now)
//
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
//        print(String(dateString))
//        let convertedDate = dateFormatter.date(from: String(dateString))
//
//        if Date().years(from: convertedDate!) > 0 {
//            if Date().years(from: convertedDate!) == 1 {
//                return "\(Date().years(from: convertedDate!)) year ago"
//            }
//            return "\(Date().years(from: convertedDate!)) year ago"
//        }else if Date().months(from: convertedDate!) > 0 {
//            if Date().months(from: convertedDate!) == 1 {
//                return "\(Date().months(from: convertedDate!)) months ago"
//            }
//            return "\(Date().months(from: convertedDate!)) months ago"
//        }else if Date().weeks(from:convertedDate!) > 0 {
//            if Date().weeks(from: convertedDate!) == 1 {
//                return "\(Date().weeks(from:convertedDate!)) week ago"
//            }
//            return "\(Date().weeks(from:convertedDate!)) weeks ago"
//        }else if Date().days(from:convertedDate!) > 0 {
//            if Date().days(from:convertedDate!) == 1 {
//                return "\(Date().days(from:convertedDate!)) day ago"
//            }
//            return "\(Date().days(from:convertedDate!)) days ago"
//        }else if Date().hours(from: convertedDate!) > 0 {
//            if Date().hours(from: convertedDate!) == 1 {
//                return "\(Date().hours(from: convertedDate!)) hour ago"
//            }
//            return "\(Date().hours(from: convertedDate!)) hours ago"
//        }else if Date().minutes(from: convertedDate!) > 0 {
//            if Date().minutes(from: convertedDate!) == 1 {
//                return "\(Date().minutes(from: convertedDate!)) minute ago"
//            }
//
//            return "\(Date().minutes(from: convertedDate!)) minutes ago"
//        }
//
//
//        if Date().seconds(from: convertedDate!) > 1 {
//            return  "\(Date().seconds(from: convertedDate!)) second ago"
//        }
//
//        return  "Just now"
//    }
}

extension UIColor {
    
    @nonobjc class var mainColor: UIColor {
        return UIColor.hexStringToUIColor(hex: "#ff0000")
    }
    
    @nonobjc class var startColor: UIColor {
        return UIColor.hexStringToUIColor(hex: "#f65599")
    }
    
    @nonobjc class var endColor: UIColor {
        return UIColor.hexStringToUIColor(hex: "#4d0316")
    }
}
