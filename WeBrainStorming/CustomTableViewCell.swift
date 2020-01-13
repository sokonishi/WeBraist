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
    func dispAlert(_ Id:String,reportBtnTag:Int)
}


class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var boardView: UIView!
    @IBOutlet weak var imageOfDiscussion: UIImageView!
//    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var themeLabel: UILabel!
    @IBOutlet weak var detailLabel: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var keyMark: UIButton!
    @IBOutlet weak var themeImageLabel: UILabel!

    @IBOutlet weak var reportBtn: UIButton!
    
    var indexPath = IndexPath()
    var boardIdCell : String!
    
//    var delegate:HomeViewController?
    var delegate:CellButtonDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        boardView.layer.cornerRadius = 10
        boardView.layer.masksToBounds = true
        
        themeImageLabel.center = imageOfDiscussion.center
        
        detailLabel.isEditable = false
    }

    @IBAction func alertBtn(_ sender: UIButton) {
        print(self.boardIdCell)
        print(reportBtn.tag)
        delegate?.dispAlert(self.boardIdCell,reportBtnTag: reportBtn.tag)
    }
    
    
    @IBAction func settingBtn(_ sender: UIButton) {
        print("memo0",self.boardIdCell)
        delegate?.goNext(self.boardIdCell)
//        delegate?.performSegue(withIdentifier: "toEditBoard", sender: boardId)

        //print(indexPath.row)
    }

    func setCell(boardImageCode:String,discussionBackgroundImage:String,themeList:String,detailList:String,dateList:String, boardId:String,lockList:Int){
        
        if boardImageCode != "" {
            imageOfDiscussion.image = self.convertStringToUiImage(stringImageData: boardImageCode)
            imageOfDiscussion.translatesAutoresizingMaskIntoConstraints = false
        } else {
            print("else働いてる")
            imageOfDiscussion.image = UIImage(named: discussionBackgroundImage)
        }
        
        themeLabel.text = themeList
        detailLabel.text = detailList
        dateLabel.text = dateList
        boardIdCell = boardId
        
        if lockList == 1 {
            keyMark.isHidden = true
        }
    }
    
    func convertStringToUiImage(stringImageData: String) -> UIImage! {
        //BASE64の文字列をデコードしてNSDataを生成
        let decodeBase64:NSData? =
            NSData(base64Encoded:stringImageData, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
        //NSDataの生成が成功していたら
        if let decodeSuccess = decodeBase64 {
            //NSDataからUIImageを生成
            let img = UIImage(data: decodeSuccess as Data)
            return img
        }
        return nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
