//
//  UIViewControllerExtension.swift
//  BT Group
//
//  Created by Praveen Kumar on 01/03/24.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showToastLabel(message: String) {
        let toastLabel = UILabel(frame: CGRect(x: 50, y: self.view.frame.size.height-50, width: self.view.frame.size.width-100, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 14)!
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds = true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
