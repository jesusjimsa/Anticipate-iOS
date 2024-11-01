//
//  ThemeManager.swift
//  Countdown-Widget
//
//  Created by Jesús Jiménez Sánchez on 1/11/24.
//

import SwiftUI

class ThemeManager: ObservableObject {
    @AppStorage("appTheme") var appTheme: AppTheme = .system {
        didSet {
            objectWillChange.send()
        }
    }

    static let shared = ThemeManager()
    private init() {}
}
