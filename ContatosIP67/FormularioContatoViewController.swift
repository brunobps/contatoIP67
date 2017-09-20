//
//  ViewController.swift
//  ContatosIP67
//
//  Created by ios7126 on 9/12/17.
//  Copyright © 2017 Caelum. All rights reserved.
//

import UIKit
import CoreLocation

class FormularioContatoViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    //Declaração de variáveis
    var dao:ContatoDao
    var contato:Contato!
    var delegate:FormularioContatoViewControllerDelegate?
    
    required init?(coder aDecoder: NSCoder){
        self.dao = ContatoDao.sharedInstance()
        super.init(coder: aDecoder)
    }
    
    @IBOutlet var nome: UITextField!
    @IBOutlet var telefone: UITextField!
    @IBOutlet var endereco: UITextField!
    @IBOutlet var site: UITextField!
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var latitude: UITextField!
    @IBOutlet var longitude: UITextField!
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    @IBAction func criarContato(){
        self.pegaDadosFormulario()
        dao.adiciona(contato)
        
        //aciona delegate
        self.delegate?.contatoAdicionado(contato)
        
        _ = self.navigationController?.popViewController(animated: true)
        
        //Apenas imprime para validar os dados
        //print(self.contato)
        /*for contato in dao.contatos {
            print(contato)
        }*/
    }
    
    func pegaDadosFormulario(){
        
        if contato == nil{
            self.contato = dao.novoContato()
        }
        
        self.contato.nome = self.nome.text!
        self.contato.telefone = self.telefone.text!
        self.contato.endereco = self.endereco.text!
        self.contato.site = self.site.text!
        self.contato.foto = self.imageView.image
        
        if let foto = self.contato.foto {
            self.imageView.image = foto
        }
        
        if let latitude = Double(self.latitude.text!){
            self.contato.latitude = latitude as NSNumber
        }
        
        if let longitude = Double(self.longitude.text!){
            self.contato.longitude = longitude as NSNumber
        }
        
        let botaoAlterar: UIBarButtonItem = UIBarButtonItem(title: "Confirmar", style: .plain, target: self, action: #selector(atualizaContato))
        
        self.navigationItem.rightBarButtonItem = botaoAlterar
        
        
    }

    //Metodo chamado toda vez que o formulario é carregado pela primeira vez
    override func viewDidLoad() {
        super.viewDidLoad()
        self.latitude.isEnabled = false
        self.longitude.isEnabled = false
        
        // Mostrar contato na tela.
        if contato != nil {
            self.nome.text = contato.nome
            self.telefone.text = contato.telefone
            self.endereco.text = contato.endereco
            self.site.text = contato.site
            self.latitude.text = contato.latitude?.description
            self.longitude.text = contato.longitude?.description
            
            if let foto = contato.foto {
                self.imageView.image = foto
            }
            
            //Altera dinamicamente o botão adicionar para confirmar, caso o objeto contato esteja preenchido.
            let botaoAlterar = UIBarButtonItem(title: "Confirmar", style: .plain, target: self, action: #selector(atualizaContato))
            self.navigationItem.rightBarButtonItem = botaoAlterar
        }
        
        //identificando que o usuário acionou o long press da imagem
        let tap = UITapGestureRecognizer(target: self, action: #selector(selecionarFoto(sender:)))
        self.imageView.addGestureRecognizer(tap)
    }
    
    func atualizaContato(){
        pegaDadosFormulario()
        //aciona delegate
        self.delegate?.contatoAtualizado(contato)
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    func selecionarFoto(sender: AnyObject){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            //camera disponível
        }else{
            //vamos apresentar a biblioteca para o usuário  
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    //Delegate para selecionar imagem.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let imageSelecionada = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.imageView.image = imageSelecionada
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buscarCoordenadas(sender:UIButton){
        
        //verifica se o endereço está nulo e apresenta alert.
        if self.endereco.text == "" || self.endereco.text == nil {
            //instancia o alert
            let alertView = UIAlertController(title: "Endereço", message: "Preencha o endereço", preferredStyle: .alert)
            //adiciona o botão ok no alert
            let ok = UIAlertAction(title: "ok", style: .cancel, handler: nil)
            alertView.addAction(ok)
            //apresenta o alert na tela
            self.present(alertView, animated: true, completion: nil)
            
        } else {
            //Animação do Spinner
            self.loading.startAnimating()
            //desabilitar botão
            sender.isHidden = true
            
            let geocoder = CLGeocoder()
            
            //busca coordenadas a partir do endereço
            geocoder.geocodeAddressString(self.endereco.text!) { (resultado, error) in
                
                if error == nil && (resultado?.count)! > 0 {
                    let placemark = resultado![0]
                    let coordenada = placemark.location!.coordinate
                    
                    self.latitude.text = coordenada.latitude.description
                    self.longitude.text = coordenada.longitude.description
                    
                    //parar animação
                    self.loading.stopAnimating()
                    //Habilitar botão novamente.
                    sender.isHidden = false
                }
        }
        
        
    }
    
        
    //override func didReceiveMemoryWarning() {
    //    super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
