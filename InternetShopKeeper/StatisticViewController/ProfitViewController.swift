//
//  ProfitViewController.swift
//  InternetShopKeeper
//
//  Created by Oleksandr Solokha on 29.03.2021.
//  Copyright © 2021 Oleksandr Solokha. All rights reserved.
//

import UIKit
import AAInfographics

class ProfitViewController: UIViewController {
    
    
    //create array SalesStruct
    var salesStruct = [SalesStruct]()
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
        aaChartView.aa_drawChartWithChartModel(setupaaChartModel(itemsStruct: itemsStruct, salesStruct: salesStruct))
        self.view.addSubview(aaChartView)
    }
    // setup model for graphic
    func setupaaChartModel(itemsStruct: [ItemStruct], salesStruct: [SalesStruct]) -> AAChartModel {
        let aaChartModel = AAChartModel()
        aaChartModel.chartType = .area
        aaChartModel.animationType = .none
        aaChartModel.title = "Твій дохід".localized
        aaChartModel.tooltipValueSuffix("Грн".localized)
        //the value suffix of the chart tooltip
        aaChartModel.categories(["Січ".localized, "Лют".localized, "Бер".localized, "Кві".localized, "Тра".localized, "Чер".localized, "Лип".localized, "Сер".localized, "Вер".localized, "Жов".localized, "Лис".localized, "Гру".localized])
        aaChartModel.colorsTheme(["#66cd00"])
        // instance fo each month with count profit
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
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        for itemStruct in itemsStruct {
            for saleStruct in salesStruct {
                if let date = dateFormatter.date(from: itemStruct.date) {
                    dateFormatter.dateFormat = "MM"
                    let month = dateFormatter.string(from: date)
                    switch month {
                        case "01":
                            jan += (Double(saleStruct.amount) ?? 0.0) * (Double(saleStruct.price) ?? 0.0) - (Double(itemStruct.price) ?? 0.0) * (Double(itemStruct.amount) ?? 0.0)
                        case "02":
                            feb += (Double(saleStruct.amount) ?? 0.0) * (Double(saleStruct.price) ?? 0.0) - (Double(itemStruct.price) ?? 0.0) * (Double(itemStruct.amount) ?? 0.0)
                        case "03":
                            mar += (Double(saleStruct.amount) ?? 0.0) * (Double(saleStruct.price) ?? 0.0) - (Double(itemStruct.price) ?? 0.0) * (Double(itemStruct.amount) ?? 0.0)
                        case "04":
                            apr += (Double(saleStruct.amount) ?? 0.0) * (Double(saleStruct.price) ?? 0.0) - (Double(itemStruct.price) ?? 0.0) * (Double(itemStruct.amount) ?? 0.0)
                        case "05":
                            may += (Double(saleStruct.amount) ?? 0.0) * (Double(saleStruct.price) ?? 0.0) - (Double(itemStruct.price) ?? 0.0) * (Double(itemStruct.amount) ?? 0.0)
                        case "06":
                            jun += (Double(saleStruct.amount) ?? 0.0) * (Double(saleStruct.price) ?? 0.0) - (Double(itemStruct.price) ?? 0.0) * (Double(itemStruct.amount) ?? 0.0)
                        case "07":
                            jul += (Double(saleStruct.amount) ?? 0.0) * (Double(saleStruct.price) ?? 0.0) - (Double(itemStruct.price) ?? 0.0) * (Double(itemStruct.amount) ?? 0.0)
                        case "08":
                            aug += (Double(saleStruct.amount) ?? 0.0) * (Double(saleStruct.price) ?? 0.0) - (Double(itemStruct.price) ?? 0.0) * (Double(itemStruct.amount) ?? 0.0)
                        case "09":
                            sep += (Double(saleStruct.amount) ?? 0.0) * (Double(saleStruct.price) ?? 0.0) - (Double(itemStruct.price) ?? 0.0) * (Double(itemStruct.amount) ?? 0.0)
                        case "10":
                            oct += (Double(saleStruct.amount) ?? 0.0) * (Double(saleStruct.price) ?? 0.0) - (Double(itemStruct.price) ?? 0.0) * (Double(itemStruct.amount) ?? 0.0)
                        case "11":
                            nov += (Double(saleStruct.amount) ?? 0.0) * (Double(saleStruct.price) ?? 0.0) - (Double(itemStruct.price) ?? 0.0) * (Double(itemStruct.amount) ?? 0.0)
                        case "12":
                            dec += (Double(saleStruct.amount) ?? 0.0) * (Double(saleStruct.price) ?? 0.0) - (Double(itemStruct.price) ?? 0.0) * (Double(itemStruct.amount) ?? 0.0)
                        default: break
                    }
                }
            }
        }
        aaChartModel.series([
            AASeriesElement()
                .name("Чистий дохід".localized)
                .data([jan, feb, mar, apr, may, jun, jul, aug, sep, oct, nov, dec])
        ])
        return aaChartModel
    }
}
