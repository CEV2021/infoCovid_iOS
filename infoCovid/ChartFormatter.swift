    import Foundation
    import Charts

    @objc(BarChartFormatter)
    class ChartFormatter:NSObject, AxisValueFormatter{

    var months: [String]! = ["En", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sep", "Oct", "Nov", "Dic"]

    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
    return months[Int(value)]
    }

}
