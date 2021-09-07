//
//  RequestManager.swift
//  Wezzy
//
//  Created by admin on 28.08.2021.
//

import UIKit
import CoreLocation

class RequestManager {
    
    static let shared = RequestManager()
    
    enum ParsingError: Error {
        case ParsingFailed
    }
    
    private init() {}
    
    func fetchJSON<Model: Codable>(withURL url: URL, completion: @escaping((Result<Model, Error>) -> ())) {
        
        let urlRequest = URLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            
            if let error = error {
                completion(.failure(error))
            }
            
            guard let data = data else { return }
            
            do {
                let model = try JSONDecoder().decode(Model.self, from: data)
                print("requested", Date().description)
                completion(.success(model))
            } catch {
                completion(.failure(ParsingError.ParsingFailed))
            }
        }
        
        task.resume()
    }
}
