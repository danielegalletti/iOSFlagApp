//
//  CountryNetworkProxy.swift
//  FlagApp
//
//  Created by Daniele on 13/07/22.
//

import Foundation

//FIXME: errors can be enumerated for a more precise management
extension String: Error { }

class CountryNetworkProxy {
    
    init() {
        URLSessionConfiguration.default.timeoutIntervalForRequest = 5
        URLSessionConfiguration.default.timeoutIntervalForResource = 5
    }
    
    func getAllCountries() async throws -> [MainCountryInfo] {
        do {
            guard let url = URL(string: "https://restcountries.com/v3.1/all") else {
                throw "country name not valid"
            }
            let request = URLRequest(url: url)
            let (data, response) = try await URLSession.shared.data(for: request)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw "Error while fetching data" }
            
            guard let decoded = try? JSONDecoder().decode([MainCountryInfo].self, from: data) else {
                throw "error while parsing data"
            }
            
            return decoded
            
        } catch {
            throw "errore generico"
        }
    }
    
    func getCountryDetail(_ countryName: String) async throws -> MainCountryInfo {
        do {
            guard let url = URL(string: "https://restcountries.com/v3.1/name/\(countryName)") else {
                throw "country name not valid"
            }
            let request = URLRequest(url: url)
            let (data, response) = try await URLSession.shared.data(for: request)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw "Error while fetching data" }
            
            guard let decoded = try? JSONDecoder().decode([MainCountryInfo].self, from: data) else {
                throw "error while parsing data"
            }
            
            return decoded.first!
            
        } catch {
            throw "errore generico"
        }
    }
    
    func loadImageData(_ url: URL) async throws -> Data {
        let request = URLRequest(url: url)
        let (imageData, _) = try await URLSession.shared.data(for: request)
        return imageData
    }
    
}
