//
//  GridView.swift
//  Memorizing
//
//  Created by Christopher Persson on 2020-07-17.
//  Copyright © 2020 Christopher Persson. All rights reserved.
//

import SwiftUI

struct GridView<Item, ID, ItemView>: View where ID : Hashable, ItemView : View {
    private var items : [Item]
    private var viewForItems : (Item) -> ItemView
    private var id : KeyPath <Item ,ID >
   
    //Will find a layout to fit for the space we have.
    var body: some View {
        GeometryReader{ geometry in
            self.body(for : GridLayout(itemCount : self.items.count,  in : geometry.size))
        }
    }

    private func body(for layout : GridLayout) -> some View {
        ForEach(items, id : id) { item in
            self.body(for : item, in : layout)
        }
    }
    
    private func body(for item : Item, in layout : GridLayout) -> some View {
        let index = items.firstIndex(where : {item[keyPath : id] == $0[keyPath : id]})!
        return viewForItems(item)
            .frame(width: layout.itemSize.width, height: layout.itemSize.height)
            .position (layout.location(ofItemAt: index))
    }
    
    // func not called in init therefore i'm using @escaping
    init ( _ items : [Item], id : KeyPath <Item ,ID >, viewForItems : @escaping (Item) -> ItemView){
        self.items = items
        self.id = id
        self.viewForItems = viewForItems
    }
}

extension GridView where Item : Identifiable, ID == Item.ID {
     init ( _ items : [Item], viewForItems : @escaping (Item) -> ItemView){
        self.init(items, id : \Item.id, viewForItems : viewForItems)
    }
}
