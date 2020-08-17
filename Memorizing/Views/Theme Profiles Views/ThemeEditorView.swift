//
//  ThemeEditorView.swift
//  Memorizing
//
//  Created by Christopher Persson on 2020-07-17.
//  Copyright © 2020 Christopher Persson. All rights reserved.
//

import SwiftUI

struct ThemeEditorView: View {
    @EnvironmentObject var viewModel : MemorizeViewModel
    @Binding var isShowing : Bool
    @State var themeItem : Theme.ThemeItem
    
    @State var emojisToAdd : String  = ""
    @State var maxNoOfPairsOfCards = Theme.ThemeItem.maxNoOfPairsOfCards
    @State var uiColor : UIColor = UIColor.clear
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Spacer()
            // Conrol section for storing and cancelling changes
            HStack {
                Spacer(minLength: 5)
                Button("Cancel") {
                        self.isShowing = false
                }
                Spacer(minLength: 60)
                Text("Theme editor").bold()
                Spacer(minLength: 60)
                // Leave the edit mod, and store the changes
                Button("Done") {
                    self.themeItem.themeUIColor = self.uiColor
                    self.viewModel.storeThemeItem(theme : self.themeItem)
                    self.isShowing = false
                }
                Spacer(minLength: 5)
            }
            
            Form {
                HStack {
                    Text("Theme name: ").bold()
                    Divider()
                    TextField("Theme name", text: $themeItem.themeName)
                }
                HStack {
                    Text("Color: ").bold()
                    Divider()
                    HStack {
                        Spacer()
                        ThemeColorView(uiColor: $uiColor)
                        Spacer()
                    }
                }
                Section(header : Text("Limits")) {
                    HStack {
                        Text("Number of pairs:").bold()
                        Divider()
                        Stepper("\(themeItem.noOfPairsOfCards)", value: $themeItem.noOfPairsOfCards, in: 1...self.maxNoOfPairsOfCards)
                    }
                    HStack {
                        Text("Time limit(sec):").bold()
                        Divider()
                        Stepper("\(themeItem.bonusTimeLimit)", value: $themeItem.bonusTimeLimit, in: 1...Theme.ThemeItem.maxBonusTimeLimit)
                    }
                }

                Section (header : Text("Emojis")) {
                    TextField("Emojis added", text : $emojisToAdd, onEditingChanged : { began in
                        if !began {
                            self.themeItem.themeEmojis = self.themeItem.themeEmojis + self.emojisToAdd
                            self.maxNoOfPairsOfCards = self.maxNoOfPairsOfCards + self.emojisToAdd.count
                            self.themeItem.noOfPairsOfCards = self.themeItem.noOfPairsOfCards + self.emojisToAdd.count
                            
                            self.emojisToAdd = ""
                            }
                        }
                    )

                    VStack {
                        HStack {
                            Text("Delete emojis:").bold()
                            Spacer()
                        }
                        GridView(themeItem.themeEmojis.map { String($0) }, id: \.self) { emoji in
                            Text(emoji)
                             .font(Font.system(size : 40))
                             .onTapGesture {
                                self.themeItem.themeEmojis = self.themeItem.themeEmojis.replacingOccurrences(of: emoji, with: "")
                                if self.themeItem.themeEmojis.count == 0 {
                                    self.themeItem.themeEmojis = Theme.ThemeItem.noEmojis
                                }
                                self.maxNoOfPairsOfCards = min(self.maxNoOfPairsOfCards, self.themeItem.themeEmojis.count)
                                if self.themeItem.noOfPairsOfCards > self.maxNoOfPairsOfCards {
                                    self.themeItem.noOfPairsOfCards = self.maxNoOfPairsOfCards
                                }
                         }
                     }
                        .frame(width : 300, height : 200 )
                    }
                }
            }
            .onAppear {
                self.maxNoOfPairsOfCards = min(self.maxNoOfPairsOfCards, self.themeItem.themeEmojis.count)
                if self.themeItem.noOfPairsOfCards > self.maxNoOfPairsOfCards{
                    self.themeItem.noOfPairsOfCards = self.maxNoOfPairsOfCards
                }
                self.uiColor = self.themeItem.themeUIColor
            }
        }
    }
}

struct ThemeEditorView_Previews: PreviewProvider {
    static var previews: some View {
        ThemeEditorView(isShowing: Binding.constant(true), themeItem: .defaultThemeItem)
    }
}
