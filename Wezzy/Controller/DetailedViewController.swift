//
//  DetailedViewController.swift
//  Wezzy
//
//  Created by admin on 02.09.2021.
//

import UIKit

class DetailedViewController: UIViewController {

    var preview: WeatherPreview?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    private func configureView() {
        let effectView = UIVisualEffectView(effect:UIBlurEffect(style: .systemUltraThinMaterialDark))
        effectView.translatesAutoresizingMaskIntoConstraints = false
        effectView.frame = view.bounds
        view.addSubview(effectView)
        
        let scrollView = UIScrollView(frame: view.bounds)
        view.addSubview(scrollView)
        
        view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "testImage"))
    }
}
