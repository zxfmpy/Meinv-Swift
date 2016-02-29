//
//  PictureHomeImageCell.swift
//  Meinv-Swift
//
//  Created by Lorwy on 16/2/25.
//  Copyright © 2016年 Lorwy. All rights reserved.
//

import UIKit
import SnapKit

class PictureHomeImageCell: UICollectionViewCell {
    
    var imageView = UIImageView()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        weak var weakSelf:PictureHomeImageCell? = self
        addSubview(imageView)
        imageView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(weakSelf!).inset(UIEdgeInsetsMake(0, 0, 0, 0));
        }
        imageView.contentMode = .ScaleAspectFit
    }
}
