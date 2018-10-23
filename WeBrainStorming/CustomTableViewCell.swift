//
//  CustomTableViewCell.swift
//  WeBrainStorming
//
//  Created by 小西壮 on 2018/10/06.
//  Copyright © 2018年 小西壮. All rights reserved.
//

import UIKit
protocol CellButtonDelegate {
    func goNext(_ Id:String)
}


class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var boardView: UIView!
    @IBOutlet weak var imageOfDiscussion: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var themeLabel: UILabel!
    @IBOutlet weak var detailLabel: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var keyMark: UIButton!
    @IBOutlet weak var themeImageLabel: UILabel!
    
    var indexPath = IndexPath()
    var boardId: String!
    
//    var delegate:HomeViewController?
    var delegate:CellButtonDelegate!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        boardView.layer.cornerRadius = 10
        boardView.layer.masksToBounds = true
        
        themeImageLabel.center = imageOfDiscussion.center
        
        detailLabel.isEditable = false
    }

    @IBAction func settingBtn(_ sender: UIButton) {
        print("memo0",self.boardId)
        delegate?.goNext(boardId)
//        delegate?.performSegue(withIdentifier: "toEditBoard", sender: boardId)

        //print(indexPath.row)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
