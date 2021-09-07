//
//  LocationsPreview+Alert.swift
//  Wezzy
//
//  Created by admin on 02.09.2021.
//

import UIKit

extension LocationsPreviewViewController {
    func showAlert(title: String?, message: String?) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .cancel))
        present(ac, animated: true)
    }
    
    func showLogicAlert(title: String?,
                        message: String?,
                        actionTitle: String?,
                        actionStyle: UIAlertAction.Style,
                        action: @escaping((UIAlertAction)->Void)) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: actionTitle, style: actionStyle, handler: action))
        present(ac, animated: true)
    }
}
