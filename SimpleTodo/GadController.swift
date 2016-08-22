//
//  GadController.swift
//  SimpleTodo
//
//  Created by kenjou yutaka on 2016/08/22.
//  Copyright © 2016年 yutaka kenjo. All rights reserved.
//

import UIKit
import GoogleMobileAds

class GadController: GADBannerView ,GADBannerViewDelegate {
    
    internal func gadBannerInit(frameWidth:CGFloat,frameHeight:CGFloat ,viewController:UIViewController) -> GADBannerView{
        var bannerView : GADBannerView = GADBannerView()
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        bannerView.frame.origin = CGPointMake(0, frameHeight - bannerView.frame.height)
        //bannerView.frame.origin = CGPointMake(0, 30.0)
        bannerView.frame.size = CGSizeMake(frameWidth, bannerView.frame.height)
        bannerView.adUnitID = "ca-app-pub-5120043028884141/1157467111"
        bannerView.delegate = self
        bannerView.rootViewController = viewController
        let gadRequest = GADRequest()
        //テスト用　申請時にコメントアウト
        gadRequest.testDevices = ["76ecad5fc0db8001fad445437590b7a9"]
        bannerView.loadRequest(gadRequest)
        
        return bannerView
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
