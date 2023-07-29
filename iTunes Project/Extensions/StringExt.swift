//
//  StringExt.swift
//  iTunes Project
//
//  Created by Manenga Mungandi on 2023/07/24.
//

import Foundation

extension String {

    var isNotEmpty: Bool {
        !isEmpty
    }

    func changeDateFormat(fromFormat: String = "yyyy-MM-dd'T'HH:mm:ssZ", toFormat: String = "dd MMM yyyy") -> String {
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = fromFormat
        let date = inputDateFormatter.date(from: self)

        let outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = toFormat
        return outputDateFormatter.string(from: date!)
    }
}
