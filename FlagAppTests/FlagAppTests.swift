//
//  FlagAppTests.swift
//  FlagAppTests
//
//  Created by Daniele on 12/07/22.
//

import XCTest
@testable import FlagApp

class FlagApp_RESTTests: XCTestCase {
    
    var oneCountryRawJSON = "{    \"name\": {      \"common\": \"Italy\",      \"official\": \"Italian Republic\",      \"nativeName\": {        \"ita\": {          \"official\": \"Repubblica italiana\",          \"common\": \"Italia\"        }      }    },    \"tld\": [      \".it\"    ],    \"cca2\": \"IT\",    \"ccn3\": \"380\",    \"cca3\": \"ITA\",    \"cioc\": \"ITA\",    \"independent\": true,    \"status\": \"officially-assigned\",    \"unMember\": true,    \"currencies\": {      \"EUR\": {        \"name\": \"Euro\",        \"symbol\": \"â‚¬\"      }    },    \"idd\": {      \"root\": \"+3\",      \"suffixes\": [        \"9\"      ]    },    \"capital\": [      \"Rome\"    ],    \"altSpellings\": [      \"IT\",      \"Italian Republic\",      \"Repubblica italiana\"    ],    \"region\": \"Europe\",    \"subregion\": \"Southern Europe\",    \"languages\": {      \"ita\": \"Italian\"    },    \"translations\": {      \"ara\": {        \"official\": \"Ø§Ù„Ø¬Ù…Ù‡ÙˆØ±ÙŠØ© Ø§Ù„Ø¥ÙŠØ·Ø§Ù„ÙŠØ©\",        \"common\": \"Ø¥ÙŠØ·Ø§Ù„ÙŠØ§\"      },      \"ces\": {        \"official\": \"ItalskÃ¡ republika\",        \"common\": \"ItÃ¡lie\"      },      \"cym\": {        \"official\": \"Italian Republic\",        \"common\": \"Italy\"      },      \"deu\": {        \"official\": \"Italienische Republik\",        \"common\": \"Italien\"      },      \"est\": {        \"official\": \"Itaalia Vabariik\",        \"common\": \"Itaalia\"      },      \"fin\": {        \"official\": \"Italian tasavalta\",        \"common\": \"Italia\"      },      \"fra\": {        \"official\": \"RÃ©publique italienne\",        \"common\": \"Italie\"      },      \"hrv\": {        \"official\": \"talijanska Republika\",        \"common\": \"Italija\"      },      \"hun\": {        \"official\": \"Olasz KÃ¶ztÃ¡rsasÃ¡g\",        \"common\": \"OlaszorszÃ¡g\"      },      \"ita\": {        \"official\": \"Repubblica italiana\",        \"common\": \"Italia\"      },      \"jpn\": {        \"official\": \"ã‚¤ã‚¿ãƒªã‚¢å…±å’Œå›½\",        \"common\": \"ã‚¤ã‚¿ãƒªã‚¢\"      },      \"kor\": {        \"official\": \"ìÐ½ÑÐºÐ°Ñ Ð ÐµÑÐ¿ÑƒÐ±Ð»Ð¸ÐºÐ°\",        \"common\": \"Ð˜Ñ‚Ð°Ð»Ð¸Ñ\"      },      \"slk\": {        \"official\": \"Talianska republika\",        \"common\": \"Taliansko\"      },      \"spa\": {        \"official\": \"RepÃºblica Italiana\",        \"common\": \"Italia\"      },      \"swe\": {        \"official\": \"Republiken Italien\",        \"common\": \"Italien\"      },      \"urd\": {        \"official\": \"Ø¬Ù…ÛÙˆØ±ÛŒÛ Ø§Ø·Ø§Ù„ÛŒÛ\",        \"common\": \"Ø§Ø·Ø§Ù„ÛŒÛ\"      },      \"zho\": {        \"official\": \"æ„å¤§åˆ©å…±å’Œå›½\",        \"common\": \"æ„å¤§åˆ©\"      }    },    \"latlng\": [      42.83333333,      12.83333333    ],    \"landlocked\": false,    \"borders\": [      \"AUT\",      \"FRA\",      \"SMR\",      \"SVN\",      \"CHE\",      \"VAT\"    ],    \"area\": 301336,    \"demonyms\": {      \"eng\": {        \"f\": \"Italian\",        \"m\": \"Italian\"      },      \"fra\": {        \"f\": \"Italienne\",        \"m\": \"Italien\"      }    },    \"flag\": \"🇮🇹\",    \"maps\": {      \"googleMaps\": \"https://goo.gl/maps/8M1K27TDj7StTRTq8\",      \"openStreetMaps\": \"https://www.openstreetmap.org/relation/365331\"    },    \"population\": 59554023,    \"gini\": {      \"2017\": 35.9    },    \"fifa\": \"ITA\",    \"car\": {      \"signs\": [        \"I\"      ],      \"side\": \"right\"    },    \"timezones\": [      \"UTC+01:00\"    ],    \"continents\": [      \"Europe\"    ],    \"flags\": {      \"png\": \"https://flagcdn.com/w320/it.png\",      \"svg\": \"https://flagcdn.com/it.svg\"    },    \"coatOfArms\": {      \"png\": \"https://mainfacts.com/media/images/coats_of_arms/it.png\",      \"svg\": \"https://mainfacts.com/media/images/coats_of_arms/it.svg\"    },    \"startOfWeek\": \"monday\",    \"capitalInfo\": {      \"latlng\": [        41.9,        12.48      ]    },    \"postalCode\": {      \"format\": \"#####\",      \"regex\": \"^(\\\\d{5})$\"    }  }"
    
