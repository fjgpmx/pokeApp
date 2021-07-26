//
//  ListaFavoritosVC.swift
//  PokeApp
//
//  Created by Francisco Garcia on 25/07/21.
//

import UIKit

public class ListaFavoritosVC: UIViewController, UITableViewDelegate , UITableViewDataSource, UIScrollViewDelegate {
    
    // MARK: VAIABLES
    private var listPokemon: [Pokemon] = []
    
    // MARK: CONSTANTS
    private let manager = CoreDataManager()
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    // MARK: LIFECYCLE
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        listPokemon = manager.fetchFavorites()
        
        self.UI()

    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // MARK: METHODS
    public func UI() {
        title = "Pokemon Favorites"
        view.addSubview(tableView)
        tableView.frame = view.bounds
    }
    
    
    // MARK: DELEGATES
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listPokemon.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = listPokemon[indexPath.row].getName()!.capitalizingFirstLetter()
        cell.imageView?.image = UIImage().convertBase64StringToImage(imageBase64String: listPokemon[indexPath.row].getURLImage()!)
        return cell
    }
}
