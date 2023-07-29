//
//  ArrayExt.swift
//  iTunes Project
//
//  Created by Manenga Mungandi on 2023/07/27.
//

extension Array {
    var isNotEmpty: Bool {
        !isEmpty
    }
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index]: nil
    }
    subscript(safe range: Range<Index>) -> ArraySlice<Element>? {
        if range.endIndex > endIndex {
            guard range.startIndex >= endIndex else { return nil }
            return self[range.startIndex..<endIndex]
        } else {
            return self[range]
        }
    }
}
