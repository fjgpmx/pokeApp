//
//  DetalleVC.swift
//  PokeApp
//
//  Created by Francisco Garcia on 24/07/21.
//

import UIKit

public class DetallesVC: UIViewController {
    
    // MARK: VARIABLES
    var pokemonName: String?
    private var urlImage: String?
    private var pokeAPI = PokeAPI()
    private let manager = CoreDataManager()
    
    // MARK: OUTLETS
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgPicture: UIImageView!
    @IBOutlet weak var btnFavorites: UIButton!
    
    
    // MARK: LIFECYCLE
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        UI()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        print(manager.isPokemonRegistered(name: pokemonName!))
        if (manager.isPokemonRegistered(name: pokemonName!)) {
            self.btnFavorites.isHidden = true
        }
    }
    
    // MARK: METHODS
    public func UI() {
        
        pokeAPI.fetchPokemonImage(namePokemon: pokemonName!, completion: { [weak self] result in
            switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        self!.lblName.text = self!.pokemonName!.capitalizingFirstLetter()
                        self!.imgPicture.load(url: URL(string: (data))!)
                        self!.btnFavorites.isEnabled = true
                    }
                case .failure(_):
                    break
            }
        })
    }
    
    
    
    // MARK: ACTIONS
    @IBAction func actAddFavorites(_ sender: UIButton) {
        let image = imgPicture.image
        manager.addFavorites(name: pokemonName!, image: UIImage().convertImageToBase64String(img: image!))
    
        let alert = UIAlertController(title: "Alerta", message: "Agregado a favoritos con exito", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { UIAlertAction in
            self.btnFavorites.isHidden = true
        }))
        self.present(alert, animated: true, completion: nil)
    }
}


// MARK: EXTENSIONS
extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
      return prefix(1).uppercased() + self.lowercased().dropFirst()
    }

    mutating func capitalizeFirstLetter() {
      self = self.capitalizingFirstLetter()
    }
}

extension UIImage {
    func convertImageToBase64String (img: UIImage) -> String {
        let imageData:NSData = img.jpegData(compressionQuality: 0.50)! as NSData
        let imgString = imageData.base64EncodedString(options: .init(rawValue: 0))
        return imgString
    }
    
    func convertBase64StringToImage (imageBase64String:String) -> UIImage? {
        let imageData = Data.init(base64Encoded: imageBase64String, options: .init(rawValue: 0))
        let image = UIImage(data: imageData!)
        return image
    }
}
