//
//  SettingsView.swift
//  Countdown-Widget
//
//  Created by Jesús Jiménez Sánchez on 2/4/24.
//

import SwiftUI
import StoreKit

struct SettingsView: View {
    let email = "jesusjimsa@icloud.com"
    @StateObject private var themeManager = ThemeManager.shared
    @State private var products: [Product] = []
    @State private var errorMessage: String?
    @State private var isLoading = false
    
    @AppStorage("aiEnabled") var aiEnabled: Bool = false
    
    @Environment(\.supportsImagePlayground) private var supportsImagePlayground

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

                let aiTextExplanation = supportsImagePlayground ?
                    "Enabling this setting adds an option to use Image Playground to generate an image for the countdown.\nIt uses Apple Intelligence, so everything is processed on your device, unless you choose the ChatGPT option." : ""
                Section(
                    header: Text("General"),
                    footer: Text(aiTextExplanation)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                ) {
                    Picker("🌓 Theme", selection: $themeManager.appTheme) {
                        ForEach(AppTheme.allCases, id: \.self) { theme in
                            Text(theme.rawValue).tag(theme)
                        }
                    }
                    
                    if supportsImagePlayground {
                        Toggle(isOn: $aiEnabled) {
                            Text("✨ Enable AI image generation")
                        }
                    }
//                    Text("📱 App icon")
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

                    Link(destination: URL(string: "https://bsky.app/profile/jesusjimsa.bsky.social")!, label: {
                        Text("🦋 Bluesky")
                    })

                    Link(destination: URL(string: "https://github.com/jesusjimsa/Countdown-Widget-iOS")!, label: {
                        Text("🤓 Source code for this app")
                    })
                    
                    Link(destination: URL(string: "https://github.com/jesusjimsa/Anticipate-iOS/blob/master/Terms.md")!,
                         label: {
                        Text("📄 Terms of Use")
                    })

                    Link(destination: URL(string: "https://github.com/jesusjimsa/Anticipate-iOS/blob/master/PRIVACY.md")!,
                         label: {
                        Text("🔒 Privacy")
                    })
                }

                Section(header: Text("💰 Tip Jar")) {
                    VStack {
                        ProductView(id: "small_tip")
                            .productViewStyle(.compact)
                        ProductView(id: "medium_tip")
                            .productViewStyle(.compact)
                        ProductView(id: "big_tip")
                            .productViewStyle(.compact)
                        ProductView(id: "huge_tip")
                            .productViewStyle(.compact)
                        ProductView(id: "mega_tip")
                            .productViewStyle(.compact)
                    }
                    
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
