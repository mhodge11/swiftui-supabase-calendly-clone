//
//  DatabaseManager.swift
//  SwiftUI-Supabase-Calendly-Clone
//
//  Created by Micah Hodge on 10/6/23.
//

import Foundation
import Supabase

struct Hour: Codable {
    var id: Int?
    var createdAt: Date?
    let day: Int
    let start: Int
    let end: Int
    
    enum CodingKeys: String, CodingKey {
        case id, day, start, end
        case createdAt = "created_at"
    }
}

struct Appointment: Codable {
    var id: Int?
    var createdAt: Date?
    let name: String
    let email: String
    let notes: String
    let date: Date
    
    enum CodingKeys: String, CodingKey {
        case id, name, email, notes, date
        case createdAt = "created_at"
    }
}

class DatabaseManager: ObservableObject {
    @Published var availableDates = [Date]()
    @Published var days: Set<String> = []
    
    private let client = SupabaseClient(supabaseURL: URL(string: "https://iqxkuyeuupzbycmhlpdu.supabase.co")!, supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlxeGt1eWV1dXB6YnljbWhscGR1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTY2MTM2MTksImV4cCI6MjAxMjE4OTYxOX0.w1C6GaT8gR5GbaYlM0Oew9PxYaehdDI_dW1qYlE-aXs")
    
    init() {
        refresh()
    }
    
    func refresh() {
        Task {
            do {
                let dates = try await self.fetchAvailableAppointments()
                await MainActor.run {
                    availableDates = dates
                    days = Set(dates.map({ $0.monthDayYearFormat() }))
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchHours() async throws -> [Hour] {
        let hours: [Hour] = try await client.database.from("hours").select().execute().value
        
        return hours
    }
    
    func fetchAvailableAppointments() async throws -> [Date] {
        let appointments: [Appointment] = try await client.database.from("appointments").select().execute().value
        let availableAppointments = try await generateAppointmentTimes(from: appointments)
        
        return availableAppointments
    }
    
    func generateAppointmentTimes(from appointments: [Appointment]) async throws -> [Date] {
        let takenAppointments: Set<Date> = Set(appointments.map({ $0.date }))
        let hours = try await fetchHours()
        
        let calendar = Calendar.current
        let currentWeekday = calendar.component(.day, from: Date()) - 2
        
        var timeSlots = [Date]()
        
        for weekOffset in 0...1 {
            let daysOffset = weekOffset * 7
            
            for hour in hours {
                if hour.start != 0 && hour.end != 0 {
                    var currentDate = calendar
                        .date(
                            from: DateComponents(
                                year: calendar.component(.year, from: Date()),
                                month: calendar.component(.month, from: Date()),
                                day: calendar.component(.day, from: Date()) + daysOffset + (hour.day - currentWeekday),
                                hour: hour.start
                            )
                        )!
                    
                    while let nextDate = calendar
                        .date(
                            byAdding: .minute,
                            value: 30, to: currentDate
                        ),
                          calendar.component(.hour, from: nextDate) <= hour.end
                    {
                        if !takenAppointments.contains(currentDate) && currentDate > Date() && calendar.component(.hour, from: currentDate) != hour.end {
                            timeSlots.append(currentDate)
                        }
                        
                        currentDate = nextDate
                    }
                }
            }
        }
        
        return timeSlots
    }
    
    func bookAppointment(name: String, email: String, notes: String, date: Date) async throws {
        let appointment = Appointment(name: name, email: email, notes: notes, date: date)
        let _ = try await client.database.from("appointments").insert(values: appointment).execute()
        
        refresh()
    }
}
