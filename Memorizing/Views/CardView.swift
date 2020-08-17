//
//  CardView.swift
//  Memorizing
//
//  Created by Christopher Persson on 2020-07-17.
//  Copyright © 2020 Christopher Persson. All rights reserved.
//

import SwiftUI

// A view of a single card
struct CardView : View {
    var card : ModelType.Card

    private let scale_factor : CGFloat = 0.7
    
    private func fontSize(for size : CGSize) -> CGFloat {
        self.scale_factor * min(size.width, size.height)
    }
    
    var body: some View {
        GeometryReader{ geometry in
            self.body(for : geometry.size)
        }
    }
   
    @State private var animatedBonusRemaining : Double = 0
    
    private func startBonusTimeAnimation() {
        animatedBonusRemaining = card.bonusRemaining
        withAnimation(.linear(duration : card.bonusTimeRemaining)){
            animatedBonusRemaining = 0
        }
    }
    
    @ViewBuilder
    private func body (for size : CGSize) -> some View {
        if card.isFaceUp || !card.isMatched {
            
            ZStack {
                Group {
                    // animated pie
                    if card.isConsumingBonusTime {
                        PieLayout(startAngle: Angle(degrees : 0 - 90), endAngle: Angle(degrees : -animatedBonusRemaining * 360 - 90.0), clockwise : true)
                            .onAppear {
                                self.startBonusTimeAnimation()
                            }
                    } else {
                        // static pie counting
                        PieLayout(startAngle: Angle(degrees : 0 - 90), endAngle: Angle(degrees : -card.bonusRemaining * 360 - 90.0), clockwise : true)
                    }
                }
                    .padding(3)
                    .opacity(0.4)
                Text(card.content)
                    .font(Font.system(size: self.fontSize(for : size)))
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                    .animation(card.isMatched ? Animation.linear(duration : 1.0).repeatForever(autoreverses : false) : .default)
            }
                .cardify(isFaceUp : card.isFaceUp)
                .transition(AnyTransition.scale)
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card : ModelType.Card(isFaceUp : true, content : "👻", bonusTimeLimit: 7))
            .padding(5)
            .foregroundColor(Color.orange)
            .aspectRatio(2/3, contentMode: .fit)
    }
}
