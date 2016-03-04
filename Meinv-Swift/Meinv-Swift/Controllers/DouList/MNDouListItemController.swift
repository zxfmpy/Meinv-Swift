//
//  MNDouListItemController.swift
//  Meinv-Swift
//
//  Created by Lorwy on 16/3/1.
//  Copyright © 2016年 Lorwy. All rights reserved.
//

import UIKit

private let reuseIdentifier = "kMNDouListItemCollectionViewCellIdentifier"

/// 豆列进去的分类详情
class MNDouListItemController: MNBaseController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (view.bounds.size.width - 30)/2, height: ((view.bounds.size.width - 30)/2)/225.0*300.0)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        
        collectionView!.collectionViewLayout = layout
        
        self.collectionView!.registerClass(MNDouListItemCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 10)
    }
    
    //MARK: - collectionView Delegate
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    // 点击查看大图
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MNDouListItemCollectionViewCell
        
        return cell
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
