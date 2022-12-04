//
//  about.swift
//  Smile
//
//  Created by Rishul Dodhia on 11/1/20.
//  Copyright © 2020 Rishul Dodhia. All rights reserved.
//

import Foundation
import UIKit

class about: UIViewController {
    @IBOutlet weak var topFeature: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topFeature.backgroundColor = UIColor(named: "blueBackground")
        // Do any additional setup after loading the view.
    }
}
