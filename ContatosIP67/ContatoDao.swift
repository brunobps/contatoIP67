//
//  ContatoDao.swift
//  ContatosIP67
//
//  Created by ios7126 on 9/12/17.
//  Copyright © 2017 Caelum. All rights reserved.
//

import UIKit
import Foundation

class ContatoDao: NSObject {
    
    //Singleton= garante uma unica instancia da classe.
    static private var defaultDAO: ContatoDao!
    static func sharedInstance() -> ContatoDao{
        
        if defaultDAO == nil {
            defaultDAO =  ContatoDao()
        }
        return defaultDAO
    }
    
    var contatos: Array<Contato>
    
    func adiciona(_ contato:Contato){
        contatos.append(contato)
    }
    
    override private init(){
        self.contatos = Array()
        super.init()
    }
    
}