//
//  SettingsView.swift
//  Countdown-Widget
//
//  Created by Jesús Jiménez Sánchez on 7/5/24.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    let email = "jesusjimsa@icloud.com"

    var body: some View {
        NavigationStack {
            List {
//                    Section {
//                        HStack {
//                            Spacer()
//                            Image("first_icon")
//                                .resizable()
//                                .scaledToFit()
//                                .frame(width: 128, height: 128)
//                            Spacer()
//                        }
//                    }

                Section(header: Text("General")) {
                    // NavigationLink(destination: /* Text 상세 보기 View */) {
                    //        Text("Theme")
                    //   }
                    //  NavigationLink(destination: /* Text 상세 보기 View */) {
                    //      Text("App Icon")
                    // }

                        Text("🌓 Theme")
                    NavigationLink(destination: IconsListView()) {
                        Text("📱 App icon")
                    }
                }
                Section(header: Text("About")) {
                    Link(destination: URL(string: "mailto:\(email)")!, label: {
                        Text("✉️ Email the developer")
                    })

                    Link(destination: URL(string: "twitter://user?screen_name=jesusjimsa")!, label: {
                        Text("🐣 Send me a tweet")
                    })
                    .onOpenURL(perform: { url in
                      // If Twitter app can't handle the URL, open in Safari
                      if UIApplication.shared.canOpenURL(url) {
                        return
                      }
                      UIApplication.shared.open(URL(string: "https://twitter.com/jesusjimsa")!)
                    })

                    Link(destination: URL(string: "https://mastodon.world/@jesusjimsa")!, label: {
                        Text("🐘 Mastodon")
                    })

                    Link(destination: URL(string: "https://github.com/jesusjimsa/Countdown-Widget-iOS")!, label: {
                        Text("🤓 Source code for this app")
                    })
                }
                Section() {
                    Text("💰 Tip Jar")
                }
            }
            .navigationTitle("Settings")
            .listStyle(InsetGroupedListStyle())

        }
    }
}

#Preview {
    SettingsView()
}
