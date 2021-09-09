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
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentInsetAdjustmentBehavior = .never
        
        let insets = UIEdgeInsets(
            top: navigationController?.navigationBar.frame.height ?? 0,
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
    
    private func addScrollChildren() {
        let head = DetailedHeadViewController()
        head.location = location
        add(head)
        
        let current = DetailedCurrentWeatherViewController()
        current.location = location
        add(current)
    }
}
