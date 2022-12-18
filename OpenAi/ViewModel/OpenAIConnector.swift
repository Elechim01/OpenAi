//
//  OpenAIConnector.swift
//  OpenAi
//
//  Created by Michele Manniello on 18/12/22.
//

import Foundation

class OpenAIConnector{
    let openAIURL:URL
    var openAIKey:String
    
    init(openAIURL: URL, openAIKey: String) {
        self.openAIURL = openAIURL
        self.openAIKey = openAIKey
    }
    
    private func executeRequest(request: URLRequest, withSessionConfing sessionConfig:URLSessionConfiguration?)->Data?{
        let semaphone = DispatchSemaphore(value: 0)
        let session:URLSession
        
        if sessionConfig != nil{
            session = URLSession(configuration: sessionConfig!)
        }else{
            session = URLSession.shared
        }
        
        var requestData: Data?
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil{
                print("error:\(error!.localizedDescription)")
            }else{
                requestData = data
            }
            print("Semaphore signalled")
            semaphone.signal()
        }
        task.resume()
        
        let timeOut = DispatchTime.now() + .seconds(20)
        print("Waiting for semaphone signal")
        let retVal = semaphone.wait(timeout: timeOut)
        print("Done waiting, optained -\(retVal)")
        return requestData
    }
    
    func processPrompt(prompt:String) -> OpenAIResponse?{
        var request = URLRequest(url: openAIURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(openAIKey)", forHTTPHeaderField: "Authorization")
        let body : [String:Any] = [
            "prompt":prompt,
//            "model": "davinci-it",
            "max_tokens":100
        ]
        var httpBodyJson: Data
        do {
            httpBodyJson = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
            
        } catch  {
            print(error.localizedDescription)
            return nil
        }
        request.httpBody = httpBodyJson
        if let requestData = executeRequest(request: request, withSessionConfing: nil){
            let jsonStr = String(data: requestData, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
            print(jsonStr)
            let json = jsonStr.data(using: .utf8)!
            do {
                let product = try JSONDecoder().decode(OpenAIResponse.self, from: json)
                return product
            } catch {
                print(error.localizedDescription)
                return nil
            }
        }
        
        return nil
    }
    
    
    
}
