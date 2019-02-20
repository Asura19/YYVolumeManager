//
//  ViewController.swift
//  YYVolumeManager
//
//  Created by Phoenix on 2019/2/19.
//  Copyright © 2019 Phoenix. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, YYVolumeObserver {

    @IBOutlet weak var slider: UISlider!
    override func viewDidLoad() {
        super.viewDidLoad()
        try? AVAudioSession.sharedInstance().setActive(true, options: [])
        YYVolumeManager.shared.addObserver(self)
        self.slider.value = YYVolumeManager.shared.volume
    }
    
    deinit {
        YYVolumeManager.shared.removeObserver(self)
    }

    @IBAction func changeVolume(_ sender: UISlider) {
        YYVolumeManager.shared.volume = sender.value;
    }
    
    @IBAction func setCustomVolumeUI(_ sender: UISwitch) {
        YYVolumeManager.shared.customVolumeUI = sender.isOn
    }
    
    func volumeChanged(value: Float) {
        self.slider.value = value
        print("Media volume is \(value)")
    }
}

