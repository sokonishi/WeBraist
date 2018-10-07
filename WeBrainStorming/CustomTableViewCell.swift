//
//  CustomTableViewCell.swift
//  WeBrainStorming
//
//  Created by 小西壮 on 2018/10/06.
//  Copyright © 2018年 小西壮. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageOfDiscussion: UIImageView!
    @IBOutlet weak var themeLabel: UILabel!
    @IBOutlet weak var detailLabel: UITextView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
