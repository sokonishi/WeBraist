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
    
    @IBOutlet weak var imageOfDiscussion: UIImageView!
    @IBOutlet weak var themeLabel: UILabel!
    @IBOutlet weak var detailLabel: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    
    var indexPath = IndexPath()
    var boardId: String!
    
//    var delegate:HomeViewController?
    var delegate:CellButtonDelegate!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func settingBtn(_ sender: UIButton) {
        print("memo0",self.boardId)
        delegate?.goNext(boardId)
//        delegate?.performSegue(withIdentifier: "toEditBoard", sender: boardId)

        //print(indexPath.row)
    }
    
    
//    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "toEditBoard" {
//            let addVC2 = segue.destination as! EditBoardViewController
//            addVC2.boardID = sender as! String
//        }
//    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
