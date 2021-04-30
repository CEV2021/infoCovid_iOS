

import UIKit
import Charts

class IncidenciaViewController: UIViewController, ChartViewDelegate {
    
    //Outlets
    @IBOutlet weak var beforeDateLabel: UILabel!
    @IBOutlet weak var deathBefore: UILabel!
    @IBOutlet weak var recoveryBefore: UILabel!
    @IBOutlet weak var activeCasesBefore: UILabel!
    @IBOutlet weak var recoveryToday: UILabel!
    @IBOutlet weak var deathToday: UILabel!
    @IBOutlet weak var activeCasesToday: UILabel!
    @IBOutlet weak var chart: LineChartView!
    @IBOutlet weak var todayStack: UIStackView!
    @IBOutlet weak var beforeStack: UIStackView!
    @IBOutlet weak var regionNameLabel: UILabel!
    
    var region: Region?
    var downData = 0
    var ia : Double = 0.0
    var ia1 : Double = 0.0
    var ia2 : Double = 0.0
    var ia3 : Double = 0.0
    var ia4 : Double = 0.0
    var ia5 : Double = 0.0
    var ia6 : Double = 0.0
    var chartNumber = 0.0
    var updateDate = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        todayStack.layer.cornerRadius = 20
        beforeStack.layer.cornerRadius = 20
        todayStack.layer.borderWidth = 3
        beforeStack.layer.borderWidth = 3
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let downData = ((region?.data!.count)!) - 1
        
        updateDate = (region?.data![downData-6].date)!
        getDateFromString(updateDate: updateDate)
        generaGraficoLinea()
        regionNameLabel.text = region?.name
        activeCasesToday.text = String((region?.data![downData].active)!)
        recoveryToday.text = String((region?.data![downData].recovered)! )
        deathToday.text = String((region?.data![downData].deaths)!)
        activeCasesBefore.text = String((region?.data![downData-6].active)!)
        recoveryBefore.text = String((region?.data![downData-6].recovered)!)
        deathBefore.text = String((region?.data![downData-6].deaths)!)
        beforeDateLabel.text = updateDate
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }
    
    func generaGraficoLinea () {
        
        var downData = ((region?.data!.count)!) - 1
        
        ia = ((region?.data![downData-6].incidentRate) ?? 0) - (region?.data![downData-12].incidentRate ?? 0)
        ia1 = ((region?.data![downData-5].incidentRate) ?? 0) - (region?.data![downData-11].incidentRate ?? 0)
        
        ia2 = ((region?.data![downData-4].incidentRate) ?? 0) - (region?.data![downData-10].incidentRate ?? 0)
        ia3 = ((region?.data![downData-3].incidentRate) ?? 0) - (region?.data![downData-9].incidentRate ?? 0)
        ia4 = ((region?.data![downData-2].incidentRate) ?? 0) - (region?.data![downData-8].incidentRate ?? 0)
        ia5 = ((region?.data![downData-1].incidentRate) ?? 0) - (region?.data![downData-7].incidentRate ?? 0)
        ia6 = ((region?.data![downData].incidentRate) ?? 0) - (region?.data![downData-6].incidentRate ?? 0)
        
        let dato1 = BarChartDataEntry(x: 0.0, y: ia )
        let dato2 = BarChartDataEntry(x: 1.0, y: ia1 )
        let dato3 = BarChartDataEntry(x: 2.0, y: ia2 )
        let dato4 = BarChartDataEntry(x: 3.0, y: ia3 )
        let dato5 = BarChartDataEntry(x: 4.0, y: ia4 )
        let dato6 = BarChartDataEntry(x: 5.0, y: ia5 )
        let dato7 = BarChartDataEntry(x: 6.0, y: ia6 )
        
        let dataSet = LineChartDataSet(entries: [dato1, dato2, dato3, dato4, dato5, dato6, dato7], label: "Incidencia")
        let data = LineChartData(dataSets: [dataSet])
        
        chart.data = data
        chart.notifyDataSetChanged()
        
        // Configuración del eje Y (Vertical)
        chart.rightAxis.enabled = false
        chart.leftAxis.labelFont = .boldSystemFont(ofSize: 12)
        //grafica.leftAxis.setLabelCount(10, force: true)
        chart.leftAxis.labelTextColor = .red
        //grafica.leftAxis.labelPosition = .outsideChart
        // grafica.leftAxis.valueFormatter = IndexAxisValueFormatter(values: incidence)
        //grafica.leftAxis.granularity = 1
        //grafica.leftAxis.drawGridLinesEnabled = false
        //grafica.leftAxis.drawAxisLineEnabled = false
        
        // Configuración del eje X (Horizontal)
        chart.xAxis.labelPosition = .bottom
        chart.xAxis.labelFont = .boldSystemFont(ofSize: 5)
        chart.xAxis.setLabelCount(7, force: false)
        let months = [region!.data![downData-6].date
                      , region!.data![downData-5].date, region!.data![downData-4].date, region!.data![downData-3].date, region!.data![downData-2].date, region!.data![downData-1].date, "Ultima"]
        chart.xAxis.valueFormatter = IndexAxisValueFormatter(values: months)
        chart.xAxis.granularity = 1
        chart.xAxis.drawGridLinesEnabled = false
        chart.xAxis.drawAxisLineEnabled = false
        
        // Configuración de la línea de la gráfica
        chart.animate(xAxisDuration: 1)
        dataSet.drawCirclesEnabled = true
        dataSet.mode = .cubicBezier
        dataSet.lineWidth = 3
        dataSet.setColor(.red)
        let gradientColors = [UIColor.red.cgColor, UIColor.lightGray.cgColor] as CFArray // Colors of the gradient
        let colorLocations:[CGFloat] = [1.0, 0.0] // Positioning of the gradient
        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations)
        dataSet.fill = LinearGradientFill(gradient: gradient!, angle: 90)
        dataSet.drawFilledEnabled = true
        dataSet.circleHoleColor = .white
        dataSet.setCircleColor(.red)
        dataSet.drawCircleHoleEnabled = true
        dataSet.circleRadius = 5
        data.setDrawValues(false)
    }
    
    //se pasa la fecha de tipo String a tipo date para poder cambiarle el formato de americano a europeo
    func getDateFromString(updateDate: String) -> (date: Date?, conversion: Bool){
        
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let dateComponentArray = updateDate.components(separatedBy: "-")
        
        if dateComponentArray.count == 3{
            var components = DateComponents()
            components.year = Int(dateComponentArray[0])
            components.month = Int(dateComponentArray[1])
            components.day = Int(dateComponentArray[2]
            )
            guard let date = calendar.date(from: components) else{
                return (nil, false)
            }
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateStyle = .medium
            
            self.updateDate = dateFormatter.string(from: date)
            return (date, true)
            
        }else{
            return (nil, false)
        }
    }
}
