//
//  ListItem.swift
//  TestSwiftUIComponents
//
//  Created by user167484 on 3/24/20.
//  Copyright © 2020 Allen Savio. All rights reserved.
//

import SwiftUI

struct ListItem: View {
    private var model: Model?
    var url: URL
    var cache: ImageCache
    
    init(model: Model? = nil, cache: ImageCache) {
        if let imageHref = model?.image, let url = URL(string: imageHref) {
            self.url = url
        } else {
            self.url = Bundle.main.url(forResource: "placeholder-square", withExtension: "jpg")!
        }
        self.model = model
        self.cache = cache
    }
    
    var body: some View {
        HStack {
            VStack {
                AsyncImage(url: url, placeholder: Image("placeholder-square").resizable(), cache: cache).frame(width: 75.0, height: 75.0, alignment: .topLeading).aspectRatio(1, contentMode: .fit)
            }
            VStack(alignment: .leading) {
                Text(model?.title ?? "").fontWeight(.medium)
                Text(model?.desc ?? "")
            }
        }
    }
}

struct ListItem_Previews: PreviewProvider {
    static var previews: some View {
        ListItem(cache: TemporaryImageCache())
    }
}
