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
        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
    }
    
    // MARK: - IBAction
    @IBAction func didTouchCloseBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTouchStoreBtn(_ sender: Any) {
        if let currentImage = currentImage {

            let url:String
            if let detailUrl = currentImage.detailUrl {
                url = detailUrl
            } else {
                url = currentImage.imageUrl!
            }
            
            if storedImageUrls.contains(url) {
                self.presentAlert(title: "알림", message: "이미 저장한 이미지입니다")
            } else {
                self.delegate?.saveSelectedImage(by: url)
                storedImageUrls.append(url)
                self.presentAlert(title: "알림", message: "사진을 보관함에 저장하였습니다")
            }
        }
    }
    
    // MARK: - CollectionView Data Source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return documents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ResultDetailCollectionViewCell.identifier, for: indexPath) as! ResultDetailCollectionViewCell
        
        let image = documents[indexPath.item]
        
        if let detailImage = image.detailUrl {
            cell.imageView.loadImageNone(detailImage)
        } else {
            cell.imageView.loadImageNone(image.imageUrl!)
        }
        cell.imageName.text = ""
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

