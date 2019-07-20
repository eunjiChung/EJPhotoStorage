//
//  ResultDetailViewController.swift
//  EJPhotoStorage
//
//  Created by DEV_MOBILE_IOS_JUNIOR on 19/07/2019.
//  Copyright © 2019 DEV_MOBILE_IOS_JUNIOR. All rights reserved.
//

import UIKit

class MainDetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Property
    var photos: Photos?
    var indexPath : IndexPath?
    
    // MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
    }
    
    // MARK: - IBAction
    @IBAction func didTouchCloseBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTouchStoreBtn(_ sender: Any) {
    }
    
    // MARK: - Private Method
    fileprivate func registerNib() {
        collectionView.register(UINib(nibName: ResultDetailCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: ResultDetailCollectionViewCell.identifier)
    }
    
    // MARK: - CollectionView Data Source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let photos = photos else { return 0 }
        return photos.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ResultDetailCollectionViewCell.identifier, for: indexPath) as! ResultDetailCollectionViewCell
        
        guard let photo = photos?.photos[indexPath.item] else { return cell }
        cell.imageView.image = photo.image
        cell.imageName.text = photo.name
        cell.imageDatetime.text = photo.dateTime
        
        return cell
    }
    
    // MARK: - CollectionView Delegate Flow Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
}
