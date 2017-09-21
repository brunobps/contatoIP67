//
//  ViewController.swift
//  NetWorking
//
//  Created by ios7126 on 9/20/17.
//  Copyright © 2017 Caelum. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var segNetwork: UISegmentedControl!
    @IBOutlet weak var labelResultado: UILabel!
    
    // MARK: - Propriedades
    let getEndPoint = "https://httpbin.org/ip"
    let postEndPoint = "https://requestb.in/15aignu1"
    
    // MARK: - Actions
    @IBAction func networkSelecionada(_ sender: UISegmentedControl) {
        switch segNetwork.selectedSegmentIndex {
        case 0:
            // GET
            enviarGET()
        case 1:
            // POST
            enviarPOST()
        default:
            print("Opção Inválida")
        }
    }
    
    // MARK: - Funções de Apoio
    func enviarGET() {
        // Validação do Endpoint, com guard
        guard let getURL = URL(string: getEndPoint) else {
            print("Erro na URL de requisição")
            return }
        /* RELEMBRANDO A SEQUÊNCIA DE OPERAÇÕES DO PARSE
         1 - URL
         2 - SESSION
         3 - DATA
         4 - RESUME
         */
        // 1-URL
        let request = URLRequest(url: getURL)
        // 2-SESSION
        let urlSession = URLSession.shared
        // 3-DATA
        let task = urlSession.dataTask(with: request, completionHandler: {
            data, response, error in
            // Retorno do protocolo HTTP
            //  response = 200
        guard let realResponse = response as? HTTPURLResponse,
            realResponse.statusCode == 200 else {
                print("Erro na resposta protocolo HTTP")
                return
            }
            // Tudo OK - Vamos fazer o parse do Json
            do {
                if let ipString = data {
                    print("IP retornado: \(ipString)")
                    // PARSE
                    let jsonDictionary = try
                        JSONSerialization.jsonObject(with: ipString, options: .mutableContainers)
                        as! NSDictionary
                    let origem = jsonDictionary["origin"] as! String
                    // Atualizar a Interface
                    //  Desta vez, usando Selector
                    self.performSelector(onMainThread: #selector(ViewController.updateIPLabel(_:)), with: origem, waitUntilDone: false)
                }
            } catch {
                print("Erro no parse")
            }
        })
        // 4-RESUME
        task.resume()
    }
    
    func enviarPOST() {
        // Validação do Endpoint, com guard
        guard let postURL = URL(string: postEndPoint) else {
            print("Erro na URL de requisição POST")
            return
        }
        // Seguindo os passos
        var request = URLRequest(url: postURL)
        
        let urlSession = URLSession.shared
        
        // No caso do POST, temos que definir alguns parâmetros
        let postParams: [String: Any] = ["hello": "Caelum_BR was here" , "nome" : "TIqgo" as Any]
            // Mais alguns parâmetros de configuração
            request.httpMethod = "POST"
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: postParams, options: JSONSerialization.WritingOptions())
            } catch {
                print("Erro na chamada POST")
            }
        // Pegar o retorno do servidor
        let task = urlSession.dataTask(with: request) {
            data, response, error in
            // Retorno do protocolo HTTP
            //  response = 200
            guard let realResponse = response as? HTTPURLResponse,
                realResponse.statusCode == 200 else {
                    print("Erro na resposta protocolo HTTP")
                    return }
            // Parsear o JSON de resposta
            if let postString = String(data: data!, encoding:
                String.Encoding.utf8) {
                // Atualizar a interface
                self.performSelector(onMainThread:
                    #selector(ViewController.updatePostLabel(_:)), with: postString, waitUntilDone: false)
            }
        }
        // Executar o comando
        task.resume()
    }

    // MARK: - Selectors
    // Selector do GET
    func updateIPLabel(_ text: String) {
        self.labelResultado.text = "GET - Seu IP é " + text
    }
    // SELECTOR do POST
    func updatePostLabel(_ text: String) {
        self.labelResultado.text = "POST - " + text
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

