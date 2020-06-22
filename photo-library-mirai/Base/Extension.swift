//
//  Extension.swift
//  photo-library-mirai
//
//  Created by Achmad Abdul Aziz on 22/06/20.
//  Copyright © 2020 Achmad Abdul Aziz. All rights reserved.
//

import Foundation

extension Date {
    
    var month: Int {
        return Calendar.current.component(.month, from: self)
    }
    
}

extension String{
    static func getDayOfWeek(_ today:String) -> Int? {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let todayDate = formatter.date(from: today) else { return nil }
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: todayDate)
        return weekDay
    }
    
    
    static func getDayNameWithDate(_ today: String) -> String{
        switch getDayOfWeek(today) {
        case 1:
            return "Senin"
        case 2:
            return "Selasa"
        case 3:
            return "Rabu"
        case 4:
            return "Kamis"
        case 5:
            return "Jum'at"
        case 6:
            return "Sabtu"
        case 7:
            return "Minggu"
        default:
            return "Failed"
        }
    }
    
    static func getFullnameMonth(Number id: String) -> String{
        switch id {
        case "01", "1":
            return "Januari"
        case "02", "2":
            return "Februari"
        case "03", "3":
            return "Maret"
        case "04", "4":
            return "April"
        case "05", "5":
            return "Mei"
        case "06", "6":
            return "Juni"
        case "07", "7":
            return "Juli"
        case "08", "8":
            return "Agustus"
        case "09", "9":
            return "September"
        case "10":
            return "Oktober"
        case "11":
            return "November"
        case "12":
            return "Desember"
        default:
            return "Nil"
        }
    }
    
    static func getNicknameMonth(Number id: String) -> String{
        switch id {
        case "01", "1":
            return "Jan"
        case "02", "2":
            return "Feb"
        case "03", "3":
            return "Mar"
        case "04", "4":
            return "Apr"
        case "05", "5":
            return "Mei"
        case "06", "6":
            return "Jun"
        case "07", "7":
            return "Jul"
        case "08", "8":
            return "Agt"
        case "09", "9":
            return "Sep"
        case "10":
            return "Okt"
        case "11":
            return "Nov"
        case "12":
            return "Des"
        default:
            return "Nil"
        }
    }
    
}
