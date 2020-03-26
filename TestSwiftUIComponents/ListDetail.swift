//
//  ListDetail.swift
//  TestSwiftUIComponents
//
//  Created by user167484 on 3/26/20.
//  Copyright © 2020 Allen Savio. All rights reserved.
//

import SwiftUI

struct ListDetail: View {
    @State private var showShareSheet = false
    
    var model: Model?
    var cache: ImageCache
    var url: URL
    
    init(model: Model? = nil, cache: ImageCache) {
        self.cache = cache
        self.model = model
        if let imageHref = model?.image, let url = URL(string: imageHref) {
            self.url = url
        } else {
            self.url = Bundle.main.url(forResource: "placeholder-square", withExtension: "jpg")!
        }
        
    }
    
    var body: some View {
        VStack {
            ScrollView {
                Text(model?.title ?? "").fontWeight(.medium)
                
                Group {
                    if cache[self.url] != nil {
                        Image(uiImage: cache[self.url]!).resizable()
                            .aspectRatio(1, contentMode: .fit)
                    } else {
                        Image("placeholder-square").resizable().aspectRatio(1, contentMode: .fit)
                    }
                }
                Text(model?.desc ?? "")
            }.navigationBarItems(trailing: Button(action: {
                self.showShareSheet = true
            }, label: {
                Text("Share")
            })).sheet(isPresented: $showShareSheet) { 
                ShareSheet(activityItems: [self.model?.desc ?? ""])
            }
        }
    }
}

struct ListDetail_Previews: PreviewProvider {
    static var previews: some View {
        ListDetail(cache: TemporaryImageCache())
    }
}
