//
//  FormularioContatoViewControllerDelegate.swift
//  ContatosIP67
//
//  Created by ios7126 on 9/14/17.
//  Copyright © 2017 Caelum. All rights reserved.
//

import Foundation

protocol FormularioContatoViewControllerDelegate {
    
    func contatoAdicionado(_ contato:Contato)
    func contatoAtualizado(_ contato:Contato)

}
