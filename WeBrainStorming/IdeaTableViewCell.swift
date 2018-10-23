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
    @IBOutlet weak var backgroundImage: UIImageView!
    
    var boardId: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
