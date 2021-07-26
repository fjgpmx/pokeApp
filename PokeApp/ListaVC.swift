//
//  ListaVC.swift
//  PokeApp
//
//  Created by Francisco Garcia on 21/07/21.
//

import UIKit

public class ListaVC: UIViewController, UITableViewDelegate , UITableViewDataSource, UIScrollViewDelegate {
    
    // MARK: VAIABLES
    private var data = [String]()
    private var pokeAPI = PokeAPI()
    
    // MARK: CONSTANTS
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
        
        self.UI()
        
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // MARK: METHODS
    public func UI() {
        title = "Pokemon List"
        view.addSubview(tableView)
        tableView.frame = view.bounds
        pokeAPI.fetchPokemonList(completion: { [weak self] result in
            switch result {
            case .success(let data):
                self?.data.append(contentsOf: data)
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(_):
                break
            }
        })
    }
    

    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
       if (segue.identifier == "segueDetails"){
            let viewDetails = segue.destination as! DetallesVC
            let index = tableView.indexPathForSelectedRow!
            viewDetails.pokemonName = data[index.row]
       }
    }
    
    // MARK: ACTIONS
    @IBAction func actFavorites(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "segueFavorites", sender: self)
    }
    
    
    // MARK: DELEGATES
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "segueDetails", sender: self)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row].capitalizingFirstLetter()
        return cell
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > tableView.contentSize.height-100-scrollView.frame.size.height {
            pokeAPI.fetchPokemonList(completion: { [weak self] result in
                switch result {
                case .success(let data):
                    self?.data.append(contentsOf: data)
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                case .failure(_):
                    break
                }
            })
        }
    }
}
