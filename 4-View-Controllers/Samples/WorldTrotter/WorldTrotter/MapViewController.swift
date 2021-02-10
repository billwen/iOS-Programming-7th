//
//  MapViewController.swift
//  WorldTrotter
//
//  Created by Gang Wen on 2021-02-08.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    var _mapView: MKMapView!
    
    var _mapSegmentCtl: UISegmentedControl = UISegmentedControl(items: ["Standard", "Hybrid", "Satellite"])
    
    override func loadView() {
        self._mapView = MKMapView()
        
        // set it as *the* view of this view controller
        self.view = self._mapView
        
        // Map controls
        self._mapSegmentCtl.backgroundColor = .systemBackground
        self._mapSegmentCtl.selectedSegmentIndex = 0
        self._mapSegmentCtl.translatesAutoresizingMaskIntoConstraints = false
        self._mapSegmentCtl.addTarget(self, action: #selector(mapTypeChanged(_:)), for: .valueChanged)
        view.addSubview(self._mapSegmentCtl)
        
        let topConstraint = self._mapSegmentCtl.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 8)
        let leadingConstraint = self._mapSegmentCtl.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 8)
        let trailingConstraint = self._mapSegmentCtl.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -8)
        
        topConstraint.isActive = true
        leadingConstraint.isActive = true
        trailingConstraint.isActive = true
        
        // Point of interest
        var poiLabel = UILabel()
        poiLabel.text = "Points of Interest"
        poiLabel.backgroundColor = .blue
        poiLabel.translatesAutoresizingMaskIntoConstraints = false
        poiLabel.font = .systemFont(ofSize: 20)
        self.view.addSubview(poiLabel)
        let poiTopConstraint = poiLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 80)
        let poiLeftConstraint = poiLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 8)
        poiTopConstraint.isActive = true
//        poiLeftConstraint.isActive = true
        
        var switchCtl = UISwitch()
        switchCtl.isOn = true
        self.view.addSubview(switchCtl)
        let switchTC = switchCtl.topAnchor.constraint(equalTo: self._mapSegmentCtl.bottomAnchor, constant: 20)
        switchTC.isActive = true
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print("MapViewController loaded it views")
    }
    
    @objc func mapTypeChanged(_ segControl: UISegmentedControl) {
        switch segControl.selectedSegmentIndex {
        case 0:
            self._mapView.mapType = .standard
        case 1:
            self._mapView.mapType = .hybrid
        case 2:
            self._mapView.mapType = .satellite
        default:
            break
        }
    }

}
