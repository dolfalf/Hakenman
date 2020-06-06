//
//  PrivacyPolicyViewController.swift
//  Hakenman
//
//  Created by jaeeun on 2018/09/18.
//  Copyright © 2018年 kjcode. All rights reserved.
//

import UIKit

class PrivacyPolicyViewController: UIViewController {

    @IBOutlet weak var contentWebView: UIWebView!
    
    //https://github.com/dolfalf/Hakenman/blob/master/Hakenman/screen/information/privarcy_policy.html
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = NSLocalizedString("PrivarcyPolicyViewController_navi_title", comment: "")
        UIFont.setNaviTitle(UIFont.nanumFont(ofSize: 16.0))
        let urlString = NSLocalizedString("PrivarcyPolicyViewController_url_file", comment: "")
        contentWebView.loadRequest(URLRequest(url: URL(string: urlString)!))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
