//
//  Entities.swift
//  FlyMe
//
//  Created by Dalibor Kozak on 10/10/2019.
//  Copyright © 2019 Dalibor Kozak. All rights reserved.
//

import UIKit

struct Flights: Codable {
    var search_id: String
    var data: [Trip]
    var connections: [String]
    var time: Int
    var currency: String
    var currency_rate: Double
    var fx_rate: Double
    var del: Double
    var search_params: SearchParameters
    var _results: Int
}

struct SearchParameters: Codable {
    var flyFrom_type: String
    var to_type: String
    var seats: Seats
}

struct Seats: Codable {
    var passengers: Int
    var adults: Int?
    var children: Int?
    var infants: Int?
}

struct Trip: Codable {
    var id: String
    var bags_price: [String: Double]
    var p1: Int
    var p2: Int
    var p3: Int
    var price: Int
    var baglimit: Baglimit
    var route: [Route]
    var airlines: [String]
    var pnr_count: Int
    var transfers:[String]
    var has_airport_change: Bool
    var availability: Availability?
    var dTime: Int
    var dTimeUTC: Int
    var aTime: Int
    var aTimeUTC: Int
    var nightsInDest: Int
    var flyFrom: String
    var flyTo: String
    var cityFrom: String
    var cityTo: String
    var countryFrom: CountryFromTo
    var countryTo: CountryFromTo
    var mapIdfrom: String
    var mapIdto: String
    var distance: Double
    var routes: [[String]]
    var virtual_interlining: Bool
    var fly_duration: String
    var duration: Duration
    var return_duration: String
    var facilitated_booking_available: Bool
    var type_flights:[String]
    var booking_token: String
    var popularity: Double
    var quality: Double
    var deep_link: String
}

struct Availability: Codable {
    var seats: Int?
}

struct Baglimit: Codable {
    var hand_width: Int?
    var hand_height: Int?
    var hand_length: Int?
    var hand_weight: Int?
    var hold_width: Int?
    var hold_height: Int?
    var hold_length: Int?
    var hold_dimensions_sum: Int?
    var hold_weight: Int?
}

struct Route: Codable {
    var id: String
    var combination_id: String
    var original_return: Int
    var source: String
    var found_on: String
    var price: Int
    var aTime: Int
    var dTime: Int
    var aTimeUTC: Int
    var dTimeUTC: Int
    var mapIdfrom: String
    var mapIdto: String
    var cityTo: String
    var cityFrom: String
    var flyTo: String
    var airline: String
    var operating_carrier: String
    var equipment: String?
    var flyFrom: String
    var latFrom: Double
    var lngFrom: Double
    var latTo: Double
    var lngTo: Double
    var flight_no: Int
    var vehicle_type: String
    var refresh_timestamp: Int
    var bags_recheck_required: Bool
    var guarantee: Bool
    var fare_classes:String?
    var fare_basis:String?
    var fare_family:String?
    var fare_category: String?
    var last_seen: Int
    var operating_flight_no: String?
    //    var return: Int //conflicting value with system name
}

struct CountryFromTo: Codable {
    var code: String
    var name: String
}

struct Duration: Codable {
    var departure: Int
    var total: Int
//    var returnDuration: Int //conflicting value with system name
}

enum CellType {
    case image((Trip, UIImage?))
    case info(Trip)
    
    static func ==(lhs: CellType, rhs: CellType) -> Bool {
        switch (lhs, rhs) {
        case ( let .image(i1, _), let .image(i2, _)):
            return i1.id == i2.id
        case (let .info(i1), let .info(i2)):
            return i1.id == i2.id
        default:
            return false
        }
    }
    
    static func !=(lhs: CellType, rhs: CellType) -> Bool {
        switch (lhs, rhs) {
        case ( let .image(i1, _), let .image(i2, _)):
            return i1.id != i2.id
        case (let .info(i1), let .info(i2)):
            return i1.id != i2.id
        default:
            return false
        }
    }
    
    func cellData() -> Trip {
        switch self {
        case .image(let d):
            return d.0
        case .info(let d):
            return d
        }
    }
    
    func cellImage() -> UIImage? {
        switch self {
        case .image(let d):
            return d.1
        default:
            return nil
        }
    }
    
    mutating func update(image: UIImage?) {
        switch self {
        case .image(let (i, _)):
            self = .image((i, image))
        default:
            break
        }
    }
}
