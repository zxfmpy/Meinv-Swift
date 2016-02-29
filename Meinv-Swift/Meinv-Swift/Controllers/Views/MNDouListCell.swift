//
//  MNDouListCell.swift
//  Meinv-Swift
//
//  Created by Lorwy on 16/2/29.
//  Copyright © 2016年 Lorwy. All rights reserved.
//

import UIKit
import SDWebImage


/// 精品豆列列表的cell
class MNDouListCell: UITableViewCell {

    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    
    var modelItem:MNDouListItem! {
        didSet {
            let imageUrl = NSURL(string: modelItem.merged_cover_url!)
            self.coverImageView.sd_setImageWithURL(imageUrl)
            self.titleLabel.text = modelItem?.title
            let followerCount = modelItem?.followers_count!
            self.followersLabel.text = "已有\(followerCount)人关注"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
}
