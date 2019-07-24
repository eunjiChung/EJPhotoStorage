//
//  ResultDetailViewController.swift
//  EJPhotoStorage
//
//  Created by DEV_MOBILE_IOS_JUNIOR on 19/07/2019.
//  Copyright © 2019 DEV_MOBILE_IOS_JUNIOR. All rights reserved.
//

import UIKit

protocol MainDetailViewDelegate: class {
    func saveSelectedImage(by url: String)
}

class MainDetailViewController: BasicViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Delegate
    weak var delegate: MainDetailViewDelegate?
    
    // MARK: - Property
    var documents = [Document]()
    var storedImageUrls = [String]()
    var currentImage : Document?
    var indexPath : IndexPath?
    
    // MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Alc Of Layout Constraints
    @IBOutlet weak var alcHeightOfNaviView: NSLayoutConstraint!
    @IBOutlet weak var alcTopOfSaveButton: NSLayoutConstraint!
    
    @IBOutlet weak var alcLeadingOfSaveButton: NSLayoutConstraint!
    @IBOutlet weak var alcBottomOfSaveButton: NSLayoutConstraint!
    @IBOutlet weak var alcTrailingOfCloseButton: NSLayoutConstraint!
    
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
        // 알아보자...
        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
    }
    
    // MARK: - IBAction
    @IBAction func didTouchCloseBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTouchStoreBtn(_ sender: Any) {
        if let currentImage = currentImage,
            !storedImageUrls.contains(currentImage.imageUrl) {
            self.delegate?.saveSelectedImage(by: currentImage.imageUrl)
        }
    }
    
    // MARK: - CollectionView Data Source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return documents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ResultDetailCollectionViewCell.identifier, for: indexPath) as! ResultDetailCollectionViewCell
        
        let image = documents[indexPath.item]
        cell.imageView.loadImageNone(image.imageUrl)
        cell.imageName.text = "이미지"
        cell.imageDatetime.text = image.dateToString()
        
        currentImage = image
        
        return cell
    }
    
    // MARK: - CollectionView Delegate Flow Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.size.width
        let height = collectionView.bounds.size.height
        let cellCGSize = CGSize(width: EJSizeWidth(width), height: EJSizeHeight(height))
        return cellCGSize
    }
    
    // MARK: - Private Method
    fileprivate func registerNib() {
        collectionView.register(UINib(nibName: ResultDetailCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: ResultDetailCollectionViewCell.identifier)
    }
    
    fileprivate func layout() {
        alcHeightOfNaviView.constant = EJSizeHeight(56.0)
        alcTopOfSaveButton.constant = EJSizeHeight(11.0)
        alcLeadingOfSaveButton.constant = EJSizeWidth(25.0)
        alcBottomOfSaveButton.constant = EJSizeHeight(12.0)
        alcTrailingOfCloseButton.constant = EJSizeWidth(25.0)
    }
}

