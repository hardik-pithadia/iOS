//
//  AllViewController.swift
//  LazyLoadingDemo
//
//  Created by Hardik Pithadia on 09/07/20.
//  Copyright © 2020 Hardik Pithadia. All rights reserved.
//

import UIKit
import SDWebImage

class AllViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
    var responseArray : NSMutableArray?
    
    @IBOutlet weak var scrollViewObj: UIScrollView!
    
    @IBOutlet weak var collectionViewObj: UICollectionView!
    
    @IBOutlet weak var leftImgView: UIImageView!
    @IBOutlet weak var rightImgView: UIImageView!
    
    var refOffsetButton : UIButton?
    
    var parentNavigationController : UINavigationController?
    
    var activity : UIActivityIndicatorView?
    
    //MARK: - init
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.collectionViewObj.dataSource = self
        self.collectionViewObj.delegate = self
        
        let videoCellNib = UINib(nibName: "AllCollectionViewCell", bundle: nil)
        self.collectionViewObj.register(videoCellNib, forCellWithReuseIdentifier: "videoCell")

        self.leftImgView.layer.cornerRadius = 8
        self.rightImgView.layer.cornerRadius = 8
        
        var offsetCounter = 0
        var xPOS : CGFloat = 0.0
        
        for i in 0..<1000
        {
            let buttonObj = UIButton(type: .custom)
            buttonObj.frame = CGRect(x: xPOS, y: 0.0, width: 40.0, height: 40.0)
            buttonObj.tag = offsetCounter
            buttonObj.backgroundColor = .white
            buttonObj.setTitle("\(i + 1)", for: .normal)
            buttonObj.setTitleColor(UIColor.lightGray, for: .normal)
            buttonObj.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            buttonObj.layer.cornerRadius = 8.0
            buttonObj.addTarget(self, action: #selector(offsetButtonClicked(sender:)), for: .touchUpInside)
            self.scrollViewObj.addSubview(buttonObj)
            
            offsetCounter = offsetCounter + 6
            xPOS = buttonObj.frame.origin.x + buttonObj.frame.size.width + 10
            self.scrollViewObj.contentSize.width = xPOS + 50
        }
        
        activity = UIActivityIndicatorView(style: .white)
        activity?.frame = CGRect(x: (UIScreen.main.bounds.size.width/2)-60, y: (UIScreen.main.bounds.size.height/2)-40 - 130, width: 120.0, height: 80.0)
        activity?.backgroundColor = UIColor.black
        activity?.layer.cornerRadius = 20.0
        activity?.layer.opacity = 0.7
        self.view.addSubview(activity!)
        
        self.getVideoListResponse(offsetVal: 0)
    }
    
    //MARK: - Button Actions
    @objc func offsetButtonClicked(sender : UIButton)
    {
        if self.refOffsetButton != nil
        {
            self.refOffsetButton?.backgroundColor = .white
            self.refOffsetButton?.setTitleColor(UIColor.lightGray, for: .normal)
        }
        
        sender.setTitleColor(Constants.darkBlueColor, for: .normal)
        sender.backgroundColor = Constants.lightBlueColor
        
        print("Offset Tag : \(sender.tag)")
        
        self.refOffsetButton = sender
        
        self.getVideoListResponse(offsetVal: sender.tag)
    }
    
    //MARK: - CollectionView DataSource & Delegate
    public func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if self.responseArray != nil
        {
            if self.responseArray!.count > 0
            {
                return self.responseArray!.count
            }
        }
        
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let videoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "videoCell", for: indexPath) as! AllCollectionViewCell
        
        DispatchQueue.main.async {
            videoCell.viewObj.layer.cornerRadius = 10
            videoCell.imageViewObj.layer.cornerRadius = 10
        }
        
        videoCell.lblDate.text = "\((((self.responseArray?.object(at: indexPath.row) as AnyObject).value(forKey: "dateTime") as? String ?? "").split(separator: "T") as AnyObject).firstObject as? String ?? "")"
        
        videoCell.lblTime.text = "@ \((((((self.responseArray?.object(at: indexPath.row) as AnyObject).value(forKey: "dateTime") as? String ?? "").split(separator: "T") as AnyObject).object(at: 1) as? String ?? "").split(separator: ".") as AnyObject).firstObject as? String ?? "")"
        
        videoCell.lblSize.text = "\((self.responseArray?.object(at: indexPath.row) as AnyObject).value(forKey: "fileSize") as? String ?? "")"
        
        if ("\((self.responseArray?.object(at: indexPath.row) as AnyObject).value(forKey: "status") as? String ?? "")") == "STATUS_DOWNLOADED"
        {
            videoCell.downloadImgView.image = UIImage(named: "status_downloaded")
        }
        else if ("\((self.responseArray?.object(at: indexPath.row) as AnyObject).value(forKey: "status") as? String ?? "")") == "STATUS_UPLOADED"
        {
            videoCell.downloadImgView.image = UIImage(named: "status_uploaded")
        }
        else
        {
            videoCell.downloadImgView.image = UIImage(named: "status_none")
        }
        
        videoCell.imageViewObj.sd_setImage(with: (NSURL(string: "\((self.responseArray?.object(at: indexPath.row) as AnyObject).value(forKey: "thumbnail") as? String ?? "")")! as URL), placeholderImage: nil)
        
        return videoCell
    }
    
    //MARK: - CollectionView FlowLayout Delegate
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: UIScreen.main.bounds.size.width/2 - 20, height: UIScreen.main.bounds.size.width/3 + 20)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsets(top: 15.0, left: 15.0, bottom: 0.0, right: 15.0)
    }
    
    //MARK: - All Videos Response
    func getVideoListResponse(offsetVal : Int)
    {
        if Reachability.isConnectedToNetwork()
        {
            DispatchQueue.main.async {
                self.activity?.startAnimating()
            }
            
            WebRequestManager.parseJsonWebServiceGet(urlString: "\(Constants.BASE_URL)/getNormalVideoFiles?offset=\(offsetVal)&limit=6") { (status, response) in
                
                if status
                {
                    print("Response : \(response)")
                    
                    if response.count > 0
                    {
                        self.responseArray = NSMutableArray()
                        self.responseArray = (response as! NSMutableArray)
                        
                        DispatchQueue.main.async {
                            self.collectionViewObj.reloadData()
                        }
                    }
                    else
                    {
                        let alertViewController = UIAlertController(title: "Message", message: "No Records Found", preferredStyle: .alert)
                        
                        alertViewController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (alert: UIAlertAction!) in
                            
                        }))
                        
                        DispatchQueue.main.async {
                            self .present(alertViewController, animated: true, completion: nil)
                        }
                    }
                    
                    
                }
                else
                {
                    let alertViewController = UIAlertController(title: "Error", message: "Try Again!", preferredStyle: .alert)
                    
                    alertViewController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (alert: UIAlertAction!) in
                        
                    }))
                    
                    DispatchQueue.main.async {
                        self .present(alertViewController, animated: true, completion: nil)
                    }
                }
                DispatchQueue.main.async {
                    self.activity?.stopAnimating()
                }
            }
        }
        else
        {
            let alertViewController = UIAlertController(title: "No Internet", message: "Network Not Available.\nPlease Check Settings", preferredStyle: .alert)
            
            alertViewController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (alert: UIAlertAction!) in
                
            }))
            
            DispatchQueue.main.async {
                self .present(alertViewController, animated: true, completion: nil)
            }
            
        }
        
    }
}
