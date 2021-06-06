//
//  HomeVC.swift
//  Kishor
//
//  Created by Macbook Pro on 21/10/2019.
//  Copyright © MygenomeBox. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import Async
class HomeVC: BaseVC {
    
    @IBOutlet weak var contentTblView: UITableView!
    
    private var storiesArray : [[String:String]] = [[:]]
    private var homePostarray = [[String:String]]()
    
    var contentIndexPath : IndexPath?
    var shouldRefreshStories = false
    var isVideo = false
    private var refreshControl = UIRefreshControl()
    
    var pageNo:Int=1
    var limit:Int=20
    var offset:Int=0 //pageNo*limit
    var isDataLoading:Bool=false
    var selectedImgArray = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.limit = 30
        self.offset = 0
        self.storiesArray = [["image":"https://homepages.cae.wisc.edu/~ece533/images/airplane.png","name":"Adam"],["image":"https://homepages.cae.wisc.edu/~ece533/images/arctichare.png","name":"Kishor"],["image":"https://homepages.cae.wisc.edu/~ece533/images/baboon.png","name":"Nil"],["image":"https://homepages.cae.wisc.edu/~ece533/images/barbara.png","name":"Nitin"],["image":"https://homepages.cae.wisc.edu/~ece533/images/boat.png","name":"Mukesh"],["image":"https://homepages.cae.wisc.edu/~ece533/images/cat.png","name":"Saina"],["image":"https://homepages.cae.wisc.edu/~ece533/images/fruits.png","name":"Nisha"],["image":"https://homepages.cae.wisc.edu/~ece533/images/frymire.png","name":"Mike"],["image":"https://homepages.cae.wisc.edu/~ece533/images/girl.png","name":"Hussey"]]
        //self.showProgressDialog(text: NSLocalizedString("Loading...", comment: "Loading..."))
        self.setupUI()
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.isNavigationBarHidden = false
       // self.contentTblView.reloadData()
    }
    
   
    func setupUI(){
        self.navigationItem.title = NSLocalizedString("App Name", comment: "")
        self.contentTblView.estimatedRowHeight = 400
        

        self.contentTblView.register(UINib(nibName: "PPCollectionViewItemTableViewCell", bundle: nil), forCellReuseIdentifier: "PPCollectionViewItemTableViewCellID")
    
        self.navigationController?.mmPlayerTransition.push.pass(setting: { (_) in
            
        })
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        contentTblView.addSubview(refreshControl)
        
             
    }
    @objc func refresh(sender:AnyObject) {
        self.limit = 30
        self.offset = 0
        self.storiesArray.removeAll()
      
        self.contentTblView.reloadData()
      
        refreshControl.endRefreshing()
        
    }
  
    func showAddStory(cell:UICollectionViewCell){
        ActionSheetStringPicker.show(withTitle: NSLocalizedString("Add Story", comment: ""),
                                     rows: [NSLocalizedString("Text", comment: ""),NSLocalizedString("Image", comment: ""),NSLocalizedString("Video", comment: ""),NSLocalizedString("Camera", comment: "")],
                                     initialSelection: 0,
                                     doneBlock: { (picker, value, index) in
                                        
                                        if value == 0 {
                                            self.shouldRefreshStories = true
                                            self.isVideo = false
                                            let vc = UIStoryboard.init(name: "Story", bundle: Bundle.main).instantiateViewController(withIdentifier: "PPStoryTextColorViewControllerID") as? PPStoryTextColorViewController
                                            
                                            self.navigationController?.pushViewController(vc!, animated: true)
                                            

                                            
                                            
                                        }else if value == 1 {
                                            self.isVideo = false
                                            let imagePickerController = UIImagePickerController()
                                            imagePickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
                                            imagePickerController.mediaTypes = ["public.image"]
                                            imagePickerController.delegate = self
                                            self.present(imagePickerController, animated: true, completion: nil)
                                        }else if value == 2 {
                                            self.isVideo = true
                                            let imagePickerController = UIImagePickerController()
                                            imagePickerController.sourceType = .photoLibrary
                                            imagePickerController.mediaTypes = ["public.movie"]
                                            imagePickerController.delegate = self
                                            self.present(imagePickerController, animated: true, completion: nil)
                                        }else{
                                            if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
                                                self.isVideo = false
                                                let imagePickerController = UIImagePickerController()
                                                imagePickerController.sourceType = UIImagePickerController.SourceType.camera
                                                imagePickerController.allowsEditing = false
                                                imagePickerController.delegate = self
                                                self.present(imagePickerController, animated: true, completion: nil)
                                            }else{
                                                let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
                                                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                                self.present(alert, animated: true, completion: nil)
                                            }
                                        }
                                        
                                        return
        }, cancel:  { ActionStringCancelBlock in return }, origin: cell)
    }
}
extension HomeVC : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else {
            return (self.storiesArray.count)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PPYourStoryItemCollectionViewCellID", for: indexPath) as! PPYourStoryItemCollectionViewCell
            
