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

class ContatosNoMapaViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapa: MKMapView!
    //criando array para armazenar contatos
    var contatos: [Contato] = Array()
    
    //recuperar instancia de contatos
    let dao:ContatoDao = ContatoDao.sharedInstance()
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapa.delegate = self
        
        //Solicita permissão do usuario para acessar localização. Necessario incluir opção privacy no Info.plist
        self.locationManager.requestWhenInUseAuthorization()
        
        //definindo botão de localização
        let botaoLocalizacao = MKUserTrackingBarButtonItem(mapView: self.mapa)
        
        //Incluindo botão localização na tabBar.
        self.navigationItem.rightBarButtonItem = botaoLocalizacao
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.contatos = dao.listaTodos()
        //como no protocolo declaramos o contato como CLLocationCoordinate2D, posso consumir o objeto contatos e adicionar à notação para adiocionar os contatos no mapa.
        self.mapa.addAnnotations(self.contatos)
        self.mapa.isZoomEnabled = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //remove os pontos do mapa
        self.mapa.removeAnnotations(self.contatos)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let identifier:String = "pino"
        var pino:MKPinAnnotationView
        
        if let reusablePin = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
            pino = reusablePin
        }else{
            pino = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        
        if let contato = annotation as? Contato {
            pino.pinTintColor = UIColor.red
            pino.canShowCallout = true
            
            let frame = CGRect(x: 0.0, y: 0.0, width: 32.0, height: 32.0)
            let imagemContato = UIImageView(frame: frame)
            
            imagemContato.image = contato.foto
            
            pino.leftCalloutAccessoryView = imagemContato
        }
        return pino
    }
    
    //Fazer zoom a partir do click no pino.
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        //Recupera pino clicado
        let pinoClicado = view.annotation
        
        
        let span = MKCoordinateSpanMake(0.1, 0.1)
        
        //Aproxima o zoom
        let region  = MKCoordinateRegion(center: pinoClicado!.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
}
