//
//  ViewController.swift
//  ContatosIP67
//
//  Created by ios7126 on 9/12/17.
//  Copyright © 2017 Caelum. All rights reserved.
//

import UIKit

class FormularioContatoViewController: UIViewController {

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
        
    }
    
    func atualizaContato(){
        pegaDadosFormulario()
        //aciona delegate
        self.delegate?.contatoAtualizado(contato)
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
