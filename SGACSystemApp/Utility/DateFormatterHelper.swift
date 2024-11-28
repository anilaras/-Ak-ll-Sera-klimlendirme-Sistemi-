//
//  DateFormatterHelper.swift
//  SGACSystemApp
//
//  Created by İlker Kaya on 29.11.2024.
//

import Foundation

struct DateFormatterHelper {
    
    static func dateFormatter(with format: String) -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter
    }
    
    static func dateFormatterForTabPast(with date: String) -> String {
        let dateFormatters = dateFormatter(with: "yyyy-MM-dd HH:mm:ss")
        if let date = dateFormatters.date(from: date) {
            let dateFormatterForTabPast = dateFormatter(with: "dd-MM-yyyy")
            return dateFormatterForTabPast.string(from: date)
        } else {
            return date
        }
    }
    
    static func dateFormatterForDetails(with date: String) -> String {
        let dateFormatters = dateFormatter(with: "yyyy-MM-dd HH:mm")
        if let date = dateFormatters.date(from: date) {
            let dateFormatterForDetails = dateFormatter(with: "HH:mm")
            return dateFormatterForDetails.string(from: date)
        } else {
            return date
        }
    }
    
    static func dateFormatterForFixed(with date: String) -> String {
        let dateFormatters = dateFormatter(with: "yyyy-MM-dd HH:mm:ss")
        if let date = dateFormatters.date(from: date) {
            let dateFormatterForTabPast = dateFormatter(with: "yyyy-MM-dd HH:mm")
            return dateFormatterForTabPast.string(from: date)
        } else {
            return date
        }
    }
}
