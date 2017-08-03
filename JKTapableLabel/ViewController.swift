//
//  ViewController.swift
//  JKTapableUILabel
//
//  Created by Jitendra Solanki on 7/31/17.
//  Copyright © 2017 jitendra. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var linkLabel: JKTapableLabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        linkLabel.inputText = "https://google.com This is a test with the URL https://www.github.com to be detected."
       linkLabel.inputTextLinkColor = UIColor.red
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

