//
//  ItemTableViewCell.swift
//  Fortn-item
//
//  Created by Emil Söderlind on 2018-05-18.
//  Copyright © 2018 ENOS Pr. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var gradientBackgroundView: GradientView!
    @IBOutlet weak var priceImg: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var mainImage: UIImageView!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    
    
    /*
 
 @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
 let imageView = sender.view as! UIImageView
 let newImageView = UIImageView(image: imageView.image)
 newImageView.frame = UIScreen.main.bounds
 newImageView.backgroundColor = .black
 newImageView.contentMode = .scaleAspectFit
 newImageView.isUserInteractionEnabled = true
 let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
 newImageView.addGestureRecognizer(tap)
 self.view.addSubview(newImageView)
 self.navigationController?.isNavigationBarHidden = true
 self.tabBarController?.tabBar.isHidden = true
 }
 */
 @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
 
    sender.view?.removeFromSuperview()
 }
 
 

}
