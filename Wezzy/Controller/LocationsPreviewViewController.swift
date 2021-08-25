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
        collectionView.backgroundColor = .systemGray6
        
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(PreviewCollectionViewCell.self, forCellWithReuseIdentifier: PreviewCollectionViewCell.reuseId)
    }

}

extension LocationsPreviewViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return previews.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PreviewCollectionViewCell.reuseId, for: indexPath) as! PreviewCollectionViewCell
        
        cell.backgroundColor = .systemGray4
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = UIScreen.main.bounds.width > 400 ? 400 : UIScreen.main.bounds.width * 0.8
        let height: CGFloat = 175
        
        let frame = CGSize(width: width, height: height)
        
        return frame
    }
}
