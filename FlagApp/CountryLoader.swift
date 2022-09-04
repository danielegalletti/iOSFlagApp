//
//  CountryLoader.swift
//  FlagApp
//
//  Created by Daniele on 12/07/22.
//

import Foundation

actor CacheCountryLoader: ObservableObject {
    
    private var networkProxy = CountryNetworkProxy()
    private var countryMainInfoCache = [String: MainCountryInfo]()
    private var countryFlagsCache = [String: Data]()
    
    
    func getAllCountries() async throws -> [MainCountryInfo] {
        ///returns list of country info + cache countries info
        let countries = try await networkProxy.getAllCountries()
        self.countryMainInfoCache = countries.reduce(into: [String:MainCountryInfo](), { partialResult, info in
            partialResult[info.name.common] = info
        })
        return countries
    }
    
    func getCountryDetail(_ countryName: String) async throws -> MainCountryInfo {
        if let countryInfo = self.countryMainInfoCache[countryName] {
            return countryInfo
        } else {
            let info = try await networkProxy.getCountryDetail(countryName)
            self.countryMainInfoCache[info.name.common] = info
            return info
        }
    }
    
    func loadCountryImage(_ countryName: String) async throws -> Data {
        if let imageData = self.countryFlagsCache[countryName] {
            //check image cached
            return imageData
        }
        //else
        if let countryInfo = self.countryMainInfoCache[countryName] {
            //download from url
            guard let url = URL(string: countryInfo.flags.png) else {
                throw "image url not valid"
            }
            let data = try await networkProxy.loadImageData(url)
            self.countryFlagsCache[countryName] = data
            return data
        }
        //else load country info, then load image
        let countryInfo = try await self.getCountryDetail(countryName)
        guard let url = URL(string: countryInfo.flags.png) else {
            throw "image url not valid"
        }
        let data = try await networkProxy.loadImageData(url)
        self.countryFlagsCache[countryName] = data
        return data
    }
    
    //MARK: - caches async getters
    func getCountryCache() async -> [String: MainCountryInfo] {
        self.countryMainInfoCache
    }
    func getFlagsImageDataCache() async -> [String: Data] {
        self.countryFlagsCache
    }

}
