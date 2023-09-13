//
//  Date+Extension.swift
//  DateTimeToolBox
//
//  Created by Victor on 2023/9/13.
//

import Foundation
var seletedTimeZone = TimeZone.current
extension Date {
    var unixTimestamp: String {
        return String(Int(self.timeIntervalSince1970 * 1000))
    }
    
    var unixTimestampForEndDate: String {
        return String(Int(self.timeIntervalSince1970 * 1000)+999)
    }
    
    //美東時間 UCT-4
    var nyUnixTimestamp: String {
        return String(Int(self.timeIntervalSince1970 * 1000)+(12*60*60*1000))
    }
    
    func getNyDate(_ timeStr: String = "00:00:00") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "GMT-04:00")
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let nyDateTime = dateFormatter.string(from: self) + " \(timeStr) GMT-04:00"
        
        let dateTimeFormatter = DateFormatter()
        dateTimeFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss ZZZ"
        let endDate = dateTimeFormatter.date(from: nyDateTime)
        return endDate ?? self
    }
    
    func getNyStr(dateFormat: String = "yyyy/MM/dd HH:mm") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.timeZone = TimeZone(identifier: "GMT-04:00")
        
        return formatter.string(from: self)
    }
    
    func getDateStr(dateFormat: String = "yyyy/MM/dd HH:mm") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.timeZone = seletedTimeZone
        
        return formatter.string(from: self)
    }
    
    func setNyStartDate() -> Date {
        return getNyDate("00:00:00") ?? setStartDate()
    }
    
    func setNyEndDate() -> Date {
        return getNyDate("23:59:59") ?? setEndDate()
    }
    
    func setStartDate() -> Date {
        
        let calendar = Calendar(identifier: .gregorian)
        let startOfDate = calendar.startOfDay(for: self)
        
        return startOfDate
    }
    
    func setEndDate() -> Date {
        
        let calendar = Calendar(identifier: .gregorian)
        let endOfDate = calendar.startOfDay(for: self) + ((24 * 60 * 60) - 1)
        
        return endOfDate
    }
    
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    
    /// 计算两日期之间相差的天数
    func daysBetweenDate(toDate: Date) -> Int {

        let components = Calendar.current.dateComponents([.day,.hour,.minute], from: self, to: toDate)
        let day = components.day ?? 0
        let hour = components.hour ?? 0
        let minute = components.minute ?? 0
        if day > 0 , hour == 0 , minute == 0 { return day }
        if hour > 0 || minute > 0 { return day + 1 }
        
        return 0
    }
    
    /// 负数: 多少天前 正数: 多少天后 (默认-1昨天)
    func dateWithDaysDistance(_ dayCount: Int = -1) -> Date {
        return Date.init(timeInterval: TimeInterval(dayCount * 24 * 3600), since: Date())
    }
    
    func dateToHourString() -> String {
        let formatter = DateFormatter()
        formatter.timeZone = seletedTimeZone
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }
    
    //比较两个时间是否为同一天
    func isSameDayIgnoreTime(aDate : Date) -> Bool {
        let unitFlags = Set<Calendar.Component>([.year, .month, .day, .hour, .minute, .second, .weekOfMonth, .weekday, .weekdayOrdinal])
        let calendar = Calendar.current
        let components1 = calendar.dateComponents(unitFlags, from: self as Date)
        let components2 = calendar.dateComponents(unitFlags, from: aDate as Date)
        return (components1.day == components2.day && components1.month == components2.month && components1.year == components2.year)
    }
    
    func isToday() -> Bool {
        return self.isSameDayIgnoreTime(aDate: Date())
    }
    
    var displayYMDString: String {
        let formatter = DateFormatter()
        //畫面顯示時間格式
        formatter.dateFormat = "yyyy/MM/dd"
        formatter.timeZone = seletedTimeZone
        return formatter.string(from: self)
    }
    var displayHMSString: String {
        let formatter = DateFormatter()
        //畫面顯示時間格式
        formatter.dateFormat = "HH:mm:ss (zzz)"
        formatter.timeZone = seletedTimeZone
        return formatter.string(from: self)
    }
    
    /*========================*/
    func toString(format: String = "yyyy-MM-dd") -> String {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.dateFormat = format
            return formatter.string(from: self)
        }
        
        func dateAndTimetoString(format: String = "yyyy-MM-dd HH:mm") -> String {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.dateFormat = format
            return formatter.string(from: self)
        }
       
        func timeIn24HourFormat() -> String {
            let formatter = DateFormatter()
            formatter.dateStyle = .none
            formatter.dateFormat = "HH:mm"
            return formatter.string(from: self)
        }
        
        func nextDate() -> Date {
            let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: self)
            return nextDate ?? Date()
        }
        
        func previousDate() -> Date {
            let previousDate = Calendar.current.date(byAdding: .day, value: -1, to: self)
            return previousDate ?? Date()
        }
        
        func addMonths(numberOfMonths: Int) -> Date {
            let endDate = Calendar.current.date(byAdding: .month, value: numberOfMonths, to: self)
            return endDate ?? Date()
        }
        
        func removeMonths(numberOfMonths: Int) -> Date {
            let endDate = Calendar.current.date(byAdding: .month, value: -numberOfMonths, to: self)
            return endDate ?? Date()
        }
        
        func removeYears(numberOfYears: Int) -> Date {
            let endDate = Calendar.current.date(byAdding: .year, value: -numberOfYears, to: self)
            return endDate ?? Date()
        }
        
        func getHumanReadableDayString() -> String {
            let weekdays = [
                "Sunday",
                "Monday",
                "Tuesday",
                "Wednesday",
                "Thursday",
                "Friday",
                "Saturday"
            ]
            
            let calendar = Calendar.current.component(.weekday, from: self)
            return weekdays[calendar - 1]
        }
        
        
        func timeSinceDate(fromDate: Date) -> String {
            let earliest = self < fromDate ? self  : fromDate
            let latest = (earliest == self) ? fromDate : self
        
            let components:DateComponents = Calendar.current.dateComponents([.minute,.hour,.day,.weekOfYear,.month,.year,.second], from: earliest, to: latest)
            let year = components.year  ?? 0
            let month = components.month  ?? 0
            let week = components.weekOfYear  ?? 0
            let day = components.day ?? 0
            let hours = components.hour ?? 0
            let minutes = components.minute ?? 0
            let seconds = components.second ?? 0
            
            
            if year >= 2{
                return "\(year) years ago"
            }else if (year >= 1){
                return "1 year ago"
            }else if (month >= 2) {
                 return "\(month) months ago"
            }else if (month >= 1) {
             return "1 month ago"
            }else  if (week >= 2) {
                return "\(week) weeks ago"
            } else if (week >= 1){
                return "1 week ago"
            } else if (day >= 2) {
                return "\(day) days ago"
            } else if (day >= 1){
               return "1 day ago"
            } else if (hours >= 2) {
                return "\(hours) hours ago"
            } else if (hours >= 1){
                return "1 hour ago"
            } else if (minutes >= 2) {
                return "\(minutes) minutes ago"
            } else if (minutes >= 1){
                return "1 minute ago"
            } else if (seconds >= 3) {
                return "\(seconds) seconds ago"
            } else {
                return "Just now"
            }
            
        }
    
}
