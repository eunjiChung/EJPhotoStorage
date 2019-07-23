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
    var images: [ImageRecord]?
    var indexPath: IndexPath?
    var currentImage: ImageRecord?
    
    // MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    // MARK: - Status Bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib()
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
        guard let image = currentImage?.image else { return }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    // MARK: - Private Method
    fileprivate func registerNib() {
        collectionView.register(UINib(nibName: "PhotoDetailCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PhotoDetailCollectionViewCell")
    }
    
    @objc fileprivate func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
//            Toast(message: error.localizedDescription).show()
            self.presentAlert(title: "주의", message: "사진 저장에 오류가 발생했습니다. \n \(error.localizedDescription)")
        } else {
            self.presentAlert(title: "알림", message: "사진 저장이 완료되었습니다.")
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
        
        guard let imageRecord = images?[indexPath.item] else { return cell }
        cell.imageView.image = imageRecord.image
        cell.imageName.text = ""
        cell.imageDatetime.text = imageRecord.dateTimeString()
        currentImage = imageRecord
        
        return cell
    }
    
    // MARK: - UICollectionView Delegate Flow Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }

}
