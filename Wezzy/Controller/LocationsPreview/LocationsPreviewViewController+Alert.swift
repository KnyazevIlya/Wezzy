//
//  LocationsPreviewViewController+Alert.swift
//  Wezzy
//
//  Created by admin on 02.09.2021.
//

import UIKit

extension LocationsPreviewViewController {
    func showAlert(title: String?, message: String?) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
}
