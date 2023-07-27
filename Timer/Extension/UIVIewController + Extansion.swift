//
//  UIVIewController + Extansion.swift
//  Timer
//
//  Created by Sergey Savinkov on 27.06.2023.
//

import UIKit

extension UIViewController {
    
    func alertOk(title: String, message: String?) {
        
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "Ok",style: .default)
        
        alertController.addAction(ok)
        present(alertController, animated: true)
    }
    
    func alertOkCancel(title: String, message: String, titleOk: String, titleCancel: String, completionHandler: @escaping() -> Void) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default) { _ in
            completionHandler()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .default)
        
        alertController.addAction(ok)
        alertController.addAction(cancel)
        
        present(alertController, animated: true, completion: nil)
    }
}
