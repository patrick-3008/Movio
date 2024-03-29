//
//  APICaller.swift
//  Movio
//
//  Created by iMac on 04/03/2024.
//

import Foundation

struct Constants {
    static let API_KEY = "697d439ac993538da4e3e60b54e762cd"
    static let baseURL = "https://api.themoviedb.org"
    static let YoutubeAPI_KEY = "AIzaSyDqX8axTGeNpXRiISTGL7Tya7fjKJDYi4g"
    static let YoutubeBaseURL = "https://youtube.googleapis.com/youtube/v3/search?"
}

enum APIError: Error {
    case failedToGetData
}

enum APIType {
    case getTrendingMovies
    case getTrendingTvs
    case getUpcomingMovies
    case getPopular
    case getTopRated
}

class APICaller {
    
    static let shared = APICaller()
    var endPoint: String = ""
    
    func getTitles(for type: APIType, completion: @escaping (Result<[Title], Error>) -> Void) {
        switch type {
            case .getTrendingMovies:
                endPoint = "trending/movie/day"
            case .getTrendingTvs:
                endPoint = "trending/tv/day"
            case .getUpcomingMovies:
                endPoint = "movie/upcoming"
            case .getPopular:
                endPoint = "movie/popular"
            case .getTopRated:
                endPoint = "movie/top_rated"
        }
        
        guard let url = URL(string: "\(Constants.baseURL)/3/\(endPoint)?api_key=\(Constants.API_KEY)") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        
        task.resume()
    }
    
//    func getTerndingMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
//        guard let url = URL(string: "\(Constants.baseURL)/3/trending/movie/day?api_key=\(Constants.API_KEY)") else {return}
//        
//        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
//            guard let data = data, error == nil else {return}
//            
//            do {
//                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
//                completion(.success(results.results))
//            } catch {
//                completion(.failure(APIError.failedToGetData))
//            }
//        }
//        
//        task.resume()
//    }
//    
//    func getTrendingTvs(completion: @escaping (Result<[Title], Error>) -> Void) {
//        guard let url = URL(string: "\(Constants.baseURL)/3/trending/tv/day?api_key=\(Constants.API_KEY)") else {return}
//        
//        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
//            guard let data = data, error == nil else {return}
//            
//            do {
//                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
//                completion(.success(results.results))
//            } catch {
//                completion(.failure(APIError.failedToGetData))
//            }
//        }
//        
//        task.resume()
//    }
//    
//    func getUpcomingMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
//        guard let url = URL(string: "\(Constants.baseURL)/3/movie/upcoming?api_key=\(Constants.API_KEY)&language=en-US&page=1") else {return}
//        
//        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
//            guard let data = data, error == nil else {return}
//            
//            do {
//                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
//                completion(.success(results.results))
//            } catch {
//                completion(.failure(APIError.failedToGetData))
//            }
//        }
//        
//        task.resume()
//    }
//    
//    func getPopular(completion: @escaping (Result<[Title], Error>) -> Void) {
//        guard let url = URL(string: "\(Constants.baseURL)/3/movie/popular?api_key=\(Constants.API_KEY)&language=en-US&page=1") else {return}
//        
//        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
//            guard let data = data, error == nil else {return}
//            
//            do {
//                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
//                completion(.success(results.results))
//            } catch {
//                completion(.failure(APIError.failedToGetData))
//            }
//        }
//        
//        task.resume()
//    }
//    
//    func getTopRated(completion: @escaping (Result<[Title], Error>) -> Void) {
//        guard let url = URL(string: "\(Constants.baseURL)/3/movie/top_rated?api_key=\(Constants.API_KEY)&language=en-US&page=1") else {return}
//        
//        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
//            guard let data = data, error == nil else {return}
//            
//            do {
//                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
//                completion(.success(results.results))
//            } catch {
//                completion(.failure(APIError.failedToGetData))
//            }
//        }
//        
//        task.resume()
//    }
    
    func getDiscoverMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        
        guard let url = URL(string: "\(Constants.baseURL)/3/discover/movie?api_key=\(Constants.API_KEY)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate") else {return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
                
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
            
        }
        task.resume()
    }
    
    func searchForMovie(with query: String, completion: @escaping (Result<[Title], Error>) -> Void) {
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        
        guard let url = URL(string: "\(Constants.baseURL)/3/search/movie?query=\(query)&api_key=\(Constants.API_KEY)") else {
            return
        }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
                
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
            
        }
        task.resume()
    }
    
    func getMovieTrailer(with query: String, completion: @escaping (Result<VideoElement, Error>) -> Void) {
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        guard let url = URL(string: "\(Constants.YoutubeBaseURL)q=\(query)&key=\(Constants.YoutubeAPI_KEY)") else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            
            guard let data = data, error == nil else { return }
            do {
                let results = try JSONDecoder().decode(YoutubeSearchResponse.self, from: data)
                completion(.success(results.items[0]))
            } catch {
                completion(.failure(error))
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
}
