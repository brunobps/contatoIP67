//
//  ListaContatosViewController.swift
//  ContatosIP67
//
//  Created by ios7126 on 9/12/17.
//  Copyright © 2017 Caelum. All rights reserved.
//

import UIKit

//Implementando o delegate.
class ListaContatosViewController: UITableViewController, FormularioContatoViewControllerDelegate {

    var dao:ContatoDao
    static let cellIdentifier = "Cell"
    var linhaDestaque: IndexPath?
    
    //Inicialização dos Objetos
    required init?(coder aDecoder: NSCoder) {
        self.dao = ContatoDao.sharedInstance()
        super.init(coder: aDecoder)
    }
    
    //Ao Carregar a lista pela primeira vez
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    //Toda vez que a lista é apresentada
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
        
        if let linha = self.linhaDestaque {
            //seleciona a linha
            self.tableView.selectRow(at: linha, animated: true, scrollPosition: .middle)
            
            //Cria uma thread assincrona que aguarda 1 segundo para deselecionar a linha
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)){
                
                //deseleciona a linha
                self.tableView.deselectRow(at: linha, animated: true)
                self.linhaDestaque = Optional.none
            }
        }
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //Número de sessões
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    //Numero de linhas da sessão
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dao.listaTodos().count
    }

    //Metodo para vincular valores às celulas da lista
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: ListaContatosViewController.cellIdentifier)

        let contato:Contato = self.dao.buscaContatoNaPosicao(indexPath.row)
        
        // A Opção Style muda o tipo da lista. Verificar ENUM
        if cell==nil{
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: ListaContatosViewController.cellIdentifier)
        }
        
        cell!.textLabel?.text = contato.nome
        cell!.detailTextLabel?.text = contato.telefone
        
        return cell!
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    //Metodo para iterações com a lista
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            self.dao.remove(indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    //Método acionado ao clicar em um item da lista.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contatoSelecionado = dao.buscaContatoNaPosicao(indexPath.row)
        print("Nome: \(contatoSelecionado.nome!)")
        
        self.exibeFormulario(contatoSelecionado)
        
    }
    
    func exibeFormulario(_ contato:Contato){
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        //O identificador Form-Contato foi definido diretamente no StoryBoard
        let formulario = storyboard.instantiateViewController(withIdentifier: "Form-Contato") as! FormularioContatoViewController
        
        //habilita o delegate
        formulario.delegate = self
        formulario.contato = contato
        
        //Quando na hierarquia é chamado uma pagina posterior utiliza PUSH, quando anterior é POP.
        self.navigationController?.pushViewController(formulario, animated: true)
        
    }
    
    //Função criada no delegate
    func contatoAtualizado(_ contato: Contato) {
        self.linhaDestaque = IndexPath(row: dao.buscaPosicaoDoContato(contato), section: 0)
        print("contato atualizado: \(contato.nome)")
    }
    //Função criada no delegate
    func contatoAdicionado(_ contato: Contato) {
        self.linhaDestaque = IndexPath(row: dao.buscaPosicaoDoContato(contato), section: 0)
        print("contato adicionado: \(contato.nome)")
    }
    
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "FormSegue"{
            if let formulario = segue.destination as? FormularioContatoViewController {
                formulario.delegate = self
            }
        }
    }
    

}
