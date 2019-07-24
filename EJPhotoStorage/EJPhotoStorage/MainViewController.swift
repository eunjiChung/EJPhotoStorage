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
    case initial, loading, searched
}

class MainViewController: BasicViewController, CHTCollectionViewDelegateWaterfallLayout, UICollectionViewDataSource, MainDetailViewDelegate, UISearchBarDelegate {
    
    // MARK: - Property
    var searchOperator = SearchOperator.init()
    var storedImages: [UIImage] = []
    
    // MARK: - IBOutlet
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchResultLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
        
        self.collectionView.es.addPullToRefresh { [unowned self] in
            self.searchOperator.reset()
            self.requestImages()
        }
        
        self.collectionView.es.addInfiniteScrolling { [unowned self] in
            if self.searchOperator.isAllRequestEnd() {
                
                self.presentAlert(title: "알림", message: "모든 결과를 불러왔습니다.")
                
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
    
    // MARK: - UISearchBar Delegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Hide Keyboard
        self.view.endEditing(true)
        activityIndicator.startAnimating()
        
        if let searchKeyword = searchBar.text {
            if searchKeyword != "" {
                searchOperator = SearchOperator.init(with: searchKeyword)
                setSearchResultLabel(by: .loading)
                requestImages()
            } else {
                self.presentAlert(title: "입력 오류!", message: "검색어를 입력해주세요!")
            }
        }
    }
    
    // MARK: - CollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchOperator.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ResultCollectionViewCell.identifier, for: indexPath) as! ResultCollectionViewCell
        
        let imageDetail = searchOperator.images[indexPath.item]
        cell.imageView.image = UIImage(named: "Placeholder")! // 이거 클래스에서 바꿀 순 없나? 구조체라서 안되나..?
        
        cell.imageView.loadImageCrossDissolve(imageDetail.imageUrl!)
        
        return cell
    }
    
    
    // MARK: - CHTCollectionViewWaterfallLayout Delegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        let result = searchOperator.images[indexPath.item]
        
        if let width = result.width, let height = result.height {
            return CGSize(width: width, height: height)
        }
        
        return UIImage(named: "Placeholder")?.size ?? CGSize.zero
    }
    
    
    // MARK: - Save Photo Delegate
    func saveSelectedImage(by url: String) {
        EJLibrary.shared.downloadImage(with: url) { (image) in
            self.storedImages.append(image)
        }
    }
    
    // MARK: - Private Method
    fileprivate func requestImages() {
        EJLibrary.shared.requestImages(searchOperator: self.searchOperator,
                                       success: { (resultOperator) in
                                        
                                        resultOperator.decodeData(with: .initial)
                                        resultOperator.combineResults()
                                        
                                        if !resultOperator.isResultEmpty()
                                        {
                                            self.setSearchResultLabel(by: .searched)
                                            self.collectionView.reloadData()
                                            
//                                            self.scrollToTop()
                                            self.activityIndicator.stopAnimating()
                                            self.collectionView.es.stopPullToRefresh()
                                        } else {
                                            self.activityIndicator.stopAnimating()
                                            self.setSearchResultLabel(by: .searched)
                                        }
                                        
        }) { (error) in
            self.activityIndicator.stopAnimating()
            self.presentAlert(title: "검색 요청 오류", message: error.localizedDescription)
        }
    }
    
    fileprivate func requestLoadMoreImages() {
        
        searchOperator.nextPage()
        
        EJLibrary.shared.requestImages(searchOperator: self.searchOperator,
                                       success: { (resultOperator) in
                                        
                                        resultOperator.decodeData(with: .loading)
                                        resultOperator.appendNewResult()
                                        resultOperator.combineResults()
                                        
                                        self.collectionView.performBatchUpdates({
                                            // 안돼 ㅠㅠ 새로운 이미지만 넣어야해....
                                            let indexPaths = self.indexPathsForLoadMore(by: resultOperator.numOfLoadedImages())
                                            self.collectionView.insertItems(at: indexPaths)
                                            self.activityIndicator.stopAnimating()
                                        }, completion: { (result) in
                                            self.activityIndicator.stopAnimating()
                                            self.collectionView.es.stopLoadingMore()
                                        })
        }) { (error) in
            self.activityIndicator.stopAnimating()
            self.presentAlert(title: "추가 요청 오류", message: error.localizedDescription)
        }
    }
    
    
    fileprivate func indexPathsForLoadMore(by newImagesCount: Int) -> [IndexPath] {
        var moreIndexPaths: [IndexPath] = []
        let startIndex = self.searchOperator.images.count
        
        for index in 0..<newImagesCount {
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
        activityIndicator.hidesWhenStopped = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier
        {
        case .some("main_detail_segue"):
            if let destination = segue.destination as? MainDetailViewController,
                let cell = sender as? UICollectionViewCell, let indexPath = collectionView.indexPath(for: cell) {
                destination.documents = self.searchOperator.images
                destination.indexPath = indexPath // 이게 동작을 안하나...?
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
            if searchOperator.isDocumentEmpty() {
                searchResultLabel.text = "검색어를 입력해주세요."
            }
        case .searched:
            if searchOperator.isResultEmpty() {
                searchResultLabel.text = "검색 결과가 없습니다."
            }
        case .loading:
            searchResultLabel.text = ""
        }
    }
    
    fileprivate func scrollToTop() {
        DispatchQueue.main.async {
            let indexPath = IndexPath(item: 0, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: .top, animated: true)
        }
    }
}
