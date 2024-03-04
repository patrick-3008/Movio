//
//  APICaller.swift
//  Movio
//
//  Created by iMac on 04/03/2024.
//

import Foundation

struct Constants {
    static let API_KEY = "4c3e8e1a17ca8b7de9acdbbcb3ae0111"
    static let baseURL = "https://api.themoviedb.org"
}

class APICaller {
    static let shared = APICaller()
    
    func getTerndingMovies(completion: @escaping (String) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/movie/day?api_key=\(Constants.API_KEY)") else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {return}
            
            do {
                let results = try JSONDecoder().decode(TrendingMoviesResponse.self, from: data)
            } catch {
                print(error.localizedDescription)
            }
        }
        
        task.resume()
    }
}
