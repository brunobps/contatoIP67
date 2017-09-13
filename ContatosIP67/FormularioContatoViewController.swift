//
//  ViewController.swift
//  ContatosIP67
//
//  Created by ios7126 on 9/12/17.
//  Copyright © 2017 Caelum. All rights reserved.
//

import UIKit

class FormularioContatoViewController: UIViewController {

    var dao:ContatoDao
    
    required init?(coder aDecoder: NSCoder){
        self.dao = ContatoDao.sharedInstance()
        super.init(coder: aDecoder)
    }
    
    @IBOutlet var nome: UITextField!
    @IBOutlet var telefone: UITextField!
    @IBOutlet var endereco: UITextField!
    @IBOutlet var site: UITextField!
    
    @IBAction func pegaDadosFormulario(){
        
        let contato: Contato = Contato()
        
        contato.nome = self.nome.text!
        contato.telefone = self.telefone.text!
        contato.endereco = self.endereco.text!
        contato.site = self.site.text!
        
        dao.adiciona(contato)
        
        for contato in dao.contatos {
            print(contato)
        }
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
