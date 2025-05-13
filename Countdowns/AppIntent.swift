//
//  AppIntent.swift
//  Countdowns
//
//  Created by Jesús Jiménez Sánchez on 8/4/25.
//

import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "Configuration" }
    static var description: IntentDescription { "This is an example widget." }

    // An example configurable parameter.
    @Parameter(title: "Countdown")
    var countdown: CountdownEntity?
    
    init(countdown: CountdownEntity) {
        self.countdown = countdown
    }
    
    init() {
        
    }
}
