//
//  GerenciadorDeAcoes.swift
//  ContatosIP67
//
//  Created by ios7126 on 9/14/17.
//  Copyright © 2017 Caelum. All rights reserved.
//

import Foundation
import UIKit

class GerenciadorDeAcoes: NSObject {
    
    let contato:Contato
    var controller:UIViewController!
    
    init(do contato:Contato) {
        self.contato = contato
    }
    
    //método para exibir as ações do alert.
    func exibirAcoes(em controller:UIViewController) {
        self.controller = controller
        
        let alertView = UIAlertController(title: self.contato.nome, message: nil, preferredStyle: .actionSheet)
        
        let cancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        let ligarParaContato = UIAlertAction(title: "Ligar", style: .default){
            action in self.ligar()
        
        }
        
        let exibirContatoNoMapa = UIAlertAction(title: "Visualizar no Mapa", style: .default){
            action in self.abrirMapa()
            
        }
        
        let exibirSiteDoContato = UIAlertAction(title: "Visualizar Site", style: .default){
            action in self.abrirNavegador()
            
        }
        
        let exibirTemperatura = UIAlertAction(title: "Visualizar Clima", style: .default) { action in
            self.exibirTemperatura()
        }
        
        
        alertView.addAction(cancelar)
        alertView.addAction(ligarParaContato)
        alertView.addAction(exibirContatoNoMapa)
        alertView.addAction(exibirSiteDoContato)
        alertView.addAction(exibirTemperatura)
        
        self.controller.present(alertView, animated: true, completion: nil)
    }
    
    private func ligar(){
        let device = UIDevice.current
        
        if device.model == "iPhone" {
            
            //Para abrir o aplicativo, basta passar uma string separada por :. O parametro que vem antes identifica o que se pretende fazer, tel por exemplo é para ligaçao. mailto para e-mail.
            abrirAplicativo(com: "tel:" + contato.telefone)
        } else{
            //Dispara alerta informando que não é possivel realizar ligações
            let alert = UIAlertController(title: "Impossível fazer ligações", message: "Seu dispositivo não é um IPHONE", preferredStyle: .alert)
            self.controller.present(alert, animated: true, completion: nil)
        }
    }
    
    
    private func abrirMapa(){
        let url = ("http://maps.google.com/maps?q=" + self.contato.endereco!).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        abrirAplicativo(com: url)
    }
    
    private func abrirNavegador(){
    
        var url = contato.site!
        
        if !url.hasPrefix("http://") {
            url = "http://" + url
        }
        
        abrirAplicativo(com: url)
    }
    
    private func exibirTemperatura(){
        
        //vincula viewController através da tag definida
        let temperaturaViewController = controller.storyboard?.instantiateViewController(withIdentifier: "temperaturaViewController") as! TemperaturaViewController
        
        //passando contato para o viewController
        temperaturaViewController.contato = self.contato
        
        //Abrir página da temperatura
        controller.navigationController?.pushViewController(temperaturaViewController, animated: true)
    }
    
    private func abrirAplicativo(com url:String){
        UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
    }
}
