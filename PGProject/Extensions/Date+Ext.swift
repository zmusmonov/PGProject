//
//  Date+Ext.swift
//  PGProject
//
//  Created by ZiyoMukhammad Usmonov on 22/11/22.
//

import Foundation

extension Date {
    
    func convertToMonthYearFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        return dateFormatter.string(from: self)
    }
}
