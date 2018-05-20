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
        return 3
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let result = formatter.string(from: date)
        
        if(section == 0){
            return "Item Shop | Version: \(Bundle.main.releaseVersionNumber!)"
        }else if(section == 1){
            return "Featured"
        }else if(section == 2){
            return "Daily"
        }
        
        return "Whops, to many sections..!"
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> ItemTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ItemTableViewCell
        
        if(indexPath.section == 1){
            
            cell.mainImage.image = iml.featured[indexPath.row].imgPng
            cell.title.text = iml.featured[indexPath.row].name
            cell.priceLabel.text = iml.featured[indexPath.row].price
            cell.priceImg.image = iml.featured[indexPath.row].imgPriceIconLink
            
        }else if(indexPath.section == 2){
            
            cell.mainImage.image = iml.daily[indexPath.row].imgPng
            cell.title.text = iml.daily[indexPath.row].name
            cell.priceLabel.text = iml.daily[indexPath.row].price
            cell.priceImg.image = iml.daily[indexPath.row].imgPriceIconLink
        }
        
        
        return cell
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
        
        print(tabBarIndex)
        
        if tabBarIndex == 0 {
            self.tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
    }

}
