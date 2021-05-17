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
    // Variable con la que pasamos los datos de la app al widget
    var data = My_Widget()
    @Environment(\.widgetFamily) var family
    
    @ViewBuilder
    var body: some View {
        switch family {
        case .systemSmall:
            VStack {
                Spacer(minLength: 25)
                ZStack{
                    if Int(data.incidence)! > 150 {
                        Image("coronavirusRojo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 70, height: 70, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    }
                    else if Int(data.incidence)! > 50 {
                        Image("coronavirusAma")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 70, height: 70, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    }
                    else {
                        Image("coronavirusVerde")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 70, height: 70, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    }
                    StrokeText(text: data.name, width: 1, color: .black)
                        .font(.title3)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth:100)
                        .shadow(color: .black, radius: 5, x: 5, y: 5)
                        .minimumScaleFactor(0.3)
                        .scaledToFill()
                    
                    
                }
                Text("Incidencia acumuldada:")
                    .font(.custom("Helvetica Neue", size: 12))
                    .foregroundColor(.white)
                    .bold()
                HStack{
                    Image("paciente")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                    Text(data.incidence)
                        .font(.body)
                        .bold()
                }
                .foregroundColor(.white)
                Spacer(minLength: 10)
                Text(data.date)
                    .foregroundColor(.white)
                    .padding(.bottom, 20)
                    .font(.custom("Helvetica Neue", size: 8))
                
            }
            .frame(maxWidth: 400, maxHeight: 400)
            .background(Color("background")
            )
            
        case .systemMedium:
            VStack {
                Spacer(minLength: 30)
                HStack{
                    if Int(data.incidence)! > 150 {
                        Image("coronavirusRojo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    }
                    else if Int(data.incidence)! > 50 {
                        Image("coronavirusAma")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    }
                    else {
                        Image("coronavirusVerde")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 60, height: 60, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    }
                    Text(data.name)
                        .font(.title)
                        .foregroundColor(.white)
                        .bold()
                        .scaledToFill()
                        .padding(.trailing, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                    
                    
                }
                Text("Incidencia acumuldada:")
                    .font(.custom("Helvetica Neue", size: 15))
                    .foregroundColor(.white)
                    .bold()
                HStack{
                    Image("paciente")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 20)
                    Text(data.incidence)
                        .font(.title3)
                        .bold()
                }
                .foregroundColor(.white)
                Text(data.date)
                    .foregroundColor(.white)
                    .padding(.bottom, 25)
                    .font(.custom("Helvetica Neue", size: 10))
                
            }
            .frame(maxWidth: 400, maxHeight: 400)
            .background(Color("background")
            )
        case .systemLarge:
            VStack {
                Spacer()
                if Int(data.incidence)! > 150 {
                    Image("coronavirusRojo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                }
                else if Int(data.incidence)! > 50 {
                    Image("coronavirusAma")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                }
                else {
                    Image("coronavirusVerde")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 150, height: 150, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                }
                Text(data.name)
                    .font(.title2)
                    .foregroundColor(.white)
                    .bold()
                    .scaledToFill()
                    .padding(.bottom, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                Text("Incidencia acumuldada:")
                    .font(.custom("Helvetica Neue", size: 15))
                    .foregroundColor(.white)
                    .bold()
                HStack{
                    Image("paciente")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                    Text(data.incidence)
                        .font(.title2)
                        .bold()
                }
                .foregroundColor(.white)
                Spacer(minLength: 10)
                Text(data.date)
                    .foregroundColor(.white)
                    .padding(.bottom, 20)
                    .font(.custom("Helvetica Neue", size: 10))
                
            }
            .frame(maxWidth: 400, maxHeight: 400)
            .background(Color("background")
            )        @unknown default:
                Text("No se ha podido cargar el widget")
        }
        
    }


}

// Estructura con la que le damos un borde al texto en la imagen pequeña
struct StrokeText: View {
    let text: String
    let width: CGFloat
    let color: Color

    var body: some View {
        ZStack{
            ZStack{
                Text(text).offset(x:  width, y:  width)
                Text(text).offset(x: -width, y: -width)
                Text(text).offset(x: -width, y:  width)
                Text(text).offset(x:  width, y: -width)
            }
            .foregroundColor(color)
            Text(text)
                .bold()
        }
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
    // Variable para obtener el nombre de la localización del Home de la app
    var name: String = {
        let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.jorge.infoCovid")?.appendingPathComponent("name")
        let data = try! Data(contentsOf: url!)
        let name = String(data: data, encoding: .utf8)!
        print(name)
        return name
    }()
    // Variable para obtener la IA del Home de la app
    var incidence: String = {
        let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.jorge.infoCovid")?.appendingPathComponent("incidence")
        let data = try! Data(contentsOf: url!)
        let incidence = String(data: data, encoding: .utf8)!
        print(incidence)
        return incidence
    }()
    // Variable para obtener la fecha de actualización del Home de la app
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
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
