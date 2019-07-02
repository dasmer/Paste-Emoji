//
//  OptionsView.swift
//  Paste
//
//  Created by Dasmer Singh on 7/2/19.
//  Copyright © 2019 Dastronics Inc. All rights reserved.
//

import SwiftUI

struct OptionsView : View {
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Button(action: {
                        
                    }) {
                        HStack {
                            Text("Share with Friends")
                            Spacer()
                            Text("👯‍♂️")
                        }
                    }
                    Button(action: {
                        
                    }) {
                        HStack {
                            Text("Rate on the App Store")
                            Spacer()
                            Text("⭐️")
                        }
                    }
                    Button(action: {
                        
                    }) {
                        HStack {
                            Text("Send Feedback")
                            Spacer()
                            Text("📧")
                        }
                    }
                    }
                    .listStyle(.grouped)
            }.navigationBarTitle(Text("Options"), displayMode: .inline)
        }
    }
}

#if DEBUG
struct OptionsView_Previews : PreviewProvider {
    static var previews: some View {
        OptionsView()
    }
}
#endif
