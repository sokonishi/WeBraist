//
//  IdeaTableViewCell.swift
//  WeBrainStorming
//
//  Created by 小西壮 on 2018/10/18.
//  Copyright © 2018年 小西壮. All rights reserved.
//

import UIKit

class IdeaTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ideaThemelabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
