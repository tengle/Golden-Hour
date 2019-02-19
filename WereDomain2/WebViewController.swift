//
//  WebViewController.swift
//  WereDomain2
//
//  Created by Tyler Engle on 1/24/19.
//  Copyright © 2019 Tyler Engle. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let url = URL(string: "http://theroseroom.club/") {
            
            let request = NSMutableURLRequest(url: url)
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                data, response, error in
                
                if error != nil {
                    
                    print(error!)
                    
                } else {
                        
                        self.webView.load(URLRequest(url: url))
                        
                        DispatchQueue.main.sync(execute: {
                            
                            // Update UI
                            
                        })
                        
                    
                    
                }
                
                
            }
            
            task.resume()
            
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
