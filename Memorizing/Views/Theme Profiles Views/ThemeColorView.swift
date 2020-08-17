//
//  ThemeColorView.swift
//  Memorizing
//
//  Created by Christopher Persson on 2020-07-17.
//  Copyright © 2020 Christopher Persson. All rights reserved.
//

import SwiftUI
import ColorPicker

struct ThemeColorView: View {
    @Binding var uiColor : UIColor
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color(uiColor.rgba))
                .frame(width: 40, height: 40)
                
                ColorPicker(color: self.$uiColor, strokeWidth: 30)
                    .frame(width: 150, height: 150, alignment: .center)
                
        }
    }
}

struct ThemeColorView_Previews: PreviewProvider {
    static var previews: some View {
        ThemeColorView(uiColor: .constant(UIColor(UIColor.RGBA(red: 1.011, green: 0.330, blue: -0.003, alpha: 1.0))))
    }
}
