//
//  HomeViewController.swift
//  LazyLoadingDemo
//
//  Created by Hardik Pithadia on 09/07/20.
//  Copyright © 2020 Hardik Pithadia. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, CAPSPageMenuDelegate
{
    var pageMenu : CAPSPageMenu?
    
    @IBOutlet weak var topHeader: UIView!
    
    //MARK: - init
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        self.setupPagerView()
    }
    
    //MARK: - Setup Pager
    func setupPagerView()
    {
        var controllerArray : [UIViewController] = []
        
        let allVC = AllViewController(nibName: "AllViewController", bundle: nil)
        allVC.parentNavigationController = self.navigationController
        allVC.title = "All"
        controllerArray.append(allVC)
        
        let emergencyVC = EmergencyViewController(nibName: "EmergencyViewController", bundle: nil)
        emergencyVC.parentNavigationController = self.navigationController
        emergencyVC.title = "Emergency"
        controllerArray.append(emergencyVC)
        
        
        let parameters: [CAPSPageMenuOption] = [
            .menuItemSeparatorWidth(4.3),
            .scrollMenuBackgroundColor(UIColor.clear),
            .viewBackgroundColor(.clear),
            .bottomMenuHairlineColor(.lightGray),
            .selectionIndicatorColor(Constants.darkBlueColor),
            .menuMargin(20.0),
            .menuHeight(40.0),
            .selectedMenuItemLabelColor(UIColor.black),
            .unselectedMenuItemLabelColor(.lightGray),
            .menuItemFont(UIFont(name: "HelveticaNeue-Medium", size: 17.0)!),
            .useMenuLikeSegmentedControl(true),
            .menuItemSeparatorRoundEdges(true),
            .selectionIndicatorHeight(2.0),
            .menuItemSeparatorPercentageHeight(0.0)
        ]
        
        // Initialize scroll menu
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x:0.0, y:130.0, width: self.view.frame.size.width, height: self.view.frame.size.height - 130.0), pageMenuOptions: parameters)
        self.view.addSubview(pageMenu!.view)
        pageMenu!.didMove(toParent: self)
    }
}
