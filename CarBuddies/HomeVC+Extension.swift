
//
//  HomeVC+Extension.swift
//  CarBuddies
//
//  Created by MAC on 22/09/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import UIKit
import FTIndicator
extension HomeVC{


//    func showSearchBar() {
//        searchBtn.isHidden = true
//        notificationBtn.isHidden = true
//        titlelbl.isHidden = true
//        
//        UIView.animate(withDuration: 0.5, animations: {
//            self.searchBar.alpha = 1
//            self.searchBar.isHidden = false
//        }, completion: { finished in
//            self.searchBar.becomeFirstResponder()
//        })
//    }
//    
//    func hideSearchBar() {
//        self.searchBar.isHidden = false
//       UIView.animate(withDuration: 0.3, animations: {
//        self.searchBar.alpha = 0
//        self.searchBtn.isHidden = false
//        self.notificationBtn.isHidden = false
//        self.titlelbl.isHidden = false
//        }, completion: { finished in
//            
//        })
//    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "segueSearchResult" {
//            let vc = segue.destination as! SearchResultVC
//            vc.searchText = searchText
//            
//        }
//    }
}
//extension HomeVC:UISearchBarDelegate{
//    //MARK: UISearchBarDelegate
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//       
//        searchBar.text = ""
//        searchBar.resignFirstResponder()
//        hideSearchBar()
//        }
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        searchText = searchBar.text
//        guard searchText != nil else {
//            FTIndicator.showProgress(withMessage: "Enter licence number")
//            return
//        }
//        searchBar.text = ""
//        searchBar.resignFirstResponder()
//        self.performSegue(withIdentifier: "segueSearchResult", sender: self)
//        
//    }
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        
//    }
//    
//    
//}

