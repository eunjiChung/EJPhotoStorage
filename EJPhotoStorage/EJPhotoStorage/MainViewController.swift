//
//  MainViewController.swift
//  EJPhotoStorage
//
//  Created by DEV_MOBILE_IOS_JUNIOR on 19/07/2019.
//  Copyright © 2019 DEV_MOBILE_IOS_JUNIOR. All rights reserved.
//

import UIKit
import CHTCollectionViewWaterfallLayout

class MainViewController: UIViewController, CHTCollectionViewDelegateWaterfallLayout, UICollectionViewDataSource, SavePhotoDelegate, UISearchBarDelegate {
    
    // MARK: - Property
    let photos = Photos.init(name: "main")
    var storedPhotos = Photos.init(name: "stored")
    var filteredPhotos = Photos.init(name: "filtered")
    
    var resultImages = Documents.init(with: "result")
    
    // MARK: - IBOutlet
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchResultLabel: UILabel!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        photos.buildDataSource()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setSearchStatus()
    }

    
    // MARK: - Save Photo Delegate
    func saveSelectedPhoto(to album: Photos) {
        storedPhotos = album
        print("Photo Saved!!")
    }
    
    // MARK: - UISearchBar Delegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        
        if let searchKeyword = searchBar.text {
            requestImage(with: searchKeyword)
        }
    }
    
    // MARK: - CollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resultImages.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ResultCollectionViewCell.identifier, for: indexPath) as! ResultCollectionViewCell
        
        let result = resultImages.images[indexPath.item]
        if let image = result.image {
            print("It happened...!")
            cell.imageView.image = image
        }
        
        return cell
    }
    
    // MARK: - CHTCollectionViewWaterfallLayout Delegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        let result = resultImages.images[indexPath.item]
        if let image = result.image {
            return image.size
        }
        
        return CGSize.zero
    }
    
    // MARK: - Request
    // 얘네를 하나로 합쳐...?
    func requestImageAndVclip(with keyword:String) {
        requestImage(with: keyword)
    }
    
    func requestImage(with keyword:String) {
        EJLibrary.shared.requestPhoto(keyword: keyword,
                                      success: { (data, response) in
            self.generateImageModel(response: data, loadMore: false)
            self.requestVclip(with: keyword)
        }) { (error, msg) in
            print(error)
        }
    }
    
    func requestVclip(with keyword: String) {
        EJLibrary.shared.requestVclip(keyword: keyword,
                                      success: { (data, response) in
            self.generateVclipModel(response: data, loadMore: false)
            self.setSearchStatus()
            self.collectionView.reloadData()
        }) { (error, msg) in
            print(error)
        }
    }
    
    func requestLoadMoreImage(with keyword:String) {
    }
    
    func requestLoadMoreVclip() {
        
    }

    
    // MARK: - Private Method
    fileprivate func generateImageModel(response: Any, loadMore: Bool) {
        let imageModel = IMImageModel.init(object: response)
        guard let images = imageModel.documents else { return }
        resultImages.addImageDocument(images)
    }
    
    fileprivate func generateVclipModel(response: Any, loadMore: Bool) {
        let vclipModel = VMVclipModel.init(object: response)
        guard let vclips = vclipModel.documents else { return }
        resultImages.addVclipDocument(vclips)
        resultImages.generateUrlToImage()
    }
    
    
    fileprivate func layout() {
        let waterfallLayout = CHTCollectionViewWaterfallLayout()
        waterfallLayout.minimumColumnSpacing = 2.0
        waterfallLayout.minimumInteritemSpacing = 2.0
        collectionView.collectionViewLayout = waterfallLayout
        
        searchBar.placeholder = "검색어 입력"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier
        {
        case .some("main_detail_segue"):
            if let destination = segue.destination as? MainDetailViewController,
                let cell = sender as? UICollectionViewCell,
                let indexPath = collectionView.indexPath(for: cell) {
                destination.photos = photos
                destination.indexPath = indexPath
                destination.delegate = self
            }
        case "main_storage_segue":
            let destination = segue.destination as! StorageViewController
            destination.photos = storedPhotos
        default:
            super.prepare(for: segue, sender: sender)
        }
    }
    
    fileprivate func setSearchStatus() {
        if resultImages.images.count == 0 {
            searchResultLabel.text = "검색어를 입력해주세요."
        } else {
            searchResultLabel.text = ""
        }
    }
}
