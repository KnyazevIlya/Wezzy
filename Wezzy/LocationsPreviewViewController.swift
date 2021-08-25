//
//  ViewController.swift
//  Wezzy
//
//  Created by admin on 25.08.2021.
//

import UIKit

class LocationsPreviewViewController: UIViewController {

    var collectionView: UICollectionView!
    
    private var previews = [Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemGray6
        configureCollectionView()
    }

    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        collectionView = UICollectionView(frame: view.safeAreaLayoutGuide.layoutFrame, collectionViewLayout: layout)
        collectionView.contentInset.top = view.safeAreaInsets.top
        collectionView.backgroundColor = .red
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }

}

extension LocationsPreviewViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return previews.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    
}
