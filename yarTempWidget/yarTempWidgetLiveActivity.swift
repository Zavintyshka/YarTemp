//
//  yarTempWidgetLiveActivity.swift
//  yarTempWidget
//
//  Created by Вадим Соснин on 4/13/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct yarTempWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct yarTempWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: yarTempWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension yarTempWidgetAttributes {
    fileprivate static var preview: yarTempWidgetAttributes {
        yarTempWidgetAttributes(name: "World")
    }
}

extension yarTempWidgetAttributes.ContentState {
    fileprivate static var smiley: yarTempWidgetAttributes.ContentState {
        yarTempWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: yarTempWidgetAttributes.ContentState {
         yarTempWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: yarTempWidgetAttributes.preview) {
   yarTempWidgetLiveActivity()
} contentStates: {
    yarTempWidgetAttributes.ContentState.smiley
    yarTempWidgetAttributes.ContentState.starEyes
}
