//
//  ResultDetailViewController.swift
//  EJPhotoStorage
//
//  Created by DEV_MOBILE_IOS_JUNIOR on 19/07/2019.
//  Copyright © 2019 DEV_MOBILE_IOS_JUNIOR. All rights reserved.
//

import UIKit

protocol MainDetailViewDelegate: class {
    func saveSelectedPhoto(to images: [ImageRecord])
}

class MainDetailViewController: BasicViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Delegate
    weak var delegate: MainDetailViewDelegate?
    
    // MARK: - Property
    var images: [ImageRecord]?
    var storedImages = [ImageRecord]()
    var currentImage : ImageRecord?
    var indexPath : IndexPath?
    
    // MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Alc Of Layout Constraints
    @IBOutlet weak var alcHeightOfNaviView: NSLayoutConstraint!
    
    
    // MARK: - Status Bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib()
        alcHeightOfNaviView.constant = EJSizeHeight(56.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 알아보자...
        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
    }
    
    // MARK: - IBAction
    @IBAction func didTouchCloseBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTouchStoreBtn(_ sender: Any) {
        if let currentImage = currentImage, let imageUrl = currentImage.imageUrl {
            // Set으로 다루기
            if !storedImages.contains(currentImage) {
                EJLibrary.shared.downloadImage(with:imageUrl) { (image) in
                    currentImage.image = image
                    self.storedImages.append(currentImage)
                    self.delegate?.saveSelectedPhoto(to: self.storedImages)
                    // 토스트 띄워보기...
                }
            }
        }
    }
    
    // MARK: - CollectionView Data Source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let images = images else { return 0 }
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ResultDetailCollectionViewCell.identifier, for: indexPath) as! ResultDetailCollectionViewCell
        
        guard let imageRecord = images?[indexPath.item] else { return cell }
        currentImage = imageRecord
        cell.imageView.loadImage(imageRecord.imageUrl!)
        cell.imageName.text = ""
        cell.imageDatetime.text = imageRecord.dateTimeString()
        
        return cell
    }
    
    // MARK: - CollectionView Delegate Flow Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 그냥 collectionView.bounds.size하면 무조건 처음 설정된 값이 나오면서
        // 셀 크기가 고정된다!!
        let width = collectionView.bounds.size.width
        let height = collectionView.bounds.size.height
        let cellCGSize = CGSize(width: EJSizeWidth(width), height: EJSizeHeight(height))
        return cellCGSize
    }
    
    // MARK: - Private Method
    fileprivate func registerNib() {
        collectionView.register(UINib(nibName: ResultDetailCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: ResultDetailCollectionViewCell.identifier)
    }
}
