//
//  DetailViewController.swift
//  WereDomain2
//
//  Created by Tyler Engle on 1/23/19.
//  Copyright © 2019 Tyler Engle. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var imgImage: UIImageView!
    @IBOutlet weak var lblBusinessName: UILabel!
    @IBOutlet weak var lblRecurringSpecial: UILabel!
    @IBOutlet weak var map: MKMapView!
    
    var image = UIImage()
    var name = ""
    var recurringSpecial = ""
    
    @IBAction func backToMain(_ sender: Any) {
    
        self.dismiss(animated: true, completion: nil)

    }
    

    override func viewDidLoad() {
        
        
        imgImage.image = image
        lblBusinessName.text = name
        lblRecurringSpecial.text = recurringSpecial
        
        let latitude: CLLocationDegrees = 30.4006622
        
        let longitude: CLLocationDegrees = -97.72315129999998
        
        let latDelta: CLLocationDegrees = 0.0005
        
        let lonDelta: CLLocationDegrees = 0.0005
        
        let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        
        let location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let region: MKCoordinateRegion = MKCoordinateRegion(center: location, span: span)
        
        map.setRegion(region, animated: true)
        
        
        
         
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        if segue.destination is FeedTableViewController
        {
            
            self.dismiss(animated: true, completion: nil)
            
        }
    }
    

}
