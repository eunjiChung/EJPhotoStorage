//
//  MainViewController.swift
//  EJPhotoStorage
//
//  Created by DEV_MOBILE_IOS_JUNIOR on 19/07/2019.
//  Copyright © 2019 DEV_MOBILE_IOS_JUNIOR. All rights reserved.
//

import UIKit
import ESPullToRefresh
import CHTCollectionViewWaterfallLayout

enum SearchStatus {
    case initial, searched
}

class MainViewController: BasicViewController, CHTCollectionViewDelegateWaterfallLayout, UICollectionViewDataSource, MainDetailViewDelegate, UISearchBarDelegate {
    
    // MARK: - Property
    var images = Images.init(with: "main")
    var searchedImages: [ImageRecord] = []
    var storedImages: [ImageRecord] = []
    var searchKeyword = ""
    
    // MARK: - IBOutlet
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchResultLabel: UILabel!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
        
        self.collectionView.es.addPullToRefresh { [unowned self] in
            self.requestImages(for: self.searchKeyword)
        }
        
        self.collectionView.es.addInfiniteScrolling { [unowned self] in
            if self.images.isEnd {
                self.presentAlert(title: "알림", message: "목록의 끝입니다.")
                EJLibrary.shared.delayAnimation {
                    self.collectionView.es.stopLoadingMore()
                }
            } else {
                self.requestLoadMoreImages()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setSearchResultLabel(by: .initial)
    }
    
    // MARK: - CollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.imageRecords.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ResultCollectionViewCell.identifier, for: indexPath) as! ResultCollectionViewCell
        
        let imageDetail = images.imageRecords[indexPath.item]
        cell.imageView.image = imageDetail.image

        cell.imageView.loadImage(imageDetail.imageUrl!)

        return cell
    }
    
    
    // MARK: - CHTCollectionViewWaterfallLayout Delegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        let result = images.imageRecords[indexPath.item]
        
        if let width = result.imageWidth, let height = result.imageHeight {
            return CGSize(width: width, height: height)
        }
        
        return result.image.size
    }
    
    
    // MARK: - Save Photo Delegate
    func saveSelectedPhoto(to images: [ImageRecord]) {
        storedImages = images
    }
    
    // MARK: - UISearchBar Delegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Hide Keyboard
        self.view.endEditing(true)
        
        if let searchKeyword = searchBar.text {
            if searchKeyword != "" {
                self.searchKeyword = searchKeyword
                requestImages(for: searchKeyword)
            } else {
                self.presentAlert(title: "입력 오류!", message: "검색어를 입력해주세요!")
            }
        }
    }
    
    // MARK: - Private Method
    fileprivate func requestImages(for keyword: String) {
        EJLibrary.shared.requestImages(keyword: keyword, page: 1, success: { (images) in
            self.images = images
            self.images.sortImagesRecency()
            print("Result!!!!!!!!!!!!!!!!!!", self.images.imageRecords)
            self.images.page = 2
            self.setSearchResultLabel(by: .searched)
            self.collectionView.reloadData()
            self.scrollToTop()
            self.collectionView.es.stopPullToRefresh()
        }) { (error) in
            self.presentAlert(title: "검색 요청 오류", message: error.localizedDescription)
        }
    }
    
    fileprivate func requestLoadMoreImages() {
        EJLibrary.shared.requestImages(keyword: searchKeyword, page: self.images.page+1, success: { (resultImages) in
            self.images.page += 1
            
            self.collectionView.performBatchUpdates({
                let indexPaths = self.indexPathsForLoadMore(by: resultImages.imageRecords)
                self.collectionView.insertItems(at: indexPaths)
                resultImages.sortImagesRecency()
                self.images.appendImageRecords(with: resultImages.imageRecords)
            }, completion: { (result) in
                self.collectionView.es.stopLoadingMore()
            })
        }) { (error) in
            self.presentAlert(title: "추가 요청 오류", message: error.localizedDescription)
        }
    }
    
    
    fileprivate func indexPathsForLoadMore(by resultRecords: [ImageRecord]) -> [IndexPath] {
        var moreIndexPaths: [IndexPath] = []
        let startIndex = images.imageRecords.count
        
        for index in 0..<resultRecords.count {
            let indexPath = IndexPath.init(item: startIndex+index, section: 0)
            moreIndexPaths.append(indexPath)
        }
        
        return moreIndexPaths
    }
    
    fileprivate func layout() {
        let waterfallLayout = CHTCollectionViewWaterfallLayout()
        waterfallLayout.minimumColumnSpacing = 5.0
        waterfallLayout.minimumInteritemSpacing = 5.0
        collectionView.collectionViewLayout = waterfallLayout
        searchBar.placeholder = "검색어 입력"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier
        {
        case .some("main_detail_segue"):
            if let destination = segue.destination as? MainDetailViewController,
                let cell = sender as? UICollectionViewCell, let indexPath = collectionView.indexPath(for: cell) {
                destination.images = images.imageRecords
                destination.indexPath = indexPath
                destination.delegate = self
            }
        case "main_storage_segue":
            let destination = segue.destination as! StorageViewController
            destination.images = storedImages
        default:
            super.prepare(for: segue, sender: sender)
        }
    }
    
    fileprivate func setSearchResultLabel(by status: SearchStatus) {
        
        searchResultLabel.text = ""
        
        switch status {
        case .initial:
            if images.imageRecords.count == 0 {
                searchResultLabel.text = "검색어를 입력해주세요."
            }
        case .searched:
            if images.imageRecords.count == 0 {
                searchResultLabel.text = "검색 결과가 없습니다."
            }
        }
    }
    
    fileprivate func scrollToTop() {
        DispatchQueue.main.async {
            let indexPath = IndexPath(item: 0, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: .top, animated: true)
        }
    }
}
