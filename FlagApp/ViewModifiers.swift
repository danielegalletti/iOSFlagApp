//
//  ViewModifiers.swift
//  FlagApp
//
//  Created by Daniele on 18/07/22.
//

import SwiftUI

struct ScrollViewLine: ViewModifier {
    var detailText: String
    func body(content: Content) -> some View {
        VStack {
            HStack {
                content
                Spacer()
                Text(detailText)
            }.padding(.trailing)
            Divider()
        }.padding(.leading)
    }
}

extension Text {
    func lineView(details: String) -> some View {
        self.bold().modifier(ScrollViewLine(detailText: details))
    }
    
    func lineView(optionalDetails: String?) -> some View {
        Group {
            if let optionalDetails = optionalDetails {
                self.bold().modifier(ScrollViewLine(detailText: optionalDetails))
            }
        }
        
    }
}

extension String {
    func textViewDetails(details: String) -> some View {
        Text(self).lineView(details: details)
    }
    func textViewDetails(optionalDetails: String?) -> some View {
        Text(self).lineView(optionalDetails: optionalDetails)
    }
}

struct ScrollViewMap: ViewModifier {
    var detailText: String
    func body(content: Content) -> some View {
        VStack {
            HStack {
               EmptyView()
            }.padding(.trailing)
            Divider()
        }.padding(.leading)
    }
}




