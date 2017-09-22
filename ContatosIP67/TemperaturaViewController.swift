//
//  TemperaturaViewController.swift
//  ContatosIP67
//
//  Created by ios7126 on 9/20/17.
//  Copyright © 2017 Caelum. All rights reserved.
//

import Foundation
import UIKit


class TemperaturaViewController: UIViewController {
    @IBOutlet weak var labelCondicaoAtual: UILabel!
    @IBOutlet weak var labelTemperaturaMaxima: UILabel!
    @IBOutlet weak var labelTemperaturaMinima: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelNomeContato: UILabel!
    @IBOutlet weak var labelEnderecoContato: UILabel!
    
    var contato:Contato?
    
    //método chamado quando sai do form. Perda de foco.
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //definindo url do WebService de previsão do tempo
    let URL_BASE = "http://api.openweathermap.org/data/2.5/weather?APPID=c2b9dd1aeda99cbf097c979b5200ba62&units=metric"
    let URL_BASE_IMAGE = "http://api.openweathermap.org/img/w/"
    
    //Metodo executado no primerio acesso ao viewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Cria notificação para detectar mudança de orientação em tempo real
        NotificationCenter.default.addObserver(self, selector: #selector(TemperaturaViewController.orientationChanged), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)

        if let contato = self.contato {
            //contatena URL com latitude e longitude
            if let endpoint = URL(string: URL_BASE + "&lat=\(contato.latitude ?? 0)&lon=\(contato.longitude ?? 0)") {
                print(endpoint)
                //definir URLSession para tratar retorno do serviço
                let session = URLSession(configuration: .default)
                
                //definimos uma tarefa de forma assincrona para realizar a requisição
                let task = session.dataTask(with: endpoint) { (data, response, error) in
                    
                    //trata retorno do serviço
                    if let httpResponse = response as? HTTPURLResponse {
                        
                        //Retorno sucesso
                        if httpResponse.statusCode == 200 {
                            do {
                            //fazendo parse do JSON (retorno do serviço semelhante a um XML)
                            if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject]{
                                let main = json["main"] as! [String:AnyObject]
                                let weather = json["weather"]![0] as! [String:AnyObject]
                                let temp_min = main["temp_min"] as! Double
                                let temp_max = main["temp_max"] as! Double
                                let icon = weather["icon"] as! String
                                let condicao = weather["main"] as! String
                                
                                    //Carregando os labels de forma assincrona para não travar o usuario.
                                    DispatchQueue.main.async {
                                        self.labelCondicaoAtual.text = condicao
                                        self.labelTemperaturaMinima.text = temp_min.description + "º"
                                        self.labelTemperaturaMaxima.text = temp_max.description + "º"
                                        self.pegaImagem(icon)
                                        
                                        self.labelCondicaoAtual.isHidden = false
                                        self.labelTemperaturaMinima.isHidden = false
                                        self.labelTemperaturaMaxima.isHidden = false
                                    }
                                }
                            }catch let error as NSError {
                                print("Não foi possivel faser o parse do JSON: \(error.localizedDescription)")
                            }
                        } else {
                            print("Ocorreu algum problema com a requisição")
                        }
                    }
                }
                
            task.resume()
            }
        }
    }
    
    private func pegaImagem(_ icon:String){
        if let endpoint = URL(string: URL_BASE_IMAGE + icon + ".png") {
            print(endpoint)
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: endpoint) { (data, response, error) in
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        DispatchQueue.main.async {
                            print("exibindo imagem")
                            self.imageView.image = UIImage(data: data!)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    func orientationChanged() {
        // Verifica ambiente (size classes)
        // Carrega campos de contato apenas se estivermos num ambiente wR (Plus e iPads em landscape)
        if sizeClass() == (UIUserInterfaceSizeClass.regular,
                           UIUserInterfaceSizeClass.compact) {
            labelNomeContato.text = contato?.nome
            labelEnderecoContato.text = contato?.endereco
        }
    }
    
}

// Extensão para retornar ambiente de size classes
extension UIViewController {
    func sizeClass() -> (UIUserInterfaceSizeClass,
        UIUserInterfaceSizeClass) {
            return(traitCollection.horizontalSizeClass,
                   traitCollection.verticalSizeClass)
    }
}
