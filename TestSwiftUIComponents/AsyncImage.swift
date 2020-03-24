//
//  AsyncImage.swift
//  TestSwiftUIComponents
//
//  Created by user167484 on 3/24/20.
//  Copyright © 2020 Allen Savio. All rights reserved.
//

import SwiftUI
import Combine
import Foundation

struct AsyncImage<Placeholder: View>: View {
    @ObservedObject private var loader: ImageLoader
    private let placeholder: Placeholder?
    
    init(urlString: String?, placeholder: Placeholder? = nil) {
        if let string = urlString, let url = URL(string: string) {
            loader = ImageLoader(url: url)
        } else {
            let url = Bundle.main.url(forResource: "placeholder-square", withExtension: "jpg")!
            loader = ImageLoader(url: url)
        }
        
        self.placeholder = placeholder
    }

    var body: some View {
        image
            .onAppear(perform: loader.load)
            .onDisappear(perform: loader.cancel)
    }
    
    private var image: some View {
         Group {
            if loader.image != nil {
                Image(uiImage: loader.image!).resizable()
                    .frame(width: 50.0, height: 50.0, alignment: .topLeading)
            } else {
                placeholder
            }
        }
    }
}

struct AsyncImage_Previews: PreviewProvider {
    static var previews: some View {
        AsyncImage(urlString: Bundle.main.path(forResource: "placeholder-square", ofType: "jpg")!, placeholder: Text("Load"))
    }
}

class ImageLoader: ObservableObject {
    @Published var image: UIImage? = nil
    private let url: URL
    private var cancellable: AnyCancellable?

    init(url: URL) {
        self.url = url
    }
    
    func load() {
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: self)
    }

    func cancel() {
        cancellable?.cancel()
    }
}
