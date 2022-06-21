//
//  FriendTableViewCell.swift
//  KOKO_Friends
//
//  Created by EmmaRuan on 2022/6/20.
//

import UIKit

class FriendTableViewCell: UITableViewCell {

    @IBOutlet weak var cellProfileImg: UIImageView!
    @IBOutlet weak var cellName: UILabel!
    @IBOutlet weak var TopStar: UIImageView!
    @IBOutlet weak var btnTransfer: UIButton!
    @IBOutlet weak var btnInvited: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
