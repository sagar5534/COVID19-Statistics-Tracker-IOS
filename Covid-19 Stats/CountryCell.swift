//
//  CountryCell.swift
//  
//
//  Created by Sagar on 2020-03-25.
//

import UIKit

class CountryCell: UITableViewCell {

    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var TotalCases: UILabel!
    @IBOutlet weak var NewCases: UIButton!
    @IBOutlet weak var Ranking: UILabel!
    @IBOutlet weak var DeadCases: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
    
