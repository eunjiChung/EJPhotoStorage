//
//  StorageViewController.swift
//  EJPhotoStorage
//
//  Created by DEV_MOBILE_IOS_JUNIOR on 19/07/2019.
//  Copyright © 2019 DEV_MOBILE_IOS_JUNIOR. All rights reserved.
//

import UIKit

class StorageViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Property
    var photos: Photos?
    let cellId = StorageCollectionViewCell.identifier

    // MARK: - IBOutlet
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib()
    }
    
    // MARK: - Private Method
    fileprivate func registerNib() {
        collectionView.register(UINib(nibName: cellId, bundle: nil), forCellWithReuseIdentifier: cellId)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "storage_detail_segue" {
            let destination = segue.destination as! StorageDetailViewController
            destination.storedPhotos = photos
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
    
    // MARK: - CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "storage_detail_segue", sender: self)
    }
    
    // MARK: - CollectionView Delegate Flow Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 2.0) / 3
        return CGSize(width: width, height: width)
    }

}
