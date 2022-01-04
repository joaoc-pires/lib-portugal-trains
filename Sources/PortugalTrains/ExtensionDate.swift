//
//  File.swift
//  
//
//  Created by Joao Pires on 03/01/2022.
//

import Foundation

extension Date {
    
    /// Returns the date in a string formated as yyyy-MM-dd HH:mm
    /// - Note: Infraestruturas de Portugal doesn't use ISO 8601 (NP EN 286010) but rather a close approximation that uses a space to differenciate between day and time.
    var ipFormated: String {
        
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: self)
        return "\(components.year ?? 2022)-\(components.month ?? 1)-\(components.day ?? 1)%20\(components.hour ?? 1):\(components.minute ?? 0)"
    }
    
    static var endOfDay: Date {
        
        let formatter = DateFormatter()
        let components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.date(from: "\(components.year ?? 2022)-\(components.month ?? 1)-\(components.day ?? 1) 23:59")!
    }
}
