//
//  ContatoDao.swift
//  ContatosIP67
//
//  Created by ios7126 on 9/12/17.
//  Copyright © 2017 Caelum. All rights reserved.
//

import UIKit
import Foundation

class ContatoDao: CoreDataUtil {
    
    override private init(){
        self.contatos = Array()
        super.init()
        self.inserirDadosIniciais()
        self.carregaContatos()
        //print("Caminho do BD: \(NSHomeDirectory())")
    }
    
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
    
    func listaTodos() -> [Contato]{
        return contatos
    }
    
    func buscaContatoNaPosicao(_ posicao:Int) -> Contato {
        return contatos[posicao]
    }
    
    func remove(_ posicao:Int){
        persistentContainer.viewContext.delete(contatos[posicao])
        contatos.remove(at:posicao)
        //salva instancia do Dao para persistir no banco.
        saveContext()
    }
    
    func buscaPosicaoDoContato(_ contato: Contato) -> Int {
        return contatos.index(of: contato)!
    }
    
    func inserirDadosIniciais(){
        let configuracoes = UserDefaults.standard
        let dadosInseridos = configuracoes.bool(forKey: "dados_inseridos")
        
        if !dadosInseridos {
            let caelumSp = NSEntityDescription.insertNewObject(forEntityName: "Contato", into: self.persistentContainer.viewContext) as! Contato
            caelumSp.nome = "Caelum SP"
            caelumSp.endereco = "São Paulo, SP, Rua Vergueiro, 3185"
            caelumSp.telefone = "01155712751"
            caelumSp.site = "http://www.caelum.com.br"
            caelumSp.latitude = -23.5883034
            caelumSp.longitude = -46.632369
            
            self.saveContext()
            
            configuracoes.set(true, forKey: "dados_inseridos")
            configuracoes.synchronize()
            
        }
    }
    
    func carregaContatos(){
        let busca = NSFetchRequest<Contato>(entityName: "Contato")
        
        let orderPorNome = NSSortDescriptor(key: "nome", ascending: true)
        
        busca.sortDescriptors = [orderPorNome]
        
        do {
            self.contatos = try self.persistentContainer.viewContext.fetch(busca)
        } catch let error as NSError {
            print("Fetch falhou: \(error.localizedDescription)")
        }
    }
    
    func novoContato() -> Contato{
        return NSEntityDescription.insertNewObject(forEntityName: "Contato", into: self.persistentContainer.viewContext) as! Contato
    }
    
    
}
