//
//  Pokemon.swift
//  PokeApp
//
//  Created by Francisco Garcia on 24/07/21.
//

import UIKit

public class Pokemon {
    
    // MARK: VARIABLES
    private var name: String?
    private var urlImage: String?

    public init() {
        
    }
    
    public init(name: String?, urlImage: String?) {
        self.name = name
        self.urlImage = urlImage
    }
    
    // MARK: METHODS
    public func setName(name: String) -> Void {
        self.name = name
    }
    
    public func setURLImage(urlImage: String) -> Void {
        self.urlImage = urlImage
    }
    
    public func getName() -> String? {
        return self.name
    }
    
    public func getURLImage() -> String? {
        return self.urlImage
    }
}

