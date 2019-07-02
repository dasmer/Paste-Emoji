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

    @EnvironmentObject var emojiStore: EmojiStore
    @State var isOptionsPresented = false

    var body: some View {

        NavigationView {
            VStack {
                TextField($emojiStore.searchText,
                          placeholder: Text("Type an emoji name to search"))
                    .padding()
                Rectangle()
                    .frame(height: 1)
                List (emojiStore.results) { emoji in
                    Button(action: {
                        UIPasteboard.general.string = emoji.character
                        SVProgressHUD.showSuccess(withStatus: "Copied \(emoji.character)")
                        self.emojiStore.didTap(emoji: emoji)
                    }) {
                        HStack {
                            Text(emoji.character)
                            Spacer()
                            Text(emoji.name)
                        }
                    }
                }
                }
                .navigationBarTitle(Text("Emoji Search"), displayMode: .inline)
                .navigationBarItems(leading:
                    Button(action: { self.isOptionsPresented = true
                    }, label: {
                        Text("☰")
                    })
            )
            } .presentation(isOptionsPresented ? Modal(
                NavigationView {
                    ControllerPage<OptionsViewController>()
                        .navigationBarTitle(Text("Options"), displayMode: .inline)
                        .navigationBarItems(leading:
                            Button(action: { self.isOptionsPresented = false
                            }, label: {
                                Text("Cancel")
                            })
                    )
                }
                , onDismiss: {
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
