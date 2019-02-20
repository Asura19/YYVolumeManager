//
//  YYVolumeManager.swift
//  YYVolumeManager
//
//  Created by Phoenix on 2019/2/19.
//  Copyright © 2019 Phoenix. All rights reserved.
//

import Foundation
import MediaPlayer
import AVFoundation
import UIKit

@objc public protocol YYVolumeObserver {
    @objc optional func volumeChanged(value: Float)
}

public final class YYVolumeManager {
    public static let shared = YYVolumeManager()
    
    public var volume: Float {
        didSet {
            self.volumeSlider.setValue(volume, animated: false)
        }
    }
    
    public var customVolumeUI: Bool {
        didSet {
            self.defaultVolumeView.removeFromSuperview()
            if customVolumeUI {
                self.defaultVolumeView.frame = CGRect(x: -100, y: -100, width: 40, height: 40)
                UIApplication.shared.keyWindow!.addSubview(self.defaultVolumeView)
            }
        }
    }
    
    private var observers: NSHashTable<AnyObject>
    private var defaultVolumeView: MPVolumeView
    private lazy var volumeSlider: UISlider = {
        for view in self.defaultVolumeView.subviews {
            if String(describing: type(of: view)) == "MPVolumeSlider" {
                return view as! UISlider
            }
        }
        return UISlider()
    }()
    
    private convenience init() {
        self.init(volume: AVAudioSession.sharedInstance().outputVolume)
    }
    
    private init(volume: Float, customVolumeUI: Bool = false) {
        self.volume = volume
        self.customVolumeUI = customVolumeUI
        observers = NSHashTable(options: [.weakMemory, .objectPersonality], capacity: 0)
        defaultVolumeView = MPVolumeView()
        registeNotification()
    }
    
    public func addObserver(_ observer: YYVolumeObserver) {
        self.observers.add(observer as AnyObject)
    }
    
    public func removeObserver(_ observer: YYVolumeObserver) {
        self.observers.remove(observer as AnyObject)
    }
    
    private func registeNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(volumeChanged),
            name: NSNotification.Name(rawValue: "AVSystemController_SystemVolumeDidChangeNotification"),
            object: nil
        )
        UIApplication.shared.beginReceivingRemoteControlEvents()
    }
    
    private func removeNotification() {
        NotificationCenter.default.removeObserver(self)
        UIApplication.shared.endReceivingRemoteControlEvents()
    }
    
    @objc private func volumeChanged(notification: Notification) {
        guard let userInfo = notification.userInfo else {
            return
        }
        if let currentVolume = userInfo["AVSystemController_AudioVolumeNotificationParameter"] as? Float {
            self.volume = currentVolume
            let enumerator = self.observers.objectEnumerator()
            
            while let observer = enumerator.nextObject() as AnyObject? {
                if observer.responds(to: #selector(YYVolumeObserver.volumeChanged)) {
                    observer.volumeChanged(value: currentVolume)
                }
            }
        }
    }
    
}

