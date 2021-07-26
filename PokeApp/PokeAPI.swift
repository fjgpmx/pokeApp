//
//  PokeAPI.swift
//  PokeApp
//
//  Created by Francisco Garcia on 24/07/21.
//

import UIKit

class PokeAPI {
    
    // MARK: VARIABLES
    private var pagination = 1
    private var previousPages: [Int] = []
    
    // MARK: CONSTANTS
    private let limit = 20
    
    // MARK: METHODS
    func fetchPokemonList(completion: @escaping (Result<[String], Error>) -> Void) {
        
        if (previousPages.contains(pagination)) {
            return
        }
        previousPages.append(pagination)
        
        let fortniteChallengesURL = URL(string: "https://pokeapi.co/api/v2/pokemon/?limit=\(limit)&offset=\(pagination)")
        if let unwrappedURL = fortniteChallengesURL {
            var request = URLRequest(url: unwrappedURL)
            request.httpMethod = "GET"
            let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                // you should put in error handling code, too
                if let data = data {
                    do {
                        let responseOBJ = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as! [String:Any]

                        let results = responseOBJ["results"] as! [[String:Any]]
                        let lim = responseOBJ["next"] as? String ?? "&&&"
                        
                        if (lim == "&&&") {
                            completion(.success([]))
                        } else {
                            let next = lim.components(separatedBy: "?offset=")
                            let aux = next[1].components(separatedBy: "&limit=")
                            self.pagination = Int(aux[0]) ?? 1
                            //print(self.pagination)
                            var pokemonList: [String] = []
                            for i in 0..<results.count {
                                pokemonList.append(results[i]["name"] as! String)
                            }
                            completion(.success(pokemonList))
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
            dataTask.resume()
        }
    }
    
    func fetchPokemonImage(namePokemon: String, completion: @escaping (Result<String, Error>) -> Void) {
        let fortniteChallengesURL = URL(string: "https://pokeapi.co/api/v2/pokemon/\(namePokemon)/")
        if let unwrappedURL = fortniteChallengesURL {
            var request = URLRequest(url: unwrappedURL)
            request.httpMethod = "GET"
            let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                // you should put in error handling code, too
                if let data = data {
                    do {
                        let responseOBJ = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as! [String:Any]
            
                        let results = responseOBJ["sprites"] as! [String:Any]
                        let sprites = results["other"] as! [String:Any]
                        let artWork = sprites["official-artwork"] as! [String:Any]
                        let image = artWork["front_default"] as! String
                        completion(.success(image))
                        
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
            dataTask.resume()
        }
    }
}

