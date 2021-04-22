

import UIKit
import Charts

class IncidenciaViewController: UIViewController {
    
    @IBOutlet weak var grafica: LineChartView!
    @IBOutlet weak var hoyStack: UIStackView!
    @IBOutlet weak var antesStack: UIStackView!
    @IBOutlet weak var regionNameLabel: UILabel!
    
    var region: Region?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Cargo vista de grafica")
        hoyStack.layer.cornerRadius = 20
        antesStack.layer.cornerRadius = 20
        hoyStack.layer.borderWidth = 3
        antesStack.layer.borderWidth = 3
        generaGraficoLinea()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("Vista aparece")
        regionNameLabel.text = region?.name
    }
    
    func generaGraficoLinea () {
        
        /*
         Datos de la gráfica siguen el index de los arrays
         
         Incidencia (Y):
         0 = 0
         1 = 200
         2 = 300
         3 = 400
         ...
         por lo tanto si el dato de la incidencia es 300 para mostrarlo en la gráfica
         deberemos hacer let dato = BarChartDataEntry(x: (mes), y Double(300/100)
         
         Meses (X)
         Enero = 0
         Febrero = 1
         ...
         
         */
        let dato1 = BarChartDataEntry(x: 0, y: Double(0))
        let dato2 = BarChartDataEntry(x: 1, y: Double(1))
        let dato3 = BarChartDataEntry(x: 2.0, y: Double(4))
        let dato4 = BarChartDataEntry(x: 3.0, y: Double(5))
        let dato5 = BarChartDataEntry(x: 4.0, y: Double(3))
        let dato6 = BarChartDataEntry(x: 5.0, y: Double(2))
        let dato7 = BarChartDataEntry(x: 6.0, y: Double(2))
        let dataSet = LineChartDataSet(entries: [dato1, dato2, dato3, dato4, dato5, dato6, dato7], label: "Incidencia")
        let data = LineChartData(dataSets: [dataSet])
        grafica.data = data
        //grafica.backgroundColor = .black
        grafica.notifyDataSetChanged()
        
        // Configuración del eje Y (Vertical)
        grafica.rightAxis.enabled = false
        grafica.leftAxis.labelFont = .boldSystemFont(ofSize: 12)
        grafica.leftAxis.setLabelCount(6, force: false)
        grafica.leftAxis.labelTextColor = .red
        grafica.leftAxis.labelPosition = .outsideChart
        let incidence = ["0","200", "400", "600", "800", "1000"]
        grafica.leftAxis.valueFormatter = IndexAxisValueFormatter(values: incidence)
        grafica.leftAxis.granularity = 1
        grafica.leftAxis.drawGridLinesEnabled = false
        grafica.leftAxis.drawAxisLineEnabled = false
        
        // Configuración del eje X (Horizontal)
        grafica.xAxis.labelPosition = .bottom
        grafica.xAxis.labelFont = .boldSystemFont(ofSize: 12)
        grafica.xAxis.setLabelCount(12, force: false)
        let months = ["En", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sep", "Oct", "Nov", "Dic"]
        grafica.xAxis.valueFormatter = IndexAxisValueFormatter(values: months)
        grafica.xAxis.granularity = 1
        grafica.xAxis.drawGridLinesEnabled = false
        grafica.xAxis.drawAxisLineEnabled = false
        
        // Configuración de la línea de la gráfica
        grafica.animate(xAxisDuration: 1)
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
}
