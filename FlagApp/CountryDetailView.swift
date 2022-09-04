//
//  CountryDetailView.swift
//  FlagApp
//
//  Created by Daniele on 13/07/22.
//

import SwiftUI
import UniformTypeIdentifiers

struct CountryDetailView: View {
    
    @EnvironmentObject var countryLoader: CacheCountryLoader
    
    var country: String
    @State var countryInfo: MainCountryInfo?
    @State var image: Image?
    
    @State var error: Error? = nil
    
    var body: some View {
        
        ScrollView {
            if let countryInfo = countryInfo {
                VStack {
                    if let image = self.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .border(.gray, width: 1)
                            .padding()
                    } else {
                        Color.gray
                            .frame(height:170)
                            .aspectRatio(contentMode: .fit)
                            .padding()
                    }
                    Text("details.cca2").lineView(optionalDetails: countryInfo.cca2)
                    Text("details.name.official").lineView(details: countryInfo.name.official)
                        .onTapGesture(count: 2) {
                                UIPasteboard.general.setValue(countryInfo.name.official,
                                    forPasteboardType: UTType.plainText.identifier)
                            }
                    Text("details.population").lineView(details: "\(countryInfo.population)")
                    Text("details.fifa").lineView(optionalDetails: countryInfo.fifa)
                    Text("details.region").lineView(details:countryInfo.region)
                    Text("details.area").lineView(details:"\(countryInfo.area) km²")
                    Text("details.capital").lineView(optionalDetails:countryInfo.capital?.joined(separator: ", "))
                    //something of geography
                    
                    Text("details.languages").lineView(optionalDetails: countryInfo.languages?.values.joined(separator: ", "))
                }
                
            } else {
                Text("details.error.generic")
                    .task {
                        do {
                            self.countryInfo = try await countryLoader.getCountryDetail(country)
                        } catch {
                            self.error = error
                        }
                        //image is not managed with error
                        if let imageData = try? await countryLoader.loadCountryImage(country), let uiimage = UIImage(data: imageData) {
                            self.image = Image(uiImage: uiimage)
                        }
                    }
            }
            
        }.navigationTitle(country)
            
    }
}

struct CountryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CountryDetailView(country: "Ita")
    }
}
