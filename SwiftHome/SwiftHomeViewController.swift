//
//  ViewController.swift
//  SwiftHome
//
//  Created by Christopher Scalcucci on 9/18/16.
//  Copyright © 2016 Christopher Scalcucci. All rights reserved.
//

import UIKit
import CocoaMQTT

class SwiftHomeViewController: UIViewController {

    @IBOutlet weak var ledView: UIView!
    @IBOutlet weak var ledButton: UIButton!
    
    var illuminated : Bool = false {
        didSet {
            sendUpdate()
            ledView.backgroundColor = illuminated ? UIColor.green : UIColor.red
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MQTTManager.sharedInstance.mqtt.subscribe("piButton", qos: CocoaMQTTQOS.qos0)

    }


    @IBAction func didTap(_ sender: UIButton) {
        illuminated = !illuminated
    }
    
    func sendUpdate() {
        MQTTManager.sharedInstance.mqtt.subscribe("phoneButton", qos: CocoaMQTTQOS.qos0)
        MQTTManager.sharedInstance.mqtt.publish("phoneButton", withString: "\(illuminated)")
    }

}

