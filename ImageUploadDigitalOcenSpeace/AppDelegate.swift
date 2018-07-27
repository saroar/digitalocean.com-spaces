//
//  AppDelegate.swift
//  ImageUploadDigitalOcenSpeace
//
//  Created by Alif on 27/7/18.
//  Copyright © 2018 Alif. All rights reserved.
//

import UIKit
import AWSCognito
import AWSS3

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let endpoint = AWSEndpoint(urlString: "https://nyc3.digitaloceanspaces.com")
        
        let credentialsProvider = AWSStaticCredentialsProvider(
            accessKey:"Q5VTF3ARNCQANQJSGIAB",
            secretKey: "WdzHvZE3bNq8z/ylf3EzqA1trk4pyI2wuFrRYOCbj4w"
        )
        
        let defaultServiceConfiguration = AWSServiceConfiguration(
            region:.USEast1,
            endpoint: endpoint,
            credentialsProvider:credentialsProvider
        )
        
//        let defaultServiceConfiguration = AWSServiceConfiguration(region: AWSRegionType.USEast1, endpoint: endpoint, credentialsProvider: credentialsProvider)
        
        defaultServiceConfiguration?.maxRetryCount = 5
        defaultServiceConfiguration?.timeoutIntervalForRequest = 30
        AWSServiceManager.default().defaultServiceConfiguration = defaultServiceConfiguration
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {}
    func applicationDidEnterBackground(_ application: UIApplication) {}
    func applicationWillEnterForeground(_ application: UIApplication) {}
    func applicationDidBecomeActive(_ application: UIApplication) {}
    func applicationWillTerminate(_ application: UIApplication) {}

}

