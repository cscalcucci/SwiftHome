//
//  MQTTManager.swift
//  SwiftHome
//
//  Created by Christopher Scalcucci on 9/18/16.
//  Copyright © 2016 Christopher Scalcucci. All rights reserved.
//

import Foundation
import CocoaMQTT

struct Config {
    
    static let MQTTUsername = "cscalcucci"
    static let MQTTPassword = "rootme"
    static let MQTTHostname = "broker.hivemq.com"
    static let MQTTPort:UInt16 = 1883
    
}

class MQTTManager: NSObject, CocoaMQTTDelegate {
    
    static let sharedInstance = MQTTManager()
    
    var delegate:MQTTManagerDelegate?
    
    let clientIdPid = "SwiftHome-CocoaMQTT-" + String(ProcessInfo().processIdentifier)
    
    let mqtt = CocoaMQTT(clientId: "SwiftHome", host: Config.MQTTHostname, port: Config.MQTTPort)
    
    var connected = false {
        didSet {
            delegate?.mqttManagerConnectionChanged(mqttManager: self)
        }
    }
    
    override init() {
        super.init()
        mqtt.username = Config.MQTTUsername
        mqtt.password = Config.MQTTPassword
        mqtt.keepAlive = 60
        mqtt.delegate = self
        
        connect()
    }
    
    func connect() {
        if mqtt.connState != .connected && mqtt.connState != .connecting {
            mqtt.connect();
        }
    }
}

// MARK: CocoaMQTTDelegate Methods
extension MQTTManager {
    func mqtt(_ mqtt: CocoaMQTT, didConnect host: String, port: Int) {
        print("Connected to MQTT server.")
        connected = true
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        //
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        print("Published Message \(message.string) on topic \(message.topic)")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
        //
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16 ) {
        if let string = message.string {
            print("Received Message on Topic: \(message.topic), contents: \(string)")
        }
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopic topic: String) {
        print("Subscribed to topic: \(topic)")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
        //
    }
    
    func mqttDidPing(_ mqtt: CocoaMQTT) {
        print("Ping!")
    }
    
    func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
        print("Pong!")
    }
    
    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: NSError?) {
        print("Disconnected from MQTT!",err)
        connected = false
        connect()
    }
}

protocol MQTTManagerDelegate {
    func mqttManagerConnectionChanged(mqttManager:MQTTManager)
}
