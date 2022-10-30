//
//  Month.swift
//  ExpenseTracker
//
//  Created by Tinatini Charkviani on 30.10.22.
//  Copyright © 2022 Alfian Losari. All rights reserved.
//

import Foundation

enum Month: Int, CaseIterable {

    case january = 1
    case fabruary
    case march
    case april
    case may
    case june
    case july
    case august
    case september
    case october
    case november
    case december
    
    var shortName: String {
        switch self {
            case .january: return "Jan"
            case .fabruary: return "Feb"
            case .march: return "Mar"
            case .april: return "Apr"
            case .may: return "May"
            case .june: return "Jun"
            case .july: return "Jul"
            case .august: return "Aug"
            case .september: return "Sep"
            case .october: return "Oct"
            case .november: return "Nov"
            case .december: return "Dec"
        }
    }
    
    var name: String {
        switch self {
            case .january: return "January"
            case .fabruary: return "February"
            case .march: return "March"
            case .april: return "April"
            case .may: return "May"
            case .june: return "June"
            case .july: return "July"
            case .august: return "August"
            case .september: return "September"
            case .october: return "October"
            case .november: return "November"
            case .december: return "December"
        }
    }
    
}

extension Month: Identifiable {
    var id: String { "\(rawValue)" }
}
