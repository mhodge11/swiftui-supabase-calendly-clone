//
//  ConfirmationView.swift
//  SwiftUI-Supabase-Calendly-Clone
//
//  Created by Micah Hodge on 10/6/23.
//

import SwiftUI

struct ConfirmationView: View {
    @Binding var path: NavigationPath
    
    var currentDate: Date
    
    var body: some View {
        ScrollView {
            VStack {
                Image("micah")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 128, height: 128)
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                
                Text("Confirmed")
                    .font(.title)
                    .bold()
                    .padding()
                
                Text("You are schedule with Micah Hodge.")
                
                Divider()
                    .padding()
                
                VStack(alignment: .leading, spacing: 32) {
                    HStack {
                        Circle()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(.blue)
                        
                        Text("Calendly Course")
                    }
                    
                    HStack(alignment: .firstTextBaseline) {
                        Image(systemName: "calendar")
                        
                        Text(currentDate.bookingViewDateFormat())
                    }
                    
                    HStack(alignment: .firstTextBaseline) {
                        Image(systemName: "video")
                        
                        Text("FaceTime")
                    }
                }
                
                Spacer()
            }
            .padding()
            .frame(maxHeight: .infinity, alignment: .top)
        }
        .overlay(
            Button {
                path = NavigationPath()
            } label: {
                Text("Done")
                    .bold()
                    .foregroundStyle(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(.blue))
            }
                .padding()
            , alignment: .bottom
        )
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    NavigationStack {
        ConfirmationView(path: .constant(NavigationPath()), currentDate: Date())
    }
}
