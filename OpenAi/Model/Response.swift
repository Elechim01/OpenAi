//
//  OpenAIResponse.swift
//  OpenAi
//
//  Created by Michele Manniello on 18/12/22.
//

import Foundation
struct OpenAIResponse:Codable {
    var id: String
    var object:String
    var created:Int
    var model:String
    var choices:[Choices]
    var usage: Usage
    
}


struct Choices:Codable {
    var text:String
    var index:Int
    var logprobs:String?
    var finish_reason:String
}

struct Usage:Codable {
    var prompt_tokens:Int
    var completion_tokens:Int
    var total_tokens:Int
}
