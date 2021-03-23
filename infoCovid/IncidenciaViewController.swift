

import UIKit
import Charts

class IncidenciaViewController: UIViewController {
    
    @IBOutlet weak var grafica: LineChartView!
    @IBOutlet weak var hoyStack: UIStackView!
    @IBOutlet weak var antesStack: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hoyStack.layer.cornerRadius = 20
        antesStack.layer.cornerRadius = 20
        hoyStack.layer.borderWidth = 3
        antesStack.layer.borderWidth = 3
        generaGraficoLinea()
        
    }
    
    func generaGraficoLinea () {
        
        let dato1 = BarChartDataEntry(x: 1, y: Double(7))
        let dato2 = BarChartDataEntry(x: 2.0, y: Double(6))
        let dato3 = BarChartDataEntry(x: 3.0, y: Double(3))
        let dataSet = LineChartDataSet(entries: [dato1, dato2, dato3], label: "Incidencia")
        let data = LineChartData(dataSets: [dataSet])
        grafica.data = data
        //grafica.backgroundColor = .black
        grafica.notifyDataSetChanged()
        
        grafica.rightAxis.enabled = false
        grafica.leftAxis.labelFont = .boldSystemFont(ofSize: 12)
        grafica.leftAxis.setLabelCount(6, force: false)
        //grafica.leftAxis.labelTextColor = .white
        grafica.leftAxis.labelPosition = .outsideChart
        
        grafica.xAxis.labelPosition = .bottom
        grafica.xAxis.labelFont = .boldSystemFont(ofSize: 12)
        grafica.xAxis.setLabelCount(6, force: false)
       // grafica.xAxis.labelTextColor = .white
        
        
        
    }
}
