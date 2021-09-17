//
//  ViewController.swift
//  Wezzy
//
//  Created by admin on 25.08.2021.
//

import UIKit
import MapKit

protocol ManageLocationDelegate: AnyObject {
    func addLocation(mapItem: MKMapItem)
}

class LocationsPreviewViewController: UIViewController {

    //MARK: - public properties
    var collectionView: UICollectionView!
    var locations = [Location]()
    var coreDataManager = CoreDataManager.shared
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Locations"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemGray6
        configureCollectionView()
        updateLocations()
    }

    //MARK: - layout configuration
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
        collectionView.register(AddPreviewCollectionViewCell.self, forCellWithReuseIdentifier: AddPreviewCollectionViewCell.reuseId)
        
        collectionView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture)))
    }
    
    //MARK: - private methods
    private func createURLForLocation(with coordinates: CLLocationCoordinate2D, isCelsius: Bool) -> URL {
        let units = isCelsius ? "metric" : "imperial"
        let urlString = "https://api.openweathermap.org/data/2.5/onecall?lat=\(coordinates.latitude)&lon=\(coordinates.longitude)&units=\(units)&exclude=minutely&appid=" + ProcessInfo.processInfo.environment["APIKey"]!
        let url = URL(string: urlString)!
        return url
    }
    
    private func updateLocations() {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            self?.coreDataManager.fetchLocations { (locations) in
                self?.locations = locations
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            }
        }
    }
}

//MARK: - collectionView delegates
extension LocationsPreviewViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = UIScreen.main.bounds.width > 350 ? 350 : UIScreen.main.bounds.width * 0.8
        let height: CGFloat = 175
        
        let frame = CGSize(width: width, height: height)
        
        return frame
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
    }
}

extension LocationsPreviewViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == locations.count {
            let vc = SearchLocationViewController()
            vc.delegate = self
            present(vc, animated: true)
        } else {
            let vc = DetailedViewController()
            vc.location = locations[indexPath.item]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension LocationsPreviewViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //the number of previews and an extra cell for addPreviewv
        return locations.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == locations.count {
            // the last cell is for addPreview
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddPreviewCollectionViewCell.reuseId, for: indexPath) as! AddPreviewCollectionViewCell
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PreviewCollectionViewCell.reuseId, for: indexPath) as! PreviewCollectionViewCell
            let location = locations[indexPath.item]
            
            let differenceComponents = Calendar.current.dateComponents([.minute], from: location.lastUpdate!, to: Date())
            if differenceComponents.minute! > 30 {
                let coords = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longtitude)
                let url = createURLForLocation(with: coords, isCelsius: true)
                RequestManager.shared.fetchJSON(withURL: url) { [weak self] (result: Result<WeatherRoot, Error>) in
                    switch result {
                    case .failure(let error):
                        print(error.localizedDescription)
                    case .success(let model):
                        self?.coreDataManager.updateLocation(location: location, data: model)
                    }
                }
            }
            //TODO: move this logic to cell
            
            let conditionName = WeatherConditionManager.getConditionName(
                id: Int(location.current?.conditionId ?? 0),
                isDay: location.current?.isDay ?? true)
            cell.configureForeground(svgName: conditionName)
            
            cell.backgroundImage.image = #imageLiteral(resourceName: "testImage")
            
            let locationNameWordsArray = location.name!.split(separator: ",")
            var locationBriefName = String(locationNameWordsArray.first!)
            if locationNameWordsArray.count > 1 {
                locationBriefName = String("\(locationNameWordsArray.first!), \(locationNameWordsArray.last!)")
            }
            
            cell.nameLabel.text = locationBriefName
            
            if let current = location.current {
                cell.temperatureLabel.text = "\(current.temperature)℃"
            }
            
            return cell
        }
    }
}

//MARK: - AddPreviewDelegate
extension LocationsPreviewViewController: ManageLocationDelegate {
    func addLocation(mapItem: MKMapItem) {
        
        if locations.contains(where: { $0.name == mapItem.name }) {
            dismiss(animated: true)
            showAlert(title: "This location has already been added to your list", message: nil)
        } else {
            let url = createURLForLocation(with: mapItem.placemark.coordinate, isCelsius: true)
            DispatchQueue.global().async {
                RequestManager.shared.fetchJSON(withURL: url) {
                    [weak self] (result: Result<WeatherRoot, Error>) in
                    
                    switch result {
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self?.showAlert(
                                title: "Connection error",
                                message: "Can't establishe connection with the server. Error: \(error.localizedDescription).")
                        }
                        
                    case .success(let model):
                        
                        guard let self = self else { return }
                        
                        if self.locations.contains(where: { (location) -> Bool in
                            location.name == mapItem.name!
                        }) {
                            self.showAlert(title: "Location \(mapItem.name!) has been already been added!",
                                           message: "You can't add the same location more than once.")
                            return
                        }
                        
                        let newLocation = self.coreDataManager.addLocation(
                                withName: mapItem.name!,
                                data: model,
                                coordinates: mapItem.placemark.coordinate)
                        self.locations.append(newLocation)
                        self.updateLocations()
                    }
                }
            }
        }
    }
}
