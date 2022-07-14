//
//  MovieListViewController.swift
//  OMDB
//
//  Created by ThuanNguyen on 7/14/22.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftMessages
import SVProgressHUD

class MovieListViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var reachability: Reachability?
    let messages = SwiftMessages()
    var movies: [Movie] = [Movie]() {
        didSet {
            self.collectionView.reloadData()
        }
    }
    var currentPage = 1 {
        didSet {
            self.view.isUserInteractionEnabled = false
            SVProgressHUD.show()
            viewModel.loadData(page: currentPage)
            viewModel.dataObservable.asDriver(onErrorJustReturn: nil)
                .drive(onNext: { [weak self] result in
                    guard let self = self else {
                        return
                    }
                    self.view.isUserInteractionEnabled = true
                    SVProgressHUD.dismiss()
                    
                    guard let data = result?.movies,
                          data.count > 0 else {
                        SVProgressHUD.showSuccess(withStatus: "No results!")
                        return
                    }
                    if self.currentPage == 1 {
                        self.movies = data
                    } else {
                        self.movies.append(contentsOf: data)
                    }
                })
                .disposed(by: bag)
        }
    }
    private let bag = DisposeBag()
    
    var viewModel = MovieListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }
    
    private func config() {
        self.configUI()
        self.configReachability()
    }
    
    private func configReachability() {
        reachability = Reachability()
        try? reachability?.startNotifier()
    }
    
    private func configUI() {
        self.title = "Film List"
        self.setupCollectionView()
        self.searchBar.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Reachability.rx.isDisconnected
            .subscribe(onNext:{
                let error = MessageView.viewFromNib(layout: .tabView)
                error.configureTheme(.error)
                error.configureContent(title: "Error", body: "Not connected to the network!")
                error.button?.setTitle("Stop", for: .normal)
                SwiftMessages.show(view: error)
            })
            .disposed(by:bag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

}

extension MovieListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private func setupCollectionView() {
        collectionView.register(UINib(nibName: "MovieCell", bundle: nil), forCellWithReuseIdentifier: MovieCell.identifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let rows = 2
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        
        let spacing = flowLayout.sectionInset.left + flowLayout.sectionInset.right + (flowLayout.minimumInteritemSpacing * CGFloat(rows - 1))
        
        let size = Int((collectionView.bounds.width - spacing) / CGFloat(rows))
        let height = Int((collectionView.bounds.width - spacing) / CGFloat(rows)) * 448 / 300
        return CGSize(width: size, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.identifier, for: indexPath) as? MovieCell {
            cell.configData(movie: movies[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard indexPath.row == movies.count - 1 else {
            return
        }
        self.currentPage += 1
    }
}

extension MovieListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.viewModel.searchText = searchBar.text ?? ""
        self.movies.removeAll()
        self.currentPage.resetToInitialPage()
    }
}
