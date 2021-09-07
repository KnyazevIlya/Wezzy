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
    
    //MARK: - private properties
    private var locations = [Location]()
    private var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
    }
    
    //MARK: - private methods
    private func createURLForLocation(with coordinates: CLLocationCoordinate2D, isCelsius: Bool) -> URL {
        let units = isCelsius ? "metric" : "imperial"
        let urlString = "https://api.openweathermap.org/data/2.5/onecall?lat=\(coordinates.latitude)&lon=\(coordinates.longitude)&units=\(units)&exclude=minutely&appid=" + ProcessInfo.processInfo.environment["APIKey"]!
        let url = URL(string: urlString)!
        return url
    }
    
    //MARK: - CoreData managing
    private func updateContext() {
        do {
            try context.save()
        } catch {
            
        }
    }
    
    private func fetchLocations(completion: ([Location]) -> Void) {
        do {
            let results = try context.fetch(Location.fetchRequest()) as! [Location]
            completion(results)
        } catch {
            fatalError("Unable to fetch the locations from the persistant storage, try to launch the app again!")
        }
    }
    
    private func addLocation(withName name: String, data: WeatherRoot, coordinates: CLLocationCoordinate2D) {
        let newLocation = Location(context: context)
        let currentWeather = CurrentWeather(context: context)
        
        newLocation.current = currentWeather
        
        newLocation.name = name
        newLocation.latitude = coordinates.latitude
        newLocation.longtitude = coordinates.longitude
        newLocation.lastUpdate = Date()
        
        updateLocation(location: newLocation, data: data)
    }
    
    private func updateLocation(location: Location, data: WeatherRoot) {
        
        location.lastUpdate = Date()
        
        location.current?.temperature = Int64(data.current.temp)
        location.current?.currentTime = Int64(data.current.dt)
        location.current?.sunrise = Int64(data.current.sunrise)
        location.current?.sunset = Int64(data.current.sunset)
        location.current?.conditionId = Int64(data.current.weather[0].id)
        
        updateContext()
    }
    
    private func updateLocations() {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            self?.fetchLocations { (locations) in
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
                        self?.updateLocation(location: location, data: model)
                    }
                }
            }
            //TODO: move this logic to cell
            
            let id = location.current?.conditionId ?? 0
            if let conditionNameTuple = WeatherConditionManager.conditions[Int(id)] {
                let daytimeCode = location.current?.isDay ?? true ? 0 : 1
                let conditionName = conditionNameTuple[daytimeCode]
                cell.configureForeground(svgName: conditionName)
            } else {
                cell.configureForeground(svgName: "not-available")
            }
            
            cell.backgroundImage.image = #imageLiteral(resourceName: "testImage")
            cell.nameLabel.text = location.name
            
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
                        self?.addLocation(withName: mapItem.name!, data: model, coordinates: mapItem.placemark.coordinate)
                        self?.updateLocations()
                    }
                }
            }
        }
    }
}
