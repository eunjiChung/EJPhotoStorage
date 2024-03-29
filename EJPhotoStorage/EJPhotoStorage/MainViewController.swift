//
//  MainViewController.swift
//  EJPhotoStorage
//
//  Created by DEV_MOBILE_IOS_JUNIOR on 19/07/2019.
//  Copyright © 2019 DEV_MOBILE_IOS_JUNIOR. All rights reserved.
//

import UIKit
import ESPullToRefresh
enum SearchStatus {
    case initial, loading, searched
}

class MainViewController: BasicViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MainDetailViewDelegate, UISearchBarDelegate {
    
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
            self.collectionView.isUserInteractionEnabled = false
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
        
        cell.imageView.image = UIImage(named: "Placeholder")!
        cell.imageView.loadImageNone(imageDetail.imageUrl!)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "main_detail_segue", sender: indexPath)
    }
    
    // MARK: - CollectionView Delegate Flow Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (EJSizeWidth(collectionView.bounds.width) - 2.0) / 3
        return CGSize(width: width, height: width)
    }

    
    
    // MARK: - Save Photo Delegate
    func saveSelectedImage(by url: String) {
        if let image = imageCache.object(forKey: url as NSString) {
            self.storedImages.append(image)
        } else {
            EJLibrary.shared.downloadImage(with: url) { (image) in
                imageCache.setObject(image, forKey: url as NSString)
                self.storedImages.append(image)
            }
        }
    }
    
    // MARK: - Private Method
    fileprivate func requestImages() {
        EJLibrary.shared.requestImages(searchOperator: self.searchOperator,
                                       success: { (resultOperator) in
                                        
                                        resultOperator.generateData(with: .initial)
                                        
                                        if !resultOperator.isResultEmpty()
                                        {
                                            self.searchOperator = resultOperator
                                            self.setSearchResultLabel(by: .searched)
                                            self.collectionView.reloadData()
                                            
                                            self.scrollToTop()
                                            self.activityIndicator.stopAnimating()
                                            self.collectionView.isUserInteractionEnabled = true
                                            self.collectionView.es.stopPullToRefresh()
                                        } else {
                                            self.activityIndicator.stopAnimating()
                                            self.collectionView.isUserInteractionEnabled = true
                                            self.setSearchResultLabel(by: .searched)
                                        }
                                        
        }) { (error) in
            self.activityIndicator.stopAnimating()
            self.presentAlert(title: "검색 요청 오류", message: error.localizedDescription)
        }
    }
    
    fileprivate func requestLoadMoreImages() {
        
        let startIndex = self.searchOperator.images.count
        searchOperator.goToNextPage()
        EJLibrary.shared.requestImages(searchOperator: self.searchOperator,
                                       success: { (resultOperator) in
                                        resultOperator.generateData(with: .loading)
                                        self.searchOperator = resultOperator
                                        
                                        self.collectionView.performBatchUpdates({
                                            let indexPaths = self.indexPathsForLoadMore(by: startIndex, to: resultOperator.numOfLoadedImages())
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
    
    
    fileprivate func indexPathsForLoadMore(by start:Int, to newImagesCount: Int) -> [IndexPath] {
        var moreIndexPaths: [IndexPath] = []
        
        for index in 0..<newImagesCount {
            let indexPath = IndexPath.init(item: start+index, section: 0)
            moreIndexPaths.append(indexPath)
        }
        
        return moreIndexPaths
    }
    
    fileprivate func layout() {
        searchBar.placeholder = "검색어 입력"
        activityIndicator.hidesWhenStopped = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier
        {
        case .some("main_detail_segue"):
            if let destination = segue.destination as? MainDetailViewController,
                let selectedIndexPath = sender as? IndexPath {
                destination.documents = self.searchOperator.images
                destination.indexPath = selectedIndexPath 
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
