//
//  AdBannerViewController.swift
//  LifeCalc
//
//  Created by takashi on 2016/04/24.
//  Copyright © 2016年 Takashi Ikeda. All rights reserved.
//

import UIKit
import GoogleMobileAds

class AdBannerViewController: UIViewController {

    @IBOutlet weak var adBannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.initAdBannerView()
        
        self.initAnalysisTracker("AdBanner")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    private func initAdBannerView(){
        print("Google Mobile Ads SDK version: " + GADRequest.sdkVersion())
        
        self.adBannerView.rootViewController = self
        let gadRequest = GADRequest()
        self.adBannerView.loadRequest(gadRequest)
    }
}
