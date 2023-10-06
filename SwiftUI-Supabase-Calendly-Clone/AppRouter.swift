//
//  AppRouter.swift
//  SwiftUI-Supabase-Calendly-Clone
//
//  Created by Micah Hodge on 10/6/23.
//

import Foundation

enum AppRouter: Hashable {
    case day(date: Date)
    case booking(date: Date)
    case confirmation(date: Date)
}
