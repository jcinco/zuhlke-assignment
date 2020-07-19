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
            DispatchQueue.main.async {
                if (nil == error) {
                    cams?.forEach { cam in
                        self.mapView.addAnnotation(cam)
                    }
                }
                else {
                    self.showDialog(title: "Error", message: error?.message ?? "Failed to fetch camera locations.")
                }
                self.hideProgress()
            }
        }
    }
    
    
    // Delegate methods
    // Annotation selection
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let cam = view.annotation as! CameraAnnotation
        self.showProgress()
        self.viewModel.getImageForCam(camera: cam.camera!) { image, timestamp in
           DispatchQueue.main.async {
                if (nil != image) {
                    self.camImagePopup.show(image: image!,
                                            title: timestamp ?? "No Time",
                                            meta: cam.camera?.image_metadata) { _ in
                        self.camImagePopup.hide()
                    }
                }
                else {
                    // show error
                    self.showDialog(title: "Error", message: "Failed to get camera image.")
                }
                self.hideProgress()
            }
            
        }
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "camAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if (nil == annotationView) {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            
        }
        
        return annotationView
    }
    
    // Private methods
    
    private func showDialog(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
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

