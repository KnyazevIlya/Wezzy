//
//  ConditionPlatesCollectionViewController.swift
//  Wezzy
//
//  Created by admin on 17.09.2021.
//

import UIKit

class ConditionPlatesCollectionViewController: UICollectionViewController {
    
    var location: Location?
    
    private let inset: CGFloat = 20
    private let plateInset: CGFloat = 10
    private var plateHeight: CGFloat = 0
    
    var mainColor: UIColor = .black {
        didSet {
            for index in 0..<plates.count {
                let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as! ConditionPlateCollectionViewCell
                cell.mainColor = mainColor
            }
        }
    }
    
    private struct Plate {
        var image: UIImage
        var title: String
        var detailed: String
    }

    private var plates: [Plate] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createPlates()
        collectionView.backgroundColor = .clear
        configureCollectionView()
        calculateSize()
        
    }
    
    private func configureCollectionView() {
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView!.register(ConditionPlateCollectionViewCell.self,
                                 forCellWithReuseIdentifier: ConditionPlateCollectionViewCell.reuseId)
    }
    
    private func calculateSize() {
        //calc plate height
        plateHeight = (view.frame.width - inset * 2 - plateInset * 2) / 3
        let collectionHeight = plateHeight * 2 + inset + plateInset
        view.setHeight(collectionHeight)
    }
    
    private func createPlates() {
        guard let current = location?.current else { return }
        
        plates.append(Plate(image: UIImage(named: "thermometer")!, title: "feels like", detailed: "\(current.feelsLike)"))
        plates.append(Plate(image: UIImage(named: "humidity")!, title: "humidity", detailed: "\(current.humidity)"))
        plates.append(Plate(image: UIImage(named: "uv-index")!, title: "uvi", detailed: "\(current.uvi)"))
        plates.append(Plate(image: UIImage(named: "not-available")!, title: "visibility", detailed: "\(current.visibility)"))
        plates.append(Plate(image: UIImage(named: "cloudy")!, title: "clouds", detailed: "\(current.clouds)"))
        plates.append(Plate(image: UIImage(named: "barometer")!, title: "pressure", detailed: "\(current.pressure)"))

    }

    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return plates.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ConditionPlateCollectionViewCell.reuseId,
                                                      for: indexPath) as! ConditionPlateCollectionViewCell
        
        let plate = plates[indexPath.item]
        cell.configure(image: plate.image, title: plate.title, detailed: plate.detailed)
        return cell
    }
}
    
    //MARK: - UICollectionViewDelegateFlowLayout
extension ConditionPlatesCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: plateHeight, height: plateHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: inset, bottom: inset, right: inset)
    }
}
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
