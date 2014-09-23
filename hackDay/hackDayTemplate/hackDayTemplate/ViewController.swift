//
//  ViewController.swift
//  hackDayTemplate
//
//  Created by Rene Limberger on 9/23/14.
//  Copyright (c) 2014 Walt Disney Animation. All rights reserved.
//

import UIKit

class ViewController: UIViewController, PTDBeanManagerDelegate {
    
    let beanManager = PTDBeanManager()
    var currentBean: PTDBean?
    
    @IBOutlet weak var rightEar: UIButton!
    @IBOutlet weak var leftEar: UIButton!
    @IBOutlet weak var speak: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let colors = [UIColor.redColor(), UIColor.blueColor(), UIColor.greenColor()]
    var currentColorIndex = 0
    
    var currentSoundIndex = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        beanManager.delegate = self
        
        hideButtons()
    }
    
    func hideButtons() {
        rightEar.hidden = true
        leftEar.hidden = true
        speak.hidden = true
    }
    
    func showButtons() {
        rightEar.hidden = false
        leftEar.hidden = false
        speak.hidden = false
    }
    
    // MARK: IBActions

    @IBAction func cycleEarColor(sender: UIButton) {
        currentColorIndex++
        if currentColorIndex >= colors.count {
            currentColorIndex = 0
        }
        setColor(colors[currentColorIndex])
    }
    
    func setColor(color: UIColor) {
        // color buttons
        rightEar.backgroundColor = color
        leftEar.backgroundColor = color
        
        if let bean = currentBean {
            bean.setLedColor(color)
        }
    }
    
    @IBAction func saySomething(sender: UIButton) {
        currentSoundIndex++
        if currentSoundIndex >= 3 {
            currentSoundIndex = 0
        }
        setSound(currentColorIndex)
    }
    
    func setSound(soundIndex: Int) {
        // send sound code
        if let bean = currentBean {
            bean.sendSerialString("sound: \(soundIndex)")
        }
    }
    
    // MARK: MeanManager delegate protocol
    
    func beanManagerDidUpdateState(beanManager: PTDBeanManager!) {
        if beanManager.state == BeanManagerState.PoweredOn {
            beanManager.startScanningForBeans_error(nil)
            activityIndicator.startAnimating()
        }
    }
    
    func BeanManager(beanManager: PTDBeanManager!, didDiscoverBean bean: PTDBean!, error: NSError!) {
        // auto connect to known bean
        if bean.name == "WADS Bean" {
            beanManager.connectToBean(bean, error: nil)
            activityIndicator.stopAnimating()
        }
    }
    
    func BeanManager(beanManager: PTDBeanManager!, didConnectToBean bean: PTDBean!, error: NSError!) {
        showButtons()
        currentBean = bean
    }
    
    func BeanManager(beanManager: PTDBeanManager!, didDisconnectBean bean: PTDBean!, error: NSError!) {
        hideButtons()
        currentBean = nil
    }

}

