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
    var images: [ImageRecord]?
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
                let cell = sender as? UICollectionViewCell,
                let indexPath = collectionView.indexPath(for: cell) {
                destination.images = images
                destination.indexPath = indexPath
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
        
        // 여기는 진짜 저장된 이미지들을 저장!
        if let images = images {
            let image = images[indexPath.item]
            cell.imageView.loadImageNone(image.imageUrl!)
        }
        
        return cell
    }
    
    // MARK: - CollectionView Delegate Flow Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 2.0) / 3
        return CGSize(width: width, height: width)
    }

}
