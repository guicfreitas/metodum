//
//  MethodsScreenViewController.swift
//  metodum
//
//  Created by Gonzalo Ivan Santos Portales on 21/09/20.
//  Copyright © 2020 metodum. All rights reserved.
//

import UIKit

class MethodsScreenViewController: UIViewController {

    @IBOutlet weak var navigantionBar: UINavigationBar!
    @IBOutlet weak var navigationIten: UINavigationItem!
    @IBOutlet weak var methodsCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let searchCV = UISearchController()
        searchCV.searchBar.delegate = self
        //navigationIten.searchController = searchCV
        // Do any additional setup after loading the view.
    }
}

extension MethodsScreenViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("clicado")
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("editando")
    }
}
