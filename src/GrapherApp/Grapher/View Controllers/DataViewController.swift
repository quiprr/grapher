//
//  DataViewController.swift
//  Grapher
//
//  Created by Charlie While on 28/10/2020.
//

import UIKit
import Charts

class DataViewController: UIViewController {
    
    var data: [[String : Any]]!
    var navTitle: String!

    @IBOutlet weak var dischargeView: LineChartView!
    @IBOutlet weak var temperatureView: LineChartView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.dischargeGraph()
        self.temperatureGraph()
        self.title = self.navTitle
    }
    
    @objc func purgeWithBundle() {
        let alert = UIAlertController(title: "Purge Data", message: "Are you sure you want to purge all data for \(self.navTitle!)", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { action in
            DataParser.shared.purge(false, self.navTitle!)
            NotificationCenter.default.post(name: .FuckyWucky, object: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        self.present(alert, animated: true)
    }
    
    private func setup() {
        let rightItem = UIBarButtonItem(title: "Purge", style: .plain, target: self, action: #selector(purgeWithBundle))
        self.navigationItem.rightBarButtonItem = rightItem
        
        dischargeView.dragEnabled = false
        dischargeView.pinchZoomEnabled = false
        temperatureView.pinchZoomEnabled = false
        temperatureView.dragEnabled = false
        
        temperatureView.drawMarkers = false
        dischargeView.drawMarkers = false
    }
    
    private func temperatureGraph() {
        var dataArray = [Int]()
        let colour: UIColor = .green
        let title = "Temperature"
        
        for item in self.data {
            dataArray.append(Int(round(item["temperature"] as! Float)))
        }
        
        var dataTuple = [ChartDataEntry]()
        for (index, data) in dataArray.enumerated() {
            dataTuple.append(ChartDataEntry(x: Double(index), y: Double(data)))
        }
        
        let line = LineChartDataSet(entries: dataTuple, label: title)
        line.drawCircleHoleEnabled = false
        line.drawCirclesEnabled = false
        line.valueFont = .systemFont(ofSize: 0)
        line.colors = [colour]
        let data = LineChartData()
        data.addDataSet(line)
        temperatureView.data = data
    }
    
    private func dischargeGraph() {
        var dataArray = [Int]()
        let colour: UIColor = .red
        let title = "Discharge"
        
        for item in self.data {
            dataArray.append(item["amperage"] as! Int)
        }
        
        var dataTuple = [ChartDataEntry]()
        for (index, data) in dataArray.enumerated() {
            dataTuple.append(ChartDataEntry(x: Double(index), y: Double(data)))
        }
        
        let line = LineChartDataSet(entries: dataTuple, label: title)
        line.colors = [colour]
        line.drawCircleHoleEnabled = false
        line.drawCirclesEnabled = false
        line.valueFont = .systemFont(ofSize: 0)
        let data = LineChartData()
        data.addDataSet(line)
        dischargeView.data = data
    }
}
