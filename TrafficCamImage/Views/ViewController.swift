//
//  ViewController.swift
//  TrafficCamImage
//
//  Created by John Freidrich Cinco on 7/17/20.
//  Copyright © 2020 John Freidrich Cinco. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var camImagePopup: CamImagePopup!
    @IBOutlet var progress: UIActivityIndicatorView!
    
    private var viewModel: MapViewModel = MapViewModel.sharedInstance
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.camImagePopup.hide()
        
        self.initializeViewModel()
        self.initializeMap()
        
        self.hideProgress()
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
        self.mapView.delegate = self
        self.mapView.setCenter(viewModel.initialCoordinates, animated: true)
        self.showProgress()
        self.viewModel.getCameraList { cams, error in
            if (nil == error) {
                cams?.forEach { cam in
                    self.mapView.addAnnotation(cam)
                }
            }
            else {
                self.showDialog(title: "Error", message: error?.message ?? "Failed to fetch camera locations.")
            }
            
            DispatchQueue.main.async {
                self.hideProgress()
            }
        }
    }
    
    
    // Delegate methods
    // Annotation selection
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let cam = view.annotation as! CameraAnnotation
        self.showProgress()
        self.viewModel.getImageForCam(camera: cam.camera!) { image in
            if (nil != image) {
                self.camImagePopup.show(image: image!,
                                        title: cam.camera?.timestamp ?? "Traffic Cam Image",
                                        meta: cam.camera?.image_metadata) { _ in
                    self.camImagePopup.hide()
                }
            }
            else {
                // show error
                self.showDialog(title: "Error", message: "Failed to get camera image.")
            }
            DispatchQueue.main.async {
                self.hideProgress()
            }
            
        }
    }
    
    
    private func showDialog(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
    }
 
    private func hideProgress() {
        if (self.progress != nil) {
            self.progress.stopAnimating()
            self.progress.isHidden = true
        }
    }
    
    private func showProgress() {
        if (self.progress != nil) {
            self.progress.startAnimating()
            self.progress.isHidden = false
        }
    }
    
    
}

