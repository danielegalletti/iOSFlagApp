//
//  Models.swift
//  FlagApp
//
//  Created by Daniele on 12/07/22.
//

import Foundation

struct MainCountryInfo: Decodable {
    var name: CountryNameInfo
    var fifa: String?
    var flags: CountryFlagsURLs
    var cca2: String
    
    //culture
    var flag: String
    var languages: [String: String]?
    
    //geography
    var area: Float
    var population: Int64
    var region: String
    var subregion: String?
    var capital: [String]?
    var borders: [String]?
    
    var latlng: [Float]
    
}

struct CountryNameInfo: Decodable {
    var common: String
    var official: String
}
struct CountryFlagsURLs: Decodable {
    var png: String
}
