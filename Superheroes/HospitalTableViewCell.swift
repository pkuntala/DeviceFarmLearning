//
//  HospitalTableViewCell.swift
//  Superheroes
//
//  Created by Astha Singh on 14/12/21.
//

import UIKit

class HospitalTableViewCell: UITableViewCell {

    @IBOutlet weak var hospitalImage : UIImageView!
    @IBOutlet weak var hospitalName : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
