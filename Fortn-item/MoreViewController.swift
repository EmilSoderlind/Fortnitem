//
//  MoreViewController.swift
//  Fortn-item
//
//  Created by Emil Söderlind on 2018-05-29.
//  Copyright © 2018 ENOS Pr. All rights reserved.
//

import UIKit
import Crashlytics

class MoreViewController: UIViewController {

    @IBOutlet weak var descrText: UITextView!
    @IBOutlet weak var headerImg: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descrText.isScrollEnabled = false
    }
    
    override func viewDidAppear(_ animated: Bool) {

            descrText.isScrollEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
