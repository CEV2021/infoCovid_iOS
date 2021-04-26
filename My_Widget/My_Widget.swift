//
//  My_Widget.swift
//  My_Widget
//
//  Created by daniel on 26/04/2021.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct My_WidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack {
            HStack{
                Image("coronaVerde")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 50, alignment: .center)
                Text("Madrid")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .foregroundColor(.white)
                    .bold()
                    
            }
            //.background(Color(.red))
            .padding(.top, 20)
            Text("Casos activos")
                .font(.body)
                .foregroundColor(.white)
            HStack{
                Image("paciente")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20, alignment: .center)
                Text("10200")
                    .font(.body)
                    .bold()
            }
           
                .foregroundColor(.white)
            Spacer(minLength: 20)
            Text("Actual 24/1 17:15")
                .font(.footnote)
                .foregroundColor(.white)
        }
        .background(Color("background")
                        .scaledToFill()
                        .ignoresSafeArea()
        )
    }
}

@main
struct My_Widget: Widget {
    let kind: String = "My_Widget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            My_WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct My_Widget_Previews: PreviewProvider {
    static var previews: some View {
        My_WidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
