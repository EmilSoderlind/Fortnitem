//
//  ViewController.swift
//  Fortn-item
//
//  Created by Emil Söderlind on 2018-05-14.
//  Copyright © 2018 ENOS Pr. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        let ap: FNBRApiHandler = FNBRApiHandler()
        ap.theView = self
        
        
        //ap.parseCurrentItems()
        
        //testImage.downloadedFrom(link: "https://image.fnbr.co/pickaxe/5afc0fa7b6e7f77dcfa32634/gallery.jpg")
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

