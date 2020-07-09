//
//  AllCollectionViewCell.swift
//  LazyLoadingDemo
//
//  Created by Hardik Pithadia on 09/07/20.
//  Copyright © 2020 Hardik Pithadia. All rights reserved.
//

import UIKit

class AllCollectionViewCell: UICollectionViewCell
{
    @IBOutlet weak var viewObj: UIView!

    @IBOutlet weak var imageViewObj: UIImageView!
    @IBOutlet weak var downloadImgView: UIImageView!
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblSize: UILabel!
    
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

}
