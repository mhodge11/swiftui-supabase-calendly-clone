//
//  BookingView.swift
//  SwiftUI-Supabase-Calendly-Clone
//
//  Created by Micah Hodge on 10/6/23.
//

import SwiftUI

struct BookingView: View {
    @EnvironmentObject var manager: DatabaseManager
    
    @Binding var path: NavigationPath
    
    @State private var name = ""
    @State private var email = ""
    @State private var notes = ""
    
    var currentDate: Date
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: 16) {
                    HStack(alignment: .firstTextBaseline) {
                        Image(systemName: "clock")
                        
                        Text("30 min")
                    }
                    
                    HStack(alignment: .firstTextBaseline) {
                        Image(systemName: "video")
                        
                        Text("FaceTime")
                    }
                    
                    HStack(alignment: .firstTextBaseline) {
                        Image(systemName: "calendar")
                        
                        Text(currentDate.bookingViewDateFormat())
                    }
                }
                .padding()
                
                Divider()
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Enter Details")
                        .font(.title)
                        .bold()
                    
                    Text("Name")
                    
                    TextField("", text: $name)
                        .textContentType(.name)
                        .textInputAutocapitalization(.words)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).stroke())
                    
                    Text("Email")
                    
                    TextField("", text: $email)
                        .textContentType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).stroke())
                    
                    Text("Please share anything that will help prepare for our meeting.")
                    
                    TextField("", text: $notes, axis: .vertical)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).stroke())
                }
                .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .navigationTitle("Calendly Course")
            .navigationBarTitleDisplayMode(.inline)
        }
        .overlay(
            Button {
                if !name.isEmpty && !email.isEmpty {
                    Task {
                        do {
                            try await manager.bookAppointment(name: name, email: email, notes: notes, date: currentDate)
                            
                            name = ""
                            email = ""
                            notes = ""
                            
                            path.append(AppRouter.confirmation(date: currentDate))
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
            } label: {
                Text("Schedule Event")
                    .bold()
                    .foregroundStyle(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(.blue))
            }
                .padding()
            , alignment: .bottom)
    }
}

#Preview {
    NavigationStack {
        BookingView(path: .constant(NavigationPath()), currentDate: Date())
            .environmentObject(DatabaseManager())
    }
}
