//
//  MemorizeView.swift
//  Memorizing
//
//  Created by Christopher Persson on 2020-07-17.
//  Copyright © 2020 Christopher Persson. All rights reserved.
//

import SwiftUI

struct MemorizeView: View, Identifiable {
    var id : UUID
    
    
    @EnvironmentObject var viewModel : MemorizeViewModel
    
    var theme : Theme.ThemeItem
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    private var backButton : some View { Button(action: {
            self.viewModel.storeScore(theme : self.theme)
            self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "hand.point.left.fill") // set image here
                    .aspectRatio(contentMode: .fit)
                Text("Back")
            }
        }
    }
    //Button to the navigation bar that starts a new game
    private var newGameButton: some View {
        Button(action: {
            self.viewModel.storeScore(theme : self.theme)
            withAnimation(.easeInOut(duration: 1.5)){
                self.viewModel.newGame(theme : self.theme)
            }
            })
        {
            HStack {
            Text("New")
            Image(systemName: "hand.point.right.fill")
                .aspectRatio(contentMode: .fit)
            }
        }
    }
   
    var body: some View {
        VStack {
            
            GridView(viewModel.cards) { card in
                    CardView(card : card)
                        .onTapGesture {
                            withAnimation(.linear(duration : 0.75)) {
                                self.viewModel.chooseCard(card: card)
                            }
                        }
            .padding(5)
            }
            
            HStack {
                Text ("Points: " + String(viewModel.gameScore))
                Spacer()
                Text ("Number of moves: " + String(viewModel.flipCount))
            }
        }
            .padding()
            .navigationBarTitle(Text(self.theme.themeName), displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: backButton, trailing: newGameButton )
            .foregroundColor(Color(self.theme.themeColor))
            .onAppear(){self.viewModel.newGame(theme: self.theme)}
    }
    
    init(theme : Theme.ThemeItem) {
        self.theme = theme
        self.id = UUID()
    }
    
}

struct MemorizeView_Previews: PreviewProvider {
    static var previews: some View {
        MemorizeView(theme : Theme().themeList[0]).environmentObject(MemorizeViewModel())
    }
}
