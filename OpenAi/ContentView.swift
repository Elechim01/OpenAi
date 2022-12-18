//
//  ContentView.swift
//  OpenAi
//
//  Created by Michele Manniello on 18/12/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        
        VStack {
            Text("Richiesta da fare all' AI")
                .font(.title)
            Menu("Cambia l'AI") {
                ForEach(viewModel.listAI.sorted(by: <),id:\.key) { key,value in
                    Button {
                        viewModel.urlSelected = key
                    } label: {
                        HStack {
                            Text(key)
                            if key == viewModel.urlSelected{
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            }
            .padding()
            
            TextField("Richiesta", text: $viewModel.textRequest)
                .padding()
                .overlay {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .stroke(Color(UIColor.systemGray4),lineWidth: 2)
                }
                .onSubmit {
                    viewModel.openAI()
                }
            
            Text(viewModel.text)
            
            Spacer()
        }
        .padding()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
