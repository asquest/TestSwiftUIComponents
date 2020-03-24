//
//  ContentView.swift
//  TestSwiftUIComponents
//
//  Created by user167484 on 3/23/20.
//  Copyright © 2020 Allen Savio. All rights reserved.
//

import SwiftUI
import Combine

struct ContentView: View {
    @ObservedObject private var dataLoader: DataLoader
    var url: URL = Bundle.main.url(forResource: "data", withExtension: "json")!
    
    init() {
        dataLoader = DataLoader(url: url)
    }
    
    var body: some View {
        list.onAppear(perform: dataLoader.load)
            .onDisappear(perform: dataLoader.cancel)
    }
    
    private var list: some View {
        VStack {
            List(dataLoader.dataModel?.data ?? [], id: \.self) { model in
                    ListItem(model: model)
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

class DataLoader: ObservableObject {
    @Published var dataModel: DataModel?
    private let url: URL
    private var cancellable: AnyCancellable?

    init(url: URL) {
        self.url = url
    }
    
    func load() {
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { try? JSONDecoder().decode(DataModel.self, from: $0.data) }
            .replaceError(with: nil)
            .handleEvents(receiveOutput: { (dataModel) in
                print(dataModel?.title)
                print(dataModel?.data)
            })
            .receive(on: DispatchQueue.main)
            .assign(to: \.dataModel, on: self)
    }

    func cancel() {
        cancellable?.cancel()
    }
}