            let url = URL.init(string: storiesArray[indexPath.row]["image"] ?? "")
            cell.profileImageVIew.sd_setImage(with: url , placeholderImage:UIImage(named: ""))
            
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PPStoryItemCollectionViewCellID", for: indexPath) as! PPStoryItemCollectionViewCell
           // let object = self.storiesArray
            
            cell.profileNameLbl.text = storiesArray[indexPath.row]["name"] ?? ""
            let url = URL.init(string: storiesArray[indexPath.row]["image"] ?? "")
            cell.profileImg.sd_setImage(with: url , placeholderImage:UIImage(named: ""))
            for i in 0...selectedImgArray.count{
                
                if i == indexPath.row {
                    
            cell.profileImgView.isCircular()
                    cell.profileImgView.isCircular(borderColor: UIColor.lightGray)
            cell.profileImg.isCircular(borderColor: UIColor.lightGray)
            }else{
                cell.profileImgView.isCircular()
                cell.profileImgView.applyGradient(colours: [UIColor.startColor,UIColor.mainColor,UIColor.startColor], start: CGPoint(x: 0.0, y: 1.0), end: CGPoint(x: 1.0, y: 1.0), borderColor: UIColor.clear)
                cell.profileImg.isCircular(borderColor: UIColor.clear)
            }
            }
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section != 0 {
            self.shouldRefreshStories = true
            PPStoriesItemsViewControllerVC = UIStoryboard(name: "Story", bundle: nil).instantiateViewController(withIdentifier: "StoriesItemVC") as! StoriesItemVC
            let vc = PPStoriesItemsViewControllerVC
            vc.refreshStories = {
                //                self.viewModel?.refreshStories.accept(true)
            }
            vc.modalPresentationStyle = .overFullScreen
            vc.pages = (self.storiesArray[indexPath.row])
            vc.currentIndex = indexPath.row
            self.selectedImgArray.append(indexPath.row)
            self.present(vc, animated: true, completion: nil)
        }else{
            guard let cell = collectionView.cellForItem(at: indexPath) else {
                return
            }
            
            self.showAddStory(cell: cell)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80 , height: 80)
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
extension HomeVC : UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true) {
            if self.isVideo {
                let vidURL = info[UIImagePickerController.InfoKey.mediaURL] as! URL
                
                let vc = UIStoryboard.init(name: "Story", bundle: Bundle.main).instantiateViewController(withIdentifier: "CreateVideoStoryVC") as? CreateVideoStoryVC
                vc?.videoLinkString  = vidURL.absoluteString
                self.navigationController?.pushViewController(vc!, animated: true)
                
            }else{
                
                let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
                let vc = UIStoryboard.init(name: "Story", bundle: Bundle.main).instantiateViewController(withIdentifier: "CreateImageStoryVC") as? CreateImageStoryVC
                vc?.iamge = img
                vc?.isVideo = self.isVideo
                self.navigationController?.pushViewController(vc!, animated: true)
                
            }
            
        }
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

extension HomeVC : UITableViewDataSource, UITableViewDelegate{
   
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.contentIndexPath = indexPath
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PPCollectionViewItemTableViewCellID") as! PPCollectionViewItemTableViewCell
            cell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
            cell.contentCollectionView.reloadData()
            self.contentTblView.rowHeight = 100.0
            return cell
        }
        return UITableViewCell.init()
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    
}
extension HomeVC{
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        print("scrollViewWillBeginDragging")
        isDataLoading = false
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("scrollViewDidEndDecelerating")
    }
    //Pagination
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        print("scrollViewDidEndDragging")
        if ((contentTblView.contentOffset.y + contentTblView.frame.size.height) >= contentTblView.contentSize.height)
        {
            if !isDataLoading{
               // self.showProgressDialog(text: "loading..")
                isDataLoading = true
                self.pageNo=self.pageNo+1
                self.limit=self.limit+10
                self.offset=self.offset + 1
    
            }
        }
    }
}
