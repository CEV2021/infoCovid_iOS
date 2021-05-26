import UIKit
import Charts

class IncidenciaViewController: UIViewController, ChartViewDelegate {
    
    //Outlets
    @IBOutlet weak var todayDateLabel: UILabel!
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
    var updateDate2 = ""
    var updateDate3 = ""
    var updateDate4 = ""
    
    var dateFormatter = DateFormatter()
    var date = Date()
    var date2 = Date()
    var date3 = Date()
    var date4 = Date()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        todayStack.layer.cornerRadius = 20
        beforeStack.layer.cornerRadius = 20
        todayStack.layer.borderWidth = 3
        beforeStack.layer.borderWidth = 3
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let downData = ((region?.data!.count)!) - 1
        
        
        updateDate = (region?.data![downData].date)!
        updateDate2 = (region?.data![downData-7].date)!
        updateDate3 = (region?.data![downData-14].date)!
        updateDate4 = (region?.data![downData-21].date)!
        
       
        date = getDateFromString(updateDate: updateDate).date!
        date2 = getDateFromString(updateDate: updateDate2).date!
        date3 = getDateFromString(updateDate: updateDate3).date!
        date4 = getDateFromString(updateDate: updateDate4).date!
        dateFormatter.dateFormat = "d/M/yy"
        
        
        generaGraficoLinea()
        regionNameLabel.text = region?.name
        activeCasesToday.text = String((region?.data![downData].active)!)
        recoveryToday.text = String((region?.data![downData].recovered)! )
        deathToday.text = String((region?.data![downData].deaths)!)
        activeCasesBefore.text = String((region?.data![downData-21].active)!)
        recoveryBefore.text = String((region?.data![downData-21].recovered)!)
        deathBefore.text = String((region?.data![downData-21].deaths)!)
        todayDateLabel.text = dateFormatter.string(from: date)
        beforeDateLabel.text = dateFormatter.string(from: date4)

    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }
    
    func generaGraficoLinea () {
        var gradientColors = [UIColor.red.cgColor, UIColor.lightGray.cgColor] as CFArray
        var downData = ((region?.data!.count)!) - 1
        
        ia = ((region?.data![downData].incidentRate) ?? 0) - (region?.data![downData-13].incidentRate ?? 0)
        
        ia3 = ((region?.data![downData-21].incidentRate) ?? 0) - (region?.data![downData-27].incidentRate ?? 0)
        ia4 = ((region?.data![downData-14].incidentRate) ?? 0) - (region?.data![downData-20].incidentRate ?? 0)
        ia5 = ((region?.data![downData-7].incidentRate) ?? 0) - (region?.data![downData-13].incidentRate ?? 0)
        ia6 = ((region?.data![downData].incidentRate) ?? 0) - (region?.data![downData-6].incidentRate ?? 0)
        
        if ia > 150{
            gradientColors = [UIColor.red.cgColor, UIColor.lightGray.cgColor] as CFArray
        }else if ia > 50{
            gradientColors = [UIColor.yellow.cgColor, UIColor.lightGray.cgColor] as CFArray
        }else{
            gradientColors = [UIColor.green.cgColor, UIColor.lightGray.cgColor] as CFArray
        }
        
        let dato1 = BarChartDataEntry(x: 0.0, y: ia3 )
        let dato2 = BarChartDataEntry(x: 1.0, y: ia4 )
        let dato3 = BarChartDataEntry(x: 2.0, y: ia5 )
        let dato4 = BarChartDataEntry(x: 3.0, y: ia6 )
        //let dato5 = BarChartDataEntry(x: 4.0, y: ia4 )
        //let dato6 = BarChartDataEntry(x: 5.0, y: ia5 )
        //let dato7 = BarChartDataEntry(x: 6.0, y: ia6 )
        
        let dataSet = LineChartDataSet(entries: [dato1, dato2, dato3, dato4], label: "Incidencia")
        let data = LineChartData(dataSets: [dataSet])
        
        chart.data = data
        chart.notifyDataSetChanged()
        
        // Configuración del eje Y (Vertical)
        chart.rightAxis.enabled = false
        chart.leftAxis.labelFont = .boldSystemFont(ofSize: 12)
        //grafica.leftAxis.setLabelCount(10, force: true)
        chart.leftAxis.labelTextColor = .black
        //grafica.leftAxis.labelPosition = .outsideChart
        // grafica.leftAxis.valueFormatter = IndexAxisValueFormatter(values: incidence)
        //grafica.leftAxis.granularity = 1
        //grafica.leftAxis.drawGridLinesEnabled = false
        //grafica.leftAxis.drawAxisLineEnabled = false
        
        // Configuración del eje X (Horizontal)
        chart.xAxis.labelPosition = .bottom
        chart.xAxis.labelFont = .boldSystemFont(ofSize: 7)
        chart.xAxis.setLabelCount(4, force: false)
        
        let months = [dateFormatter.string(from: date4), dateFormatter.string(from: date3)
                      , dateFormatter.string(from: date2), dateFormatter.string(from: date)]
        
        chart.xAxis.valueFormatter = IndexAxisValueFormatter(values: months)
        chart.xAxis.granularity = 1
        chart.xAxis.drawGridLinesEnabled = false
        chart.xAxis.drawAxisLineEnabled = false
        
        // Configuración de la línea de la gráfica
        chart.animate(xAxisDuration: 1)
        dataSet.drawCirclesEnabled = true
        dataSet.mode = .cubicBezier
        dataSet.lineWidth = 3
        dataSet.setColor(.black)
        
        let colorLocations:[CGFloat] = [1.0, 0.0] // Positioning of the gradient
        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations)
        dataSet.fill = LinearGradientFill(gradient: gradient!, angle: 90)
        dataSet.drawFilledEnabled = true
        dataSet.circleHoleColor = .white
        dataSet.setCircleColor(.blue)
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
            
            dateFormatter.dateStyle = .short
            
            self.updateDate = dateFormatter.string(from: date)
            return (date, true)
            
        }else{
            return (nil, false)
        }
    }
}
