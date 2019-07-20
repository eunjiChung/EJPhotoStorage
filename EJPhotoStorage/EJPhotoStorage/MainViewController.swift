//
//  MainViewController.swift
//  EJPhotoStorage
//
//  Created by DEV_MOBILE_IOS_JUNIOR on 19/07/2019.
//  Copyright © 2019 DEV_MOBILE_IOS_JUNIOR. All rights reserved.
//

import UIKit
import CHTCollectionViewWaterfallLayout

class MainViewController: UIViewController, CHTCollectionViewDelegateWaterfallLayout, UICollectionViewDataSource, SavePhotoDelegate, UISearchResultsUpdating {
    
    // MARK: - Property
    let photos = Photos.init(name: "main")
    var storedPhotos = Photos.init(name: "stored")
    var filteredPhotos = Photos.init(name: "filtered")
    
    let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - IBOutlet
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photos.buildDataSource()
        layout()
        searchControllerSetting()
    }
    
    // MARK: - Private Method
    fileprivate func layout() {
        let waterfallLayout = CHTCollectionViewWaterfallLayout()
        waterfallLayout.minimumColumnSpacing = 2.0
        waterfallLayout.minimumInteritemSpacing = 2.0
        collectionView.collectionViewLayout = waterfallLayout
    }
    
    fileprivate func searchControllerSetting() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "검색어 입력"
        definesPresentationContext = true //...?
        navigationItem.searchController = searchController
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier
        {
        case .some("main_detail_segue"):
            if let destination = segue.destination as? MainDetailViewController,
                let cell = sender as? UICollectionViewCell,
                let indexPath = collectionView.indexPath(for: cell) {
                destination.photos = photos
                destination.indexPath = indexPath
                destination.delegate = self
            }
        case "main_storage_segue":
            let destination = segue.destination as! StorageViewController
            destination.photos = storedPhotos
        default:
            super.prepare(for: segue, sender: sender)
        }
    }
    
    // MARK: - UISearchResultUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        print(text)
    }
    
    // MARK: - Save Photo Delegate
    func saveSelectedPhoto(to album: Photos) {
        storedPhotos = album
        print("Photo Saved!!")
    }
    
    // MARK: - CollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ResultCollectionViewCell.identifier, for: indexPath) as! ResultCollectionViewCell
        cell.imageView.image = photos.photos[indexPath.item].image
        return cell
    }
    
    // MARK: - CHTCollectionViewWaterfallLayout Delegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return photos.photos[indexPath.item].image.size
    }
}