    func testDecode_OneCountryJSON() throws {
        let decoder = JSONDecoder()
        let country = try decoder.decode(MainCountryInfo.self, from: self.oneCountryRawJSON.data(using: .utf8)!)
        XCTAssertEqual(country.name.common, "Italy")
    }
    
    func testNetworkProxy_AllCoutries() async throws {
        let proxy = CountryNetworkProxy()
        let countries = try await proxy.getAllCountries()
        XCTAssertTrue(countries.count > 100)
        
        XCTAssertTrue(countries.map {$0.name.common} .contains("Italy"))
    }
    
    func testNetworkProxy_AllCoutries_CaseSensitive() async throws {
        let proxy = CountryNetworkProxy()
        let countries = try await proxy.getAllCountries()
        XCTAssertFalse(countries.map {$0.name.common} .contains("italy"))
    }
    
    func testNetworkProxy_CountryDetail_FromName() async throws {
        let proxy = CountryNetworkProxy()
        let country = try await proxy.getCountryDetail("italy")
        XCTAssertEqual(country.fifa, "ITA")
    }
    
    func testNetworkProxy_CountryDetail_FromName_CaseInsensitive() async throws {
        let proxy = CountryNetworkProxy()
        let country = try await proxy.getCountryDetail("ITALY")
        XCTAssertEqual(country.fifa, "ITA")
    }
}

class FlagApp_CacheTests: XCTestCase {
    
    func testCountryLoader_Cached_AllCountry_After_Call() async throws {
        let loader = CacheCountryLoader()
        let cache = await loader.getCountryCache()
        XCTAssertTrue(cache.isEmpty)
        //call
        let _ = try await loader.getAllCountries()
        //check cache
        let cacheAfterCall = await loader.getCountryCache()
        XCTAssertFalse(cacheAfterCall.isEmpty)
    }
    
    func testCountryLoader_FlagImage_withoutURL() async throws {
        let loader = CacheCountryLoader()
        let cacheImages = await loader.getFlagsImageDataCache()
        let cacheCountries = await loader.getCountryCache()
        XCTAssertTrue(cacheImages.isEmpty)
        XCTAssertTrue(cacheCountries.isEmpty)
        
        //call loadImage
        let _ = try await loader.loadCountryImage("Italy")
        //check if country is now present
        let cacheCountriesAfterCall = await loader.getCountryCache()
        XCTAssertTrue(cacheCountriesAfterCall.keys.contains("Italy"))
        XCTAssertEqual(cacheCountriesAfterCall.count, 1)
        //check if image was cached
        let cacheImagesAfterCall = await loader.getFlagsImageDataCache()
        XCTAssertTrue(cacheImagesAfterCall.keys.contains("Italy"))
        XCTAssertEqual(cacheImagesAfterCall.count, 1)
    }
    
    func testCountryLoader_FlagImage_withUrl_withoutCachedImage() async throws {
        let loader = CacheCountryLoader()
        let _ = try await loader.getCountryDetail("Italy")
        let cacheImages = await loader.getFlagsImageDataCache()
        let cacheCountries = await loader.getCountryCache()
        XCTAssertTrue(cacheImages.isEmpty)
        XCTAssertEqual(cacheCountries.count, 1)
        
        //call loadImage
        let _ = try await loader.loadCountryImage("Italy")
        //no change in cacheCountry
        let cacheCountriesAfterCall = await loader.getCountryCache()
        XCTAssertEqual(cacheCountriesAfterCall.count, 1)
        //check if image was cached
        let cacheImagesAfterCall = await loader.getFlagsImageDataCache()
        XCTAssertTrue(cacheImagesAfterCall.keys.contains("Italy"))
        XCTAssertEqual(cacheImagesAfterCall.count, 1)
    }
}
