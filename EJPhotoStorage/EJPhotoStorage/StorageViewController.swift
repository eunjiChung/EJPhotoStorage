//
//  StorageViewController.swift
//  EJPhotoStorage
//
//  Created by DEV_MOBILE_IOS_JUNIOR on 19/07/2019.
//  Copyright © 2019 DEV_MOBILE_IOS_JUNIOR. All rights reserved.
//

import UIKit

class StorageViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Property
    var photos: Photos?
    let cellId = StorageCollectionViewCell.identifier

    // MARK: - IBOutlet
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Private Method
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "storage_detail_segue" {
            if let destination = segue.destination as? StorageDetailViewController,
                let cell = sender as? UICollectionViewCell,
                let indexPath = collectionView.indexPath(for: cell) {
                destination.storedPhotos = photos
                destination.indexPath = indexPath
            }
        }
    }
    
    // MARK: - CollectionView DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let photos = photos {
            return photos.photos.count
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! StorageCollectionViewCell
        
        if let photos = photos {
            cell.imageView.image = photos.photos[indexPath.item].image
        }
        
        return cell
    }
    
    // MARK: - CollectionView Delegate Flow Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 2.0) / 3
        return CGSize(width: width, height: width)
    }

}
