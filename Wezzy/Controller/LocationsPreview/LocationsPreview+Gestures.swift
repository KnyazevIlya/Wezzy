//
//  LocationPreviews+Gestures.swift
//  Wezzy
//
//  Created by admin on 07.09.2021.
//

import UIKit

extension LocationsPreviewViewController {
    @objc func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer!) {
        if gesture.state != .began {
            return
        }
        
        let holdPoint = gesture.location(in: collectionView)
        
        if let indexPath = collectionView.indexPathForItem(at: holdPoint) {
            let location = locations[indexPath.item]
            
            showLogicAlert(title: "Delete \"\(location.name ?? "")\" location",
                           message: "You will be able to add this location again.",
                           actionTitle: "Delete",
                           actionStyle: .destructive) { [weak self] _ in
                
                guard let self = self else { return }
                
                self.coreDataManager.delete(location: location)
                self.locations.remove(at: self.locations.firstIndex(of: location)!)
                self.collectionView.deleteItems(at: [indexPath])
            }
        }
    }
}
