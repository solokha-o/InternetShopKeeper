//
//  CostsViewController.swift
//  InternetShopKeeper
//
//  Created by Oleksandr Solokha on 13.05.2020.
//  Copyright © 2020 Oleksandr Solokha. All rights reserved.
//

import UIKit

class CostsViewController: UIViewController {
    
    // create array ItemStruct
    var itemsStruct = [ItemStruct]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupaaChartView()
    }
    
    // setup view with graphic
    func setupaaChartView() {
        let chartViewWidth  = self.view.frame.size.width
        let chartViewHeight = self.view.frame.size.height
        let aaChartView = AAChartView()
        aaChartView.frame = CGRect(x: 0, y: 0, width: chartViewWidth, height: chartViewHeight)
        aaChartView.aa_drawChartWithChartModel(setupaaChartModel(itemsStruct: itemsStruct))
        self.view.addSubview(aaChartView)
    }
    // setup model for graphic
    func setupaaChartModel(itemsStruct: [ItemStruct]) -> AAChartModel {
        let aaChartModel = AAChartModel()
        aaChartModel.chartType = .area
        aaChartModel.animationType = .none
        aaChartModel.title = "Твої витрати"
        aaChartModel.tooltipValueSuffix("Грн")//the value suffix of the chart tooltip
        aaChartModel.categories(["Січ", "Лют", "Бер", "Кві", "Тра", "Чер",
                                 "Лип", "Сер", "Вер", "Жов", "Лис", "Гру"])
        aaChartModel.colorsTheme(["#fe117c"])
        // inctanse fo each month with count costs
        var jan = 0.0
        var feb = 0.0
        var mar = 0.0
        var apr = 0.0
        var may = 0.0
        var jun = 0.0
        var jul = 0.0
        var aug = 0.0
        var sep = 0.0
        var oct = 0.0
        var nov = 0.0
        var dec = 0.0
        for itemStruct in itemsStruct {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yy"
            if let date = dateFormatter.date(from: itemStruct.date) {
                dateFormatter.dateFormat = "MM"
                let month = dateFormatter.string(from: date)
                switch month {
                case "01":
                    jan += (Double(itemStruct.price) ?? 0.0) * (Double(itemStruct.amount) ?? 0.0)
                case "02":
                    feb += (Double(itemStruct.price) ?? 0.0) * (Double(itemStruct.amount) ?? 0.0)
                case "03":
                    mar += (Double(itemStruct.price) ?? 0.0) * (Double(itemStruct.amount) ?? 0.0)
                case "04":
                    apr += (Double(itemStruct.price) ?? 0.0) * (Double(itemStruct.amount) ?? 0.0)
                case "05":
                    may += (Double(itemStruct.price) ?? 0.0) * (Double(itemStruct.amount) ?? 0.0)
                case "06":
                    jun += (Double(itemStruct.price) ?? 0.0) * (Double(itemStruct.amount) ?? 0.0)
                case "07":
                    jul += (Double(itemStruct.price) ?? 0.0) * (Double(itemStruct.amount) ?? 0.0)
                case "08":
                    aug += (Double(itemStruct.price) ?? 0.0) * (Double(itemStruct.amount) ?? 0.0)
                case "09":
                    sep += (Double(itemStruct.price) ?? 0.0) * (Double(itemStruct.amount) ?? 0.0)
                case "10":
                    oct += (Double(itemStruct.price) ?? 0.0) * (Double(itemStruct.amount) ?? 0.0)
                case "11":
                    nov += (Double(itemStruct.price) ?? 0.0) * (Double(itemStruct.amount) ?? 0.0)
                case "12":
                    dec += (Double(itemStruct.price) ?? 0.0) * (Double(itemStruct.amount) ?? 0.0)
                default: break
                }
            }
        }
        aaChartModel.series([
            AASeriesElement()
                .name("Витрати")
                .data([jan, feb, mar, apr, may, jun, jul, aug, sep, oct, nov, dec])
        ])
        return aaChartModel
    }
}
