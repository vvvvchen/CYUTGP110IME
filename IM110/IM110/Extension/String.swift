//
//  String.swift
//  IM110
//
//  Created by 曾品瑞 on 2023/9/13.
//

import Foundation

//擴充String區間擷取功能
extension String {
    subscript(_ range: CountableRange<Int>) -> String {
        let start=index(startIndex, offsetBy: max(0, range.lowerBound))
        let end=index(start, offsetBy: min(self.count - range.lowerBound, range.upperBound-range.lowerBound))
        return String(self[start..<end])
    }
    
    subscript(_ range: CountablePartialRangeFrom<Int>) -> String {
        let start=index(startIndex, offsetBy: max(0, range.lowerBound))
        return String(self[start...])
    }
}


////这是一个很有用的 String 扩展，它允许你从一个 String 中提取指定范围的子字符串。这个扩展为 String 添加了两个 subscript 方法：
//
//subscript(_ range: CountableRange<Int>) -> String：这个方法允许你传入一个 CountableRange，它包含了一个上限和下限，然后返回这个范围内的子字符串。
//subscript(_ range: CountablePartialRangeFrom<Int>) -> String：这个方法允许你传入一个 CountablePartialRangeFrom，它包含了一个下限，然后返回从下限到字符串末尾的子字符串。
//这些方法允许你更方便地从 String 中提取需要的部分。感谢分享这个有用的代码扩展！如果你有任何其他问题或需要进一步的帮助，请随时提问。
//
//
//
