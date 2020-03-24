//
//  ListItem.swift
//  TestSwiftUIComponents
//
//  Created by user167484 on 3/24/20.
//  Copyright © 2020 Allen Savio. All rights reserved.
//

import SwiftUI

struct ListItem: View {
    var model: Model?
    var body: some View {
        HStack {
            VStack {
                AsyncImage(urlString: model?.image, placeholder: Image("placeholder-square").resizable().frame(width: 50.0, height: 50.0, alignment: .top))
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
        ListItem()
    }
}
