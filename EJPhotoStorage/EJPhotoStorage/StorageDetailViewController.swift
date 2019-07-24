//
//  StorageDetailViewController.swift
//  EJPhotoStorage
//
//  Created by DEV_MOBILE_IOS_JUNIOR on 19/07/2019.
//  Copyright © 2019 DEV_MOBILE_IOS_JUNIOR. All rights reserved.
//

import UIKit

class StorageDetailViewController: BasicViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    // MARK: - Property
    var images: [UIImage]?
    var indexPath: IndexPath?
    var currentImage: UIImage?
    
    // MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Alc Of Layout Constraints
    @IBOutlet weak var alcBottomOfSaveButton: NSLayoutConstraint!
    @IBOutlet weak var alcTopOfSaveButton: NSLayoutConstraint!
    @IBOutlet weak var alcLeadingOfSaveButton: NSLayoutConstraint!
    @IBOutlet weak var alcTrailingOfCloseButton: NSLayoutConstraint!
    
    
    // MARK: - Status Bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
    }
    
    // MARK: - IBActions
    @IBAction func didTouchCloseBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTouchStoreBtn(_ sender: Any) {
        if let image = currentImage {
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoDetailCollectionViewCell.identifier, for: indexPath) as! PhotoDetailCollectionViewCell
        
        guard let image = images?[indexPath.item] else { return cell }
        cell.imageView.image = image
        currentImage = image
        
        return cell
    }
    
    // MARK: - UICollectionView Delegate Flow Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.size.width
        let height = collectionView.bounds.size.height
        let cellCGSize = CGSize(width: EJSizeWidth(width), height: EJSizeHeight(height))
        return cellCGSize
    }
    
    // MARK: - Private Method
    fileprivate func registerNib() {
        collectionView.register(UINib(nibName: "PhotoDetailCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PhotoDetailCollectionViewCell")
    }
    
    @objc fileprivate func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            //            Toast(message: error.localizedDescription).show()
            self.presentAlert(title: "주의", message: "사진을 저장할 수 없습니다. \n 사진첩 접근을 허용해주십시오. \n \(error.localizedDescription)")
        } else {
            self.presentAlert(title: "알림", message: "사진이 앨범에 저장되었습니다.")
        }
    }
    
    fileprivate func layout() {
        alcTopOfSaveButton.constant = EJSizeHeight(11.0)
        alcLeadingOfSaveButton.constant = EJSizeWidth(25.0)
        alcBottomOfSaveButton.constant = EJSizeHeight(12.0)
        alcTrailingOfCloseButton.constant = EJSizeWidth(25.0)
    }
    
}
