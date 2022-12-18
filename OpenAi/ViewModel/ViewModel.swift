//
//  ViewModel.swift
//  OpenAi
//
//  Created by Michele Manniello on 18/12/22.
//

import Foundation
class ViewModel: ObservableObject {
    
    @Published var text = ""
    @Published var textRequest = ""
    @Published var listAI : [String:String] = [
        "Davinci":"https://api.openai.com/v1/engines/text-davinci-003/completions",
        "Curie":"https://api.openai.com/v1/engines/text-curie-001/completions",
        "Babbage":"https://api.openai.com/v1/engines/text-babbage-001/completions",
        "Ada":"https://api.openai.com/v1/engines/text-ada-001/completions"
    ]
    
    @Published var urlSelected = "Davinci"
    
    private var apiKey : String = ""
    
    init(){
        #warning("se la repo viene scaricata creare un file config.plist che conentente la chiave nella voce API_KEY")
        guard let path = Bundle.main.path(forResource: "config", ofType: "plist") else { return  }
        do {
            let dict = try NSDictionary(contentsOf: URL(filePath: path), error: (print("Errore"))) as? [String: AnyObject]
            apiKey = dict!["API_KEY"] as! String
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    
    func openAI() {
        print(urlSelected)
        if apiKey.isEmpty{ return}
        let openAIConnector = OpenAIConnector(openAIURL: URL(string: listAI[urlSelected]!)!, openAIKey: apiKey)
        let response = openAIConnector.processPrompt(prompt: textRequest)
        if response != nil{
            text = response?.choices.first?.text ?? ""
        }
    }
}
