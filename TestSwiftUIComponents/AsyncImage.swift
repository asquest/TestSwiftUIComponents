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
    
    init(url: URL, placeholder: Placeholder? = nil, cache: ImageCache? = nil) {
        loader = ImageLoader(url: url, cache: cache)
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
            } else {
                placeholder
            }
        }
    }
}

struct AsyncImage_Previews: PreviewProvider {
    static var previews: some View {
        AsyncImage(url: Bundle.main.url(forResource: "placeholder-square", withExtension: "jpg")!, placeholder: Text("Load"))
    }
}

class ImageLoader: ObservableObject {
    @Published var image: UIImage? = nil
    
    private let url: URL
    private var cache: ImageCache?
    
    private var cancellable: AnyCancellable?
    
    private(set) var isLoading = false
    private static let imageProcessingQueue = DispatchQueue(label: "image-processing")

    init(url: URL, cache: ImageCache? = nil) {
        self.url = url
        self.cache = cache
    }
    
    func load() {
        guard !isLoading else { return }
        
        if let image = cache?[url] {
            self.image = image
            return
        }
        
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: Self.imageProcessingQueue)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .handleEvents(receiveSubscription: { [unowned self] _ in self.onStart() },
                          receiveOutput: { [unowned self] in self.cache?[self.url] = $0 },
                          receiveCompletion: { [unowned self] _ in self.onFinish() },
                          receiveCancel: { [unowned self] in self.onFinish() })
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: self)
    }

    private func onStart() {
        isLoading = true
    }
    
    private func onFinish() {
        isLoading = false
    }
    
    func cancel() {
        cancellable?.cancel()
    }
}

