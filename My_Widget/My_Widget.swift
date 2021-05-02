

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
    var data = My_Widget()
    
    var body: some View {
        VStack {
            HStack{
                
                if Int(data.incidence)! > 150 {
                    
                Image("coronavirusRojo")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 50, alignment: .center)
                    
                }else if Int(data.incidence)! > 50 {

                    Image("coronavirusAma")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 60, height: 50, alignment: .center)
                    
                    }else {
                        
                        Image("coronavirusVerde")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 60, height: 50, alignment: .center)
                        }
                
                Text(data.name)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .foregroundColor(.white)
                    .bold()
                    
            }
            //.background(Color(.red))
            .padding(.top, 20)
            Text("Incidencia Acumulada")
                .font(.body)
                .foregroundColor(.white)
            HStack{
                Image("paciente")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20, alignment: .center)
                Text(data.incidence)
                    .font(.body)
                    .bold()
            }
           
                .foregroundColor(.white)
            Spacer(minLength: 20)
            Text(data.date)
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
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
    
   var name: String = {
            let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.jorge.infoCovid")?.appendingPathComponent("name")
           let data = try! Data(contentsOf: url!)
           let name = String(data: data, encoding: .utf8)!
            print(name)
            return name
       }()
    var incidence: String = {
             let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.jorge.infoCovid")?.appendingPathComponent("incidence")
            let data = try! Data(contentsOf: url!)
        let incidence = String(data: data, encoding: .utf8)!
             print(incidence)
             return incidence
        }()
    
    var date: String = {
             let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.jorge.infoCovid")?.appendingPathComponent("date")
            let data = try! Data(contentsOf: url!)
        let date = String(data: data, encoding: .utf8)!
             print(date)
             return date
        }()
}

struct My_Widget_Previews: PreviewProvider {
    static var previews: some View {
        My_WidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
