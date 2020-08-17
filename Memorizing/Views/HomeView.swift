//
//  HomeView.swift
//  Memorizing
//
//  Created by Christopher Persson on 2020-07-17.
//  Copyright © 2020 Christopher Persson. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel : MemorizeViewModel
    
    @State var showingThemeProfile = false
    @State var chosenThemeItem : Theme.ThemeItem = .defaultThemeItem

    @State private var editMode = EditMode.inactive
    
    var body: some View {
        NavigationView {
            List {
                // Title line only shown in non edit mode
                if editMode == .inactive {
                    NavigationTitleRow ( name : "Theme",  currentScore: "Points", bestScore : "Highscore")
                        .font(.headline)
                }
                
                ForEach(viewModel.themeList) { themeItem in
                        NavigationLink(
                            destination: NavigationLazyView(MemorizeView(theme : themeItem))
                        ) {
                            NavigationRow ( themeProfileIsRequested  : self.$showingThemeProfile,
                                            chosenThemeItem : self.$chosenThemeItem,
                                            editMode : self.$editMode,
                                            themeItem : themeItem
                            )
                        }
                            .foregroundColor(Color(themeItem.themeColor))
                }
                .onDelete(perform: deleteLines)
                .onMove(perform: moveLines)
                
            }
            .navigationBarTitle(barTitle, displayMode: .inline)
            .navigationBarItems(leading: EditButton(), trailing: addButton)
            .environment(\.editMode, $editMode)
            .sheet(isPresented: $showingThemeProfile) {
                ThemeEditorView(isShowing : self.$showingThemeProfile, themeItem : self.chosenThemeItem)
                    .environmentObject(self.viewModel)
            }
        }
    }
    private var addButton: some View {
        switch editMode {
            case .inactive:
                return AnyView(EmptyView())
            default:
                return AnyView(Button(action: onAdd) { Image(systemName: "plus.square.on.square") })
        }
    }
    
    private var barTitle: Text {
        switch editMode {
            case .inactive:
                return Text("Memorizing Themes")
            default:
                return Text("Custom Themes")
        }
    }
    // Edit Mode functions on Theme List.
    func onAdd() {
        self.viewModel.addTheme()
    }
    func deleteLines(offsets: IndexSet) {
        withAnimation {
            self.viewModel.deleteThemes(offsets: offsets)
        }
    }
    func moveLines(from: IndexSet, to: Int) {
        withAnimation {
            self.viewModel.moveThemes(from: from, to: to)
        }
    }
}

struct NavigationLazyView<Content: View>: View {
    let follow: () -> Content
    init(_ follow:  @autoclosure @escaping () -> Content) {
        self.follow = follow
    }
    var body: Content {
        follow()
    }
}

struct NavigationRow : View {
    @Binding var themeProfileIsRequested : Bool
    @Binding var chosenThemeItem : Theme.ThemeItem
    @Binding var editMode : EditMode
    var themeItem : Theme.ThemeItem
    let frameWidth : CGFloat = 100
    
    var body: some View {
        HStack{
            Text(themeItem.themeName)
                .frame(width: frameWidth )
            // Theme editor only available in edit mode
            if editMode != .inactive {
                Image(systemName: "pencil")
                    .onTapGesture {
                            self.themeProfileIsRequested = true
                            self.chosenThemeItem = self.themeItem
                    }
                    .frame(width: frameWidth/2 )
            } else {
                Spacer()
                Text(String(themeItem.lastScore))
                    .frame(width: frameWidth )
                Spacer()
                Text(String(themeItem.bestScore))
                    .frame(width: frameWidth )
                }
        }
    }
}

// Title line of navigation list
struct NavigationTitleRow : View {
    var name : String
    var currentScore : String
    var bestScore : String
    let frameWidth : CGFloat = 100
    
    var body: some View {
        HStack{
            Text(name)
                .frame(width: frameWidth )
            Spacer()
            Text(currentScore)
                .frame(width: frameWidth )
            Spacer()
            Text(bestScore)
                .frame(width: frameWidth )
        }
    }
    
}
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(MemorizeViewModel())
    }
}
