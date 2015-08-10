//
//  AppDelegate.swift
//  TeamSounds
//
//  Created by Said Marouf on 7/27/15.
//  Copyright (c) 2015 Said Marouf. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.

        window?.tintColor = UIColor(red: 247/255.0, green: 84/255.0, blue: 76/255.0, alpha: 1.0)
        
        //setup audio session
        var audioSession = AVAudioSession.sharedInstance()
        var categoryError: NSError?
        if !audioSession.setCategory(AVAudioSessionCategoryPlayback, error: &categoryError) {
            print("Aduio Session category error: \(categoryError)")
        }
        var activationError: NSError?
        if !audioSession.setActive(true, error: &activationError) {
            print("Aduio Session activationError error: \(activationError)")
        }
        
        return true
    }
    
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        
        return handleSoundCloudLogin(url)
    }
    
    private func handleSoundCloudLogin(url: NSURL) -> Bool {
        
        let absoluteURL: String = url.absoluteString!
        if absoluteURL.rangeOfString(SCEngine.redirectURL) != nil {
            
            println("OAuth")
            
            let codeArr = absoluteURL.componentsSeparatedByString("code=")
            if codeArr.count > 1 {
                var code = codeArr[1]
                if code.hasSuffix("#") {
                    code = code.substringToIndex(code.endIndex.predecessor())
                }
                NSUserDefaults.standardUserDefaults().setObject(code, forKey: "SoundCloudCode")
                NSUserDefaults.standardUserDefaults().synchronize()
                
                //got code
                //continue OAuth
                SCEngine.sharedEngine.continueLogInWithCode(code)
            }
        }
        return false
    }
    

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

