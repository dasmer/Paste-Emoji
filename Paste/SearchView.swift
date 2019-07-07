//
//  SearchView.swift
//  Paste
//
//  Created by Dasmer Singh on 6/29/19.
//  Copyright © 2019 Dastronics Inc. All rights reserved.
//
import SwiftUI
import EmojiKit
import SVProgressHUD

// Emoji must be Identifiable to populate the List
extension Emoji: Identifiable {}

struct SearchView: View {

    // MARK: - Properties

    @EnvironmentObject var emojiStore: EmojiStore
    @State var isOptionsPresented = false

    // MARK: - View

    var body: some View {

        NavigationView {
            VStack {
                // Search View
                TextField($emojiStore.searchText,
                          placeholder: Text("Type an emoji name to search"))
                    .padding()
                Rectangle()
                    .frame(height: 1)

                // Emoji Results List
                List (emojiStore.results) { emoji in
                    EmojiButtonView(emoji: emoji).environmentObject(self.emojiStore)
                }
                } // Navigation Bar Settings
                .navigationBarTitle(Text("Emoji Search"), displayMode: .inline)
                .navigationBarItems(leading:
                    Button(action: { self.isOptionsPresented = true
                    }, label: {
                        Text("☰")
                    })
            )
            } .presentation(isOptionsPresented ? Modal(
                OptionsView(dismissAction: {
                    self.isOptionsPresented = false
                }), onDismiss: {
                    self.isOptionsPresented.toggle()
            }) : nil)
    }

}


#if DEBUG
struct SearchView_Previews : PreviewProvider {
    static var previews: some View {
        SearchView().environmentObject(EmojiStore())
    }
}
#endif


struct EmojiButtonView : View {

    // MARK: - Properties

    let emoji: Emoji
    @EnvironmentObject var emojiStore: EmojiStore

    // MARK: - View

    var body: some View {
        return Button(action: {
            UIPasteboard.general.string = self.emoji.character
            SVProgressHUD.showSuccess(withStatus: "Copied \(self.emoji.character)")
            self.emojiStore.didTap(emoji: self.emoji)
        }) {
            HStack {
                Text(self.emoji.character)
                Spacer()
                Text(self.emoji.name)
            }
        }
    }
}


struct OptionsView : View {

    // MARK: - Properties

    let dismissAction: (() -> Void)

    // MARK: - View

    var body: some View {
        return NavigationView {
            ControllerPage<OptionsViewController>()
                .navigationBarTitle(Text("Options"), displayMode: .inline)
                .navigationBarItems(leading:
                    Button(action: dismissAction, label: {
                        Text("Cancel")
                    })
            )
        }
    }
}
