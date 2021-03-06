//
//  DetailedViewController.swift
//  Wezzy
//
//  Created by admin on 02.09.2021.
//

import UIKit
import SpriteKit

class DetailedViewController: UIViewController {

    var location: Location?
    var previewImage: UIImage = #imageLiteral(resourceName: "testImage")
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentInsetAdjustmentBehavior = .never
        
        var safeAreaTopInset: CGFloat = 0
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.first!
            safeAreaTopInset = window.safeAreaInsets.top
        }
        
        let insets = UIEdgeInsets(
            top: (navigationController?.navigationBar.frame.height ?? 0)/2 + safeAreaTopInset,
            left: 0,
            bottom: 0,
            right: 0)
        scrollView.contentInset = insets
        scrollView.scrollIndicatorInsets = insets
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    lazy var contentStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureScrollView()
        setupScrollViewConstraints()
        addScrollChildren()
    }
    
    private func configureView() {
        view.addBluredBackground(colorSchemeImage: #imageLiteral(resourceName: "testImage"), style: .light)
        addSprite()
    }
    
    private func configureScrollView() {
        // configure view hierarchy
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(contentStackView)
    }
    
    private func setupScrollViewConstraints() {
        //setup scroll view constraints
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor)
        ])
        
        //setup content view constraints
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        //setup content stack view constraints
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            contentStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor)
        ])
    }
    
    private func addSprite() {
        guard let preview = location else { return }
        var conditionSpriteName: String? = nil
        
        if preview.current?.isRain ?? false {
            conditionSpriteName = "Rain.sks"
        } else if preview.current?.isSnow ?? false {
            conditionSpriteName = "Snow.sks"
        }
        
        if conditionSpriteName != nil {
            let skView = SKView()
            skView.translatesAutoresizingMaskIntoConstraints = false
            skView.backgroundColor = .clear
            contentView.addSubview(skView)
            
            NSLayoutConstraint.activate([
                skView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -(navigationController?.navigationBar.frame.height ?? 0) - 200),
                skView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
                skView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 200),
                skView.leftAnchor.constraint(equalTo: contentView.leftAnchor)
            ])
            
            let scene = SKScene(size: view.bounds.size)
                    
            scene.anchorPoint = CGPoint(x: 0.5, y: 1)
            scene.backgroundColor = .clear
                    
            guard let sprite = SKEmitterNode(fileNamed: conditionSpriteName!) else { return }
            sprite.particlePositionRange.dx = UIScreen.main.bounds.width
                    
            scene.addChild(sprite)
            skView.presentScene(scene)
        }
    }
    
    //MARK: - color managing
    private func createAverageColor(completion: @escaping (UIColor) -> Void) {
        guard let image = previewImage.cgImage else { return }
        var uiColor: UIColor = .black
        DispatchQueue.global(qos: .userInteractive).async {
            let processor = ImageProcessingManager.shared
            let colorData = processor.getAverageColor(forCGImage: image)
            uiColor = UIColor(red: CGFloat(colorData.r) / 255,
                                  green: CGFloat(colorData.g) / 255,
                                  blue: CGFloat(colorData.b) / 255,
                                  alpha: 1)
            
            completion(uiColor)
        }
    }
    
    //configure child vcs
    private func addScrollChildren() {
        let head = DetailedHeadViewController()
        head.location = location
        head.previewImage = previewImage
        add(head)
        
        let plates = ConditionPlatesCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        plates.location = location
        add(plates)
        
        createAverageColor { color in
            DispatchQueue.main.async {
                head.mainColor = color
                plates.mainColor = color
            }
        }
    }
}
