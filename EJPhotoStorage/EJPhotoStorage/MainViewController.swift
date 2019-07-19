//
//  MainViewController.swift
//  EJPhotoStorage
//
//  Created by DEV_MOBILE_IOS_JUNIOR on 19/07/2019.
//  Copyright © 2019 DEV_MOBILE_IOS_JUNIOR. All rights reserved.
//

import UIKit
import CHTCollectionViewWaterfallLayout

class MainViewController: UIViewController, CHTCollectionViewDelegateWaterfallLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: - Property
    let photos = Photos.init(name: "main")
    var filteredPhotos = Photos.init(name: "filtered")
    
    // MARK: - IBOutlet
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photos.buildDataSource()
        registerNib()
        layout()
        
        filteredPhotos = photos
    }
    
    // MARK: - Private Method
    fileprivate func registerNib() {
        collectionView.register(UINib(nibName: "ResultCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: ResultCollectionViewCell.identifier)
    }
    
    fileprivate func layout() {
        let waterfallLayout = CHTCollectionViewWaterfallLayout()
        waterfallLayout.minimumColumnSpacing = 5.0
        waterfallLayout.minimumInteritemSpacing = 5.0
        
        collectionView.collectionViewLayout = waterfallLayout
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier
        {
        case "main_detail_segue":
            let destination = segue.destination as! ResultDetailViewController
            destination.photos = photos
        case "main_storage_segue":
            let destination = segue.destination as! StorageViewController
            destination.photos = filteredPhotos
        default:
            print("Nothing...")
        }
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
    
    // MARK: - CollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "main_detail_segue", sender: self)
    }
    
    // MARK: - CHTCollectionViewWaterfallLayout Delegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return photos.photos[indexPath.item].image.size
    }
}
