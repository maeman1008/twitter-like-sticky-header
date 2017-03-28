//
//  ViewController.swift
//  BlurNav
//
//  Created by ryoto.maeda on 2017/03/10.
//  Copyright © 2017年 ryoto.maeda. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    private let headerStopOffset: CGFloat = 40
    private let headerLabelOffset: CGFloat = 95
    private let headerLabelDistance: CGFloat = 35
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerBlurImageView: UIVisualEffectView!
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var headerLabel: UILabel!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    func configureView() {
        headerBlurImageView.alpha = 0
        tableView.delegate = self
        avatarImageView.layer.borderWidth = 1
        avatarImageView.layer.borderColor = UIColor.white.cgColor
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(ViewController.refreshData(sender:)), for: .valueChanged)

    }
    
    func refreshData(sender: UIRefreshControl) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.refreshControl.endRefreshing()
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        var avatarTransform = CATransform3DIdentity
        var headerTransform = CATransform3DIdentity
        
        if offset < 0 {
            
            let headerScaleFactor = -(offset) / headerView.bounds.height
            let headerSizevariation = ((headerView.bounds.height * (1.0 + headerScaleFactor)) - headerView.bounds.height) / 2.0
            headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizevariation, 0)
            headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0)

            headerBlurImageView?.alpha = min (1.0, (-offset - headerLabelOffset) / headerLabelDistance)
            
            if refreshControl.isRefreshing {
                headerBlurImageView.alpha = 100
            }

        } else {
            headerTransform = CATransform3DTranslate(headerTransform, 0, max(-headerStopOffset, -offset), 0)
            
            let labelTransform = CATransform3DMakeTranslation(0, max(-headerLabelDistance, headerLabelOffset - offset), 0)
            headerLabel.layer.transform = labelTransform
            
            headerBlurImageView?.alpha = min (1.0, (offset - headerLabelOffset) / headerLabelDistance)
            
            
            let avatarScaleFactor = (min(headerStopOffset, offset)) / avatarImageView.bounds.height / 1.4
            let avatarSizeVariation = ((avatarImageView.bounds.height * (1.0 + avatarScaleFactor)) - avatarImageView.bounds.height) / 2.0
            avatarTransform = CATransform3DTranslate(avatarTransform, 0, avatarSizeVariation, 0)
            avatarTransform = CATransform3DScale(avatarTransform, 1.0 - avatarScaleFactor, 1.0 - avatarScaleFactor, 0)
            
            if offset <= headerStopOffset {
                if avatarImageView.layer.zPosition < headerView.layer.zPosition{
                    headerView.layer.zPosition = 0
                }
            } else {
                if avatarImageView.layer.zPosition >= headerView.layer.zPosition{
                    headerView.layer.zPosition = 2
                }
            }

        }
        
        headerView.layer.transform = headerTransform
        avatarImageView.layer.transform = avatarTransform
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
    }
}
