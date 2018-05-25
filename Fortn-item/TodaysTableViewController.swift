//
//  TodaysTableViewController.swift
//  Fortn-item
//
//  Created by Emil Söderlind on 2018-05-18.
//  Copyright © 2018 ENOS Pr. All rights reserved.
//

import UIKit

class TodaysTableViewController: UITableViewController, UITabBarControllerDelegate {
    
    var iml: ItemModelList = ItemModelList(date: Date(), featured: [], daily: [])
    var parseDone:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("TodaysTableViewController ViewDidLoad")
        
        self.tabBarController?.delegate = self
        
        let ap: FNBRApiHandler = FNBRApiHandler()
        ap.parseCurrentItems(vc: self)
        
        let fortniteFont = UIFont(name: "BurbankBigCondensed-Bold", size: 17)
        UITabBarItem.appearance().setTitleTextAttributes([kCTFontAttributeName as NSAttributedStringKey: fortniteFont!], for: .normal)
        
        print("TodaysTableViewController ViewDidLoad - DONE")
    }
    
    func doneParsing(parsedIML: ItemModelList){
        print("Done parsing - updating tableView")
        
        iml = parsedIML
        parseDone = true
        
        self.tableView.reloadData()
        print("Done parsing - updating tableView - DONE")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        if(!parseDone){
            return 2
        }else{
            return 3
        }
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let result = formatter.string(from: date)
        
        if(section == 0){
            return "Item Shop | Version: \(Bundle.main.releaseVersionNumber!)"
        }else if(section == 1 && parseDone){
            return "Featured"
        }else if(section == 2 && parseDone){
            return "Daily"
        }
        
        return "Loading..."
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if(section == 0){
            return 0
        }else if(section == 1){
            return iml.featured.count
        }else if (section == 2){
            return iml.daily.count
        }else if (section == 3){
            return 0
        }
    
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ItemTableViewCell
        
        /*if(true){
            let loadingCell = tableView.dequeueReusableCell(withIdentifier: "loadingCell", for: indexPath)
            return loadingCell
        }*/
        
        if(indexPath.section == 1){
            
            // Icon image for emote, png for other.
            if(iml.featured[indexPath.row].type == "emote"){
                cell.mainImage.image = iml.featured[indexPath.row].imgIcon
            }else{
                cell.mainImage.image = iml.featured[indexPath.row].imgPng
            }
            
            cell.title.text = iml.featured[indexPath.row].name
            cell.priceLabel.text = iml.featured[indexPath.row].price
            cell.priceImg.image = iml.featured[indexPath.row].imgPriceIconLink
            
            // Gradient background based on rarity
            cell.gradientBackgroundView.startColor = getRarityColor(rarityStr: iml.featured[indexPath.row].rarity + "0")
            cell.gradientBackgroundView.endColor = getRarityColor(rarityStr: iml.featured[indexPath.row].rarity + "1")
            
        }else if(indexPath.section == 2){
            
             // Icon image for emote, png for other.
            if(iml.daily[indexPath.row].type == "emote"){
                cell.mainImage.image = iml.daily[indexPath.row].imgIcon
            }else{
                cell.mainImage.image = iml.daily[indexPath.row].imgPng
            }
            
            cell.title.text = iml.daily[indexPath.row].name
            cell.priceLabel.text = iml.daily[indexPath.row].price
            cell.priceImg.image = iml.daily[indexPath.row].imgPriceIconLink
            
            // Gradient background based on rarity
            cell.gradientBackgroundView.startColor = getRarityColor(rarityStr: iml.daily[indexPath.row].rarity + "0")
            cell.gradientBackgroundView.endColor = getRarityColor(rarityStr: iml.daily[indexPath.row].rarity + "1")
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = UIColor.white
        header.textLabel?.font = UIFont(name: "BurbankBigCondensed-Bold", size: 25)
            //UIFont.fontNames(forFamilyName: "BurbankBigCondensed-Bold.otf")[0]
        header.textLabel?.frame = header.frame
        header.textLabel?.textAlignment = .center
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return false
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        let tabBarIndex = tabBarController.selectedIndex
                
        if tabBarIndex == 0 {
            self.tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
    }
    
    func presentErrorMessage(err: String){
        print("presentErrorMessage")
        let alert = UIAlertController(title: "Could not collect todays items", message: err, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "I'll try again later", style: .cancel, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
            }}))
        self.present(alert, animated: true, completion: nil)
        print("presentErrorMessage - DONE")
    }
    
    // Return color based on rarity, up (0) and down (1) colors for gradient
    func getRarityColor(rarityStr: String) -> UIColor{
        print("getRarityColor(\(rarityStr))")
        
        if(rarityStr == "common0"){
            return UIColor(red: 193.0/255.0, green: 194.0/255.0, blue: 194, alpha: 1)
        }else if(rarityStr == "common1"){
            return UIColor(red: 146.0/255.0, green: 148.0/255.0, blue: 149.0/255.0, alpha: 1)
        }else if(rarityStr == "uncommon0"){
            return UIColor(red: 72.0/255.0, green: 160.0/255.0, blue: 4.0/255.0, alpha: 1)
        }else if(rarityStr == "uncommon1"){
            return UIColor(red: 12.0/255.0, green: 120.0/255.0, blue: 9.0/255.0, alpha: 1)
        }else if(rarityStr == "rare0"){
            return UIColor(red: 51.0/255.0, green: 180.0/255.0, blue: 239.0/255.0, alpha: 1)
        }else if(rarityStr == "rare1"){
            return UIColor(red: 9.0/255.0, green: 105.0/255.0, blue: 176.0/255.0, alpha: 1)
        }else if(rarityStr == "epic0"){
            return UIColor(red: 191.0/255.0, green: 98.0/255.0, blue: 227.0/255.0, alpha: 1)
        }else if(rarityStr == "epic1"){
            return UIColor(red: 131.0/255.0, green: 22.0/255.0, blue: 175.0/255.0, alpha: 1)
        }else if(rarityStr == "legendary0"){
            return UIColor(red: 223.0/255.0, green: 133.0/255.0, blue: 41.0/255.0, alpha: 1)
        }else if(rarityStr == "legendary1"){
            return UIColor(red: 147.0/255.0, green: 88.0/255.0, blue: 50.0/255.0, alpha: 1)
        }
        
        return UIColor.black
    }
}
