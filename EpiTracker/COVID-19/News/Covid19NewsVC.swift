//
//  Covid19DetectionVC.swift
//  EpiTracker
//
//  Created by Artem Evdokimov on 25.05.20.
//  Copyright © 2020 Artem Evdokimov. All rights reserved.
//

import UIKit
import SafariServices

class Covid19NewsVC: UIViewController {
    // UI
    private var collectionView: UICollectionView?
    private let refreshControl = UIRefreshControl()
    
    // Data
    private let apiKey = "5a424cd4c2c743d8afe141309eb3b719"
    private var articles: [Article] = []
    private var imageCache: [String: UIImage] = [:]
    private var downloader = ImageDownloader()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        configure()
        loadData()
    }
}

private extension Covid19NewsVC {
    func setup() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: genericLayout())
        collectionView?.register(FlipboardCell.self, forCellWithReuseIdentifier: FlipboardCell.ReuseIdentifier)
        collectionView?.backgroundColor = .systemBackground
        
        collectionView?.dataSource = self as UICollectionViewDataSource
        collectionView?.delegate = self as UICollectionViewDelegate
        
        refreshControl.addTarget(self, action: #selector(loadData), for: UIControl.Event.valueChanged)
    }
    
    func configure() {
        // Collection view
        collectionView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        if let cv = collectionView {
            view.addSubview(cv)
        }
        
        // Refresh control
        collectionView?.addSubview(refreshControl)
    }
    
    func genericLayout() -> UICollectionViewLayout {
        let size = NSCollectionLayoutSize(
            widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
            heightDimension: NSCollectionLayoutDimension.estimated(400)
        )
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    @objc func loadData() {
        guard let url = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=\(apiKey)&category=health") else {
            self.presentOkAlertWithMessage("Error with the News API URL")
            return
        }
        
        self.articles = []
        self.collectionView?.reloadData()

        url.get { (result: Result<Headline,ApiError>) in
            self.refreshControl.endRefreshing()
            
            switch result {
            case .success(let headline):
                self.articles = headline.articles
                
                self.collectionView?.reloadData()
                
            case .failure(let e):
                self.presentOkAlertWithMessage(e.localizedDescription)
            }
        }
    }
}

extension Covid19NewsVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FlipboardCell.ReuseIdentifier, for: indexPath) as! FlipboardCell
        
        let article = self.articles[indexPath.row]
        let identifier = article.identifier
        cell.configure(article)
        downloader.getImage(imageUrl: article.urlToImage, size: cell.imageSizeUnwrapped) { (image) in
            guard cell.identifier == identifier else { return }
            cell.update(image: image, matchingIdentifier: identifier)
        }
        downloader.getImage(imageUrl: article.urlToSourceLogo, size: FlipboardCell.LogoSize) { (image) in
            cell.updateSourceLogo(image: image, matchingIdentifier: identifier)
        }
        
        return cell
    }
}

extension Covid19NewsVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let article = articles[indexPath.row]
        
        guard let url = article.url else { return }
        
        let sfvc = SFSafariViewController(url: url)
        self.present(sfvc, animated: true, completion: nil)
    }
}
