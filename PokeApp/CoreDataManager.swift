//
//  CoreDataManager.swift
//  PokeApp
//
//  Created by Francisco Garcia on 25/07/21.
//

import Foundation
import CoreData
class CoreDataManager {
    
    private let container : NSPersistentContainer!
    
    init() {
        container = NSPersistentContainer(name: "PokemonDB")
        
        setupDatabase()
    }
    
    private func setupDatabase() {
        container.loadPersistentStores { (desc, error) in
            if let error = error {
                print("Error loading store \(desc) — \(error)")
                return
            }
            print("Database ready!")
        }
    }
    
    func addFavorites(name : String, image : String) {

        let context = container.viewContext

        let favorites = FavoritesPokemon(context: context)
        favorites.name = name
        favorites.urlimage = image

        do {
            try context.save()
            print("Pokemon \(name) saved")
        } catch {

          print("Error guardando pokemon — \(error)")
        }
    }
    
    func fetchFavorites() -> [Pokemon] {

        let fetchRequest : NSFetchRequest<FavoritesPokemon> = FavoritesPokemon.fetchRequest()
        do {

            let result = try container.viewContext.fetch(fetchRequest)
            
            var auxPokemon: [Pokemon] = []
            for i in 0..<result.count {
                let pokemon = Pokemon(name: result[i].name, urlImage: result[i].urlimage)
                auxPokemon.append(pokemon)
            }
            return auxPokemon
        } catch {
            print("El error obteniendo Favoritos \(error)")
         }

         return []
    }
    
    func isPokemonRegistered(name: String) -> Bool {
        var isExist = false
        let fetchRequest : NSFetchRequest<FavoritesPokemon> = FavoritesPokemon.fetchRequest()
        do {

            let result = try container.viewContext.fetch(fetchRequest)

            for i in 0..<result.count {
                if (result[i].name == name) {
                    isExist = true
                }
            }
            return isExist
        } catch {
            print("El error obteniendo Favoritos \(error)")
         }

         return isExist
    }
    
}
