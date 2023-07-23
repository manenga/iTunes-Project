//
//  DateExt.swift
//  iTunes Project
//
//  Created by Manenga Mungandi on 2023/07/23.
//

import Foundation

extension Date {
   func getFormattedDate(format: String = "dd-MMM-yyyy") -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}

extension String {
    func changeDateFormat(fromFormat: String = "yyyy-MM-dd'T'HH:mm:ssZ", toFormat: String = "dd MMM yyyy") -> String {
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = fromFormat
        let date = inputDateFormatter.date(from: self)

        let outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = toFormat
        return outputDateFormatter.string(from: date!)
    }
}
