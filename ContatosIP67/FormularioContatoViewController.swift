//
//  ViewController.swift
//  ContatosIP67
//
//  Created by ios7126 on 9/12/17.
//  Copyright © 2017 Caelum. All rights reserved.
//

import UIKit

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
    
    @IBAction func criarContato(){
        self.pegaDadosFormulario()
        dao.adiciona(contato)
        
        //aciona delegate
        self.delegate?.contatoAdicionado(contato)
        
        _ = self.navigationController?.popViewController(animated: true)
        
        //Apenas imprime para validar os dados
        //print(self.contato)
        for contato in dao.contatos {
         print(contato)
         }
    }
    
    func pegaDadosFormulario(){
        
        if contato == nil{
            self.contato = Contato()
        }
        
        self.contato.nome = self.nome.text!
        self.contato.telefone = self.telefone.text!
        self.contato.endereco = self.endereco.text!
        self.contato.site = self.site.text!
        
    }

    //Metodo chamado toda vez que o formulario é carregado pela primeira vez
    override func viewDidLoad() {
        super.viewDidLoad()
        // Mostrar contato na tela.
        if contato != nil {
            self.nome.text = contato.nome
            self.telefone.text = contato.telefone
            self.endereco.text = contato.endereco
            self.site.text = contato.site
            
            //Altera dinamicamente o botão adicionar para confirmar, caso o objeto contato esteja preenchido.
            let botaoAlterar = UIBarButtonItem(title: "Confirmar", style: .plain, target: self, action: #selector(atualizaContato))
            self.navigationItem.rightBarButtonItem = botaoAlterar
        }
        
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
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let imageSelecionada = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.imageView.image = imageSelecionada
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
