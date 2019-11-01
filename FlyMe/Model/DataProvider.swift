//
//  DataProvider.swift
//  FlyMe
//
//  Created by Dalibor Kozak on 10/10/2019.
//  Copyright © 2019 Dalibor Kozak. All rights reserved.
//

import UIKit

struct DataProvider {
    
    static let shared = DataProvider()
    
    func parse(data: Data) -> (Flights?, Error?) {
        do {
            let decoded = try JSONDecoder().decode(Flights.self, from: data)
            return (decoded, nil)
        } catch {
            return (nil, error)
        }
    }
    
    func requestLiveData(  completion: @escaping (Flights?, Error?) -> Void ) {
        let dateFrom = Utilities.dateIn(days: 7)
        let dateTo = Utilities.dateIn(days: 7)
        
        guard
            let dateFromStr = Utilities.dateWith(format: Constants.dateFormatRequest, date: dateFrom),
            let dateToStr = Utilities.dateWith(format: Constants.dateFormatRequest, date: dateTo),
            let url = URLConstructor.constructUrlFor(dateFrom: dateFromStr, dateTo: dateToStr) else {
                return
        }
        
        request(url: url) { (data, response, error) in
            if error == nil, let response = response as? HTTPURLResponse, response.statusCode >= 200, let data = data {
                let result = self.parse(data: data)
                completion(result.0, result.1)
            } else {
                completion(nil, error)
            }
        }
    }
    
    func requestBackgroundImageFor(iataCode: String, completion: @escaping (UIImage) -> Void) {
        let urlStr = Constants.baseUrlImage.appending("\(iataCode).jpg")
        guard let url = URL(string: urlStr) else { return }
        do {
            let data = try Data(contentsOf: url)
            completion( UIImage(data: data) ?? #imageLiteral(resourceName: "placeholder") )
        } catch {
            completion(#imageLiteral(resourceName: "placeholder") )
        }
    }
    
    func request(url:URL, completion: @escaping (Data?, URLResponse?, Error?)->Void ) {
        let session = URLSession.shared.dataTask(with: url) { (data, response, error) in
            completion(data, response, error)
        }
        session.resume()
    }
}


struct URLConstructor {
    static func constructUrlFor(dateFrom: String, dateTo: String) -> URL? {
        let params = [
            "v": "2",
            "sort": "popularity",
            "locale": "en",
            "daysInDestinationFrom": "3",
            "daysInDestinationTo": "10",
            "flyFrom": "PRG",
            "to": "anywhere",
            "typeFlight": "return",
            "one_per_date": "0",
            "oneforcity": "1",
            "adults": "1",
            "limit": "45",
            "partner": "picky",
            "curr": "EUR"
        ]
        
        var urlParameters = params.map{ URLQueryItem(name: $0, value: $1)}
        urlParameters.append(URLQueryItem(name: "dateFrom", value: dateFrom))
        urlParameters.append(URLQueryItem(name: "dateTo", value: dateTo))
        
        var component = URLComponents(string: Constants.baseUrlFlight)
        component?.queryItems = urlParameters
        return component?.url
    }
}
