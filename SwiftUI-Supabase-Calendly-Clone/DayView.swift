//
//  DayView.swift
//  SwiftUI-Supabase-Calendly-Clone
//
//  Created by Micah Hodge on 10/6/23.
//

import SwiftUI

struct DayView: View {
    @EnvironmentObject var manager: DatabaseManager
    
    @Binding var path: NavigationPath
    
    @State var dates = [Date]()
    @State var selectedDate: Date?
    
    var currentDate: Date
    
    var body: some View {
        ScrollView {
            VStack {
                Text(currentDate.fullMonthDayYearFormat())
                
                Divider()
                    .padding(.vertical)
                
                Text("Select a Time")
                    .font(.largeTitle)
                    .bold()
                
                Text("Duration: 30 min")
                
                ForEach(dates, id: \.self) { date in
                    HStack {
                        Button {
                            withAnimation {
                                selectedDate = date
                            }
                        } label: {
                            Text(date.timeFromDate())
                                .bold()
                                .padding()
                                .frame(maxWidth: .infinity)
                                .foregroundStyle(selectedDate == date ? .white : .blue)
                                .background(
                                    ZStack {
                                        if selectedDate == date {
                                            RoundedRectangle(cornerRadius: 10)
                                                .foregroundStyle(.gray)
                                        } else {
                                            RoundedRectangle(cornerRadius: 10).stroke()
                                        }
                                    }
                                )
                        }
                        
                        if selectedDate == date {
                            NavigationLink(value: AppRouter.booking(date: date)) {
                                Text("Next")
                                    .bold()
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .foregroundStyle(.white)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10).foregroundStyle(.blue)
                                    )
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .onAppear {
            self.dates = manager.availableDates.filter({ $0.monthDayYearFormat() == currentDate.monthDayYearFormat() })
        }
        .navigationTitle(currentDate.dayOfTheWeek())
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        DayView(path: .constant(NavigationPath()), currentDate: Date())
            .environmentObject(DatabaseManager())
    }
}
