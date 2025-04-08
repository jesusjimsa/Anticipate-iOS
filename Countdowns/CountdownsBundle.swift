//
//  CountdownsBundle.swift
//  Countdowns
//
//  Created by Jesús Jiménez Sánchez on 8/4/25.
//

import WidgetKit
import SwiftUI

@main
struct CountdownsBundle: WidgetBundle {
    var body: some Widget {
        Countdowns()
        CountdownsControl()
    }
}
