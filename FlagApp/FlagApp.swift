//
//  FlagAppApp.swift
//  FlagApp
//
//  Created by Daniele on 12/07/22.
//

import SwiftUI

@main
struct FlagAppApp: App {

    var body: some Scene {
        WindowGroup {
            CountriesListView()
                .environmentObject(CacheCountryLoader())
        }
    }
}
