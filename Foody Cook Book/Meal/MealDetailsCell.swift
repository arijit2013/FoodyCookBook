//
//  MealDetailsCell.swift
//  Foody Cook Book
//
//  Created by Arijit Das on 18/02/21.
//

import UIKit

protocol MealDetailsDelegate {
    func saveMeal(index: Int)
}

class MealDetailsCell: UITableViewCell {
    
    @IBOutlet var imgMeal: UIImageView!
    @IBOutlet var titleMeal: UILabel!
    @IBOutlet var descriptionMeal: UILabel!
    @IBOutlet var favBtn: UIButton!
    
    var delegate: MealDetailsDelegate!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func favBtnAction(_ sender: UIButton) {
        self.delegate.saveMeal(index: sender.tag)
    }
}
