//
//  String.swift
//  IM110
//
//  Created by 曾品瑞 on 2023/9/13.
//

import Foundation

//擴充String區間擷取功能
extension String
{
    subscript(_ range: CountableRange<Int>) -> String
    {
        let start=index(startIndex, offsetBy: max(0, range.lowerBound))
        let end=index(start, offsetBy: min(self.count - range.lowerBound, range.upperBound-range.lowerBound))
        return String(self[start..<end])
    }
    
    subscript(_ range: CountablePartialRangeFrom<Int>) -> String
    {
        let start=index(startIndex, offsetBy: max(0, range.lowerBound))
        return String(self[start...])
    }
}
