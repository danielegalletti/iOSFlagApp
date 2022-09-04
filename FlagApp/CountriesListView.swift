//
//  CountriesListView.swift
//  FlagApp
//
//  Created by Daniele on 12/07/22.
//

import SwiftUI

struct CountriesListView: View {
    
    @State
    var searchNames: [String] = []
    @State
    var images: [String: Image] = [:]
    @State
    var error: Error? = nil
    
    //used for sorting and searching
    @State private var populations: [String: Int64] = [:]
    @State private var areas: [String: Float] = [:]
    @State private var completeNames: [String] = []
    
    @EnvironmentObject
    var countryLoader: CacheCountryLoader
    @State private var searchedText: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                if let _ = self.error {
                    //show retry
                    Text("list.error.generic")
                    Button {
                        self.error = nil
                    } label: {
                        HStack {
                            Image(systemName:"arrow.clockwise")
                            Text("list.error.retry")
                        }
                        
                    }

                } else if self.completeNames.isEmpty { //loading not yet completed
                    ProgressView()
                        .task {
                            do {
                                let countries = try await self.countryLoader.getAllCountries()
                                self.completeNames = countries.map { $0.name.common }.sorted { $0 < $1 }
                                self.searchNames = self.completeNames
                                self.populations = countries.reduce(into: [String: Int64](), { partialRes, country in
                                    partialRes[country.name.common] = country.population
                                })
                                self.areas = countries.reduce(into: [String: Float](), { partialRes, country in
                                    partialRes[country.name.common] = country.area
                                })
                            } catch {
                                self.error = error
                            }
                        }
                } else if self.searchNames.isEmpty { //search results are empty
                    Text("list.search.empty").bold()
                } else {
                    List (Array(zip(searchNames.indices, searchNames)), id: \.0) { index, name in
                        NavigationLink {
                            CountryDetailView(country: name)
                        } label: {
                            HStack {
                                if let image = self.images[name] {
                                    image.resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(minWidth: 44, maxWidth:44, maxHeight: 32, alignment: .center)
                                } else {
                                    Color.gray.frame(width: 44, height: 32, alignment: .center)
                                        .task {
                                            if let imageData = try? await countryLoader.loadCountryImage(name), let uiimage = UIImage(data: imageData) {
                                                self.images[name] = Image(uiImage: uiimage)
                                            }
                                        }
                                }
                                
                                Text(name)
                            }
                            
                        }
                    }.toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                                Menu(content: {
                                    Button("list.sortMenu.name") {
                                        self.completeNames = self.completeNames.sorted { $0 < $1 }
                                    }
                                    Button("list.sortMenu.population") {
                                        self.completeNames = self.completeNames.sorted { (self.populations[$0] ?? 0) < (self.populations[$1] ?? 0) }
                                    }
                                    Button("list.sortMenu.area") {
                                        self.completeNames = self.completeNames.sorted { (self.areas[$0] ?? 0) < (self.areas[$1] ?? 0) }
                                    }
                                }
                             ,label: {
                                    Image(systemName: "arrow.up.arrow.down.square")
                            })
                        }
                    }
                    
                    
                }
            }
            .searchable(text: self.$searchedText)
            .navigationBarTitle("FlagApp")
            
        }
        //search
        .onChange(of: self.searchedText) { _ in
            guard !searchedText.isEmpty else {
                self.searchNames = self.completeNames
                return
            }
            self.searchNames = self.completeNames.filter({ name in
                name.lowercased().contains(searchedText.lowercased())
            })
        }
        //align shown names to sorting
        .onChange(of: self.completeNames) { _ in
            self.searchNames = self.completeNames
        }
        
    }
}

struct CountriesListView_Previews: PreviewProvider {
    static var previews: some View {
        CountriesListView()
    }
}
