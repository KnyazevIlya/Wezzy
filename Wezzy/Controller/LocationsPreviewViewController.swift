//
//  ViewController.swift
//  Wezzy
//
//  Created by admin on 25.08.2021.
//

import UIKit
import MapKit

protocol AddPreviewDelegate: AnyObject {
    func add(mapItem: MKMapItem)
}

class LocationsPreviewViewController: UIViewController {

    //MARK: - public properties
    var collectionView: UICollectionView!
    
    //MARK: - private properties
    private var previews = [WeatherPreview]()
    private var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGray6
        configureCollectionView()
        updatePreviews()
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
    private func createURLForPreview(with coordinates: CLLocationCoordinate2D, isCelsius: Bool) -> URL {
        let units = isCelsius ? "metric" : "imperial"
        let urlString = "https://api.openweathermap.org/data/2.5/onecall?lat=\(coordinates.latitude)&lon=\(coordinates.longitude)&units=\(units)&exclude=hourly,daily&appid=" + ProcessInfo.processInfo.environment["APIKey"]!
        let url = URL(string: urlString)!
        return url
    }
    
    private func updateContext() {
        do {
            try context.save()
        } catch {
            
        }
    }
    
    private func fetchPreviews(completion: ([WeatherPreview]) -> Void) {
        do {
            let results = try context.fetch(WeatherPreview.fetchRequest()) as! [WeatherPreview]
            completion(results)
        } catch {
            fatalError("Unable to fetch the locations from the persistant storage, try to launch the app again!")
        }
    }
    
    private func addPreview(withName name: String, data: CWRoot, coordinates: CLLocationCoordinate2D) {
        let newPreview = WeatherPreview(context: context)
        
        newPreview.name = name
        newPreview.lat = coordinates.latitude
        newPreview.lon = coordinates.longitude
        newPreview.temperature = Int64(data.current.temp)
        newPreview.conditionId = "\(data.current.weather[0].id)"
        newPreview.lastUpdate = Date()
        
        updateContext()
    }
    
    private func updatePreviews() {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            self?.fetchPreviews { (previews) in
                self?.previews = previews
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
        if indexPath.item == previews.count {
            let vc = SearchLocationViewController()
            vc.delegate = self
            present(vc, animated: true)
        }
    }
}

extension LocationsPreviewViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //the number of previews and an extra cell for addPreviewv
        return previews.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == previews.count {
            // the last cell is for addPreview
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddPreviewCollectionViewCell.reuseId, for: indexPath) as! AddPreviewCollectionViewCell
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PreviewCollectionViewCell.reuseId, for: indexPath) as! PreviewCollectionViewCell
            let preview = previews[indexPath.item]
            
            let differenceComponents = Calendar.current.dateComponents([.minute], from: preview.lastUpdate!, to: Date())
            if differenceComponents.minute! > 30 {
                let coords = CLLocationCoordinate2D(latitude: preview.lat, longitude: preview.lon)
                let url = createURLForPreview(with: coords, isCelsius: true)
                RequestManager.shared.fetchJSON(withURL: url) { [weak self] (result: Result<CWRoot, Error>) in
                    switch result {
                    case .failure(let error):
                        print(error.localizedDescription)
                    case .success(let model):
                        print("data updated from \(preview.lastUpdate!.description) to \(Date().description)")
                        preview.lastUpdate = Date()
                        preview.temperature = Int64(model.current.temp)
                        preview.conditionId = "\(model.current.weather[0].id)"
                        self?.updateContext()
                    }
                }
            }
            //TODO: move this logic to cell
            let id = preview.conditionId!
            if let conditionNameTuple = WeatherConditionManager.conditions[id] {
                let conditionName = (conditionNameTuple as! [String])[0]
                cell.configureForeground(svgName: conditionName)
            } else {
                cell.configureForeground(svgName: "not-available")
            }
            
            cell.backgroundImage.image = #imageLiteral(resourceName: "testImage")
            cell.nameLabel.text = preview.name
            cell.temperatureLabel.text = "\(preview.temperature)℃"
            return cell
        }
    }
}

//MARK: - AddPreviewDelegate
extension LocationsPreviewViewController: AddPreviewDelegate {
    func add(mapItem: MKMapItem) {
        let url = createURLForPreview(with: mapItem.placemark.coordinate, isCelsius: true)
        DispatchQueue.global().async {
            RequestManager.shared.fetchJSON(withURL: url) { [weak self] (result: Result<CWRoot, Error>) in
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                    //TODO: - show error alert
                case .success(let model):
                    self?.addPreview(withName: mapItem.name!, data: model, coordinates: mapItem.placemark.coordinate)
                    self?.updatePreviews()
                }
            }
        }
    }
}
