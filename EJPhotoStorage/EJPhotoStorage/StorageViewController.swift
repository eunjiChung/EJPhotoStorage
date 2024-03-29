//
//  StorageViewController.swift
//  EJPhotoStorage
//
//  Created by DEV_MOBILE_IOS_JUNIOR on 19/07/2019.
//  Copyright © 2019 DEV_MOBILE_IOS_JUNIOR. All rights reserved.
//

import UIKit

class StorageViewController: BasicViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Property
    var images: [UIImage]?
    let cellId = StorageCollectionViewCell.identifier

    // MARK: - IBOutlet
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var noImageDescLabel: UILabel!
    
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if images?.count == 0 {
            noImageDescLabel.text = "저장된 이미지가 없습니다."
        } else {
            noImageDescLabel.text = ""
        }
    }
    
    // MARK: - Private Method
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "storage_detail_segue" {
            if let destination = segue.destination as? StorageDetailViewController,
                let selectedIndexPath = sender as? IndexPath {
                destination.images = images
                destination.indexPath = selectedIndexPath
            }
        }
    }
    
    // MARK: - CollectionView DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let images = images {
            return images.count
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! StorageCollectionViewCell
        
        if let images = images {
            let image = images[indexPath.item]
            cell.imageView.image = image
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "storage_detail_segue", sender: indexPath)
    }
    
    // MARK: - CollectionView Delegate Flow Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (EJSizeWidth(collectionView.bounds.width) - 2.0) / 3
        return CGSize(width: width, height: width)
    }

}
