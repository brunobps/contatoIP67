//
//  ContatoNoMapaViewController.swift
//  ContatosIP67
//
//  Created by ios7126 on 9/15/17.
//  Copyright © 2017 Caelum. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class ContatosNoMapaViewController: UIViewController {
    @IBOutlet weak var mapa: MKMapView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Solicita permissão do usuario para acessar localização. Necessario incluir opção privacy no Info.plist
        self.locationManager.requestWhenInUseAuthorization()
        
        //definindo botão de localização
        let botaoLocalizacao = MKUserTrackingBarButtonItem(mapView: self.mapa)
        
        //Incluindo botão localização na tabBar.
        self.navigationItem.rightBarButtonItem = botaoLocalizacao
    }
}
