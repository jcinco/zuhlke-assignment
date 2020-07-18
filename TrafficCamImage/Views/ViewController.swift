//
//  ViewController.swift
//  TrafficCamImage
//
//  Created by John Freidrich Cinco on 7/17/20.
//  Copyright © 2020 John Freidrich Cinco. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    @IBOutlet var mapView: MKMapView!
    
    private var viewModel: MapViewModel = MapViewModel.sharedInstance
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initializeViewModel()
        self.initializeMap()
    }

    
    
    private func initializeViewModel() {
        // Initialize view model
        if (viewModel.reposiory == nil) {
            viewModel.reposiory = CamRepository.sharedInstance
        }
        
        if (viewModel.reposiory?.provider == nil) {
            viewModel.reposiory?.provider = CamInfoProvider(client: HttpGet.self)
        }
    }
    
    
    private func initializeMap() {
        self.mapView.setCenter(viewModel.initialCoordinates, animated: true)
        self.viewModel.getCameraList { cams, error in
            if (nil == error) {
                cams?.forEach { cam in
                    self.mapView.addAnnotation(cam)
                }
            }
        }
    }
    
}

