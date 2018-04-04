//
//  ViewController.swift
//  liteKasta
//
//  Created by Zoreslav Khimich on 4/2/18.
//  Copyright © 2018 Markason LLC. All rights reserved.
//

import IGListKit
import Moya
import AlamofireImage

class ViewController: UIViewController {
    
    let provider: MoyaProvider<KastaAPI>
    var state = State.initialFetch
    
    // MARK: - NSObject
    
    init(provider: MoyaProvider<KastaAPI>) {
        self.provider = provider
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not supported.")
    }
    
    // MARK: - UIViewController
    
    var collectionView = UICollectionView(frame: .zero, collectionViewLayout: ListCollectionViewLayout(stickyHeaders: false, scrollDirection: .vertical, topContentInset: 0, stretchToEdge: false))
    
    lazy var adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .appBackground

        collectionView.backgroundColor = view.backgroundColor
        view.addSubview(collectionView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adapter.collectionView = collectionView
        adapter.dataSource = self
        
        fetch()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height, width: view.frame.width, height: view.frame.height - UIApplication.shared.statusBarFrame.height)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

// MARK: - ListAdapterDataSource

extension ViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        switch self.state {
        case .success(items: let items):
            return items
        case .initialFetch, .failure(error: _):
            return []
        }
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        let controller = ListSingleSectionController(cellClass: CampaignCell.self, configureBlock: { (item, cell) in
            
            let campaignCell = cell as! CampaignCell
            let campaign = item as! Campaign
            
            campaignCell.title.text = campaign.title
            campaignCell.desc.text = campaign.desc
            if let url = URL(string: "https://modnakasta.ua/imgw/loc/0x0/\(campaign.bannerPath)") {
                campaignCell.picture.af_setImage(withURL: url)
            }
            
        }, sizeBlock: { (item, context) -> CGSize in
            
            let width = context!.insetContainerSize.width - 32 // 16pt inset on each side
            let height = CampaignCell.desiredHeightFor(columnWidth: width)
            
            return CGSize(width: width, height: height)
            
        })
        
        guard case .success(let items) = state else {
            fatalError("Fetch state != .success, the collection should have no sections, yet the adapter requests one, wtf?")
        }
        
        controller.selectionDelegate = self
        
        let currentItem = object as! ListDiffable
        let isFirstItem = currentItem.isEqual(toDiffableObject: items.first)
        
        controller.inset = UIEdgeInsets(top: isFirstItem ? 32 : 0, left: 16, bottom: 16, right: 16)
        
        return controller
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        switch state {
            
        case .initialFetch:
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
            activityIndicator.startAnimating()
            return activityIndicator
            
        case .failure(error: _):
            let button = UIButton(type: .system)
            button.setTitle(NSLocalizedString("error.reload-button.title", comment: "Data fetch retry button title"), for: .normal)
            button.addTarget(self, action: #selector(retry), for: UIControlEvents.touchUpInside)
            return button
            
        case .success(items: _):
            return nil
            
        }
    }
    
}

// MARK: - Fetch & process

extension ViewController {
    func fetch() {
        provider.request(.campaigns) { result in
            do {
                switch result {
                    
                case .success(let response):
                    let response = try response.filterSuccessfulStatusAndRedirectCodes()
                    let campaigns = try response.map([KastaAPI.Campaign].self, atKeyPath: "items", using: KastaAPI.Campaign.decoder)
                    let (activeCampaigns, _) = campaigns.filterActive(for: Date())
                    let viewModels = activeCampaigns.map() { return Campaign(with: $0) }
                    self.state = .success(items: viewModels)
                    self.adapter.performUpdates(animated: true, completion: nil)
                    
                case .failure(let error):
                    throw error
                }
                
            }
                
            catch let error {
                self.state = .failure(error: error)
                self.adapter.performUpdates(animated: true, completion: nil)

            }
        }
    }
}

// MARK: – IGListSingleSectionControllerDelegate (item selection)
extension ViewController: ListSingleSectionControllerDelegate {
    func didSelect(_ sectionController: ListSingleSectionController, with object: Any) {
        switch object {
        case is Campaign:
            let campaign = object as! Campaign
            if let webURL = URL(string: "https://modnakasta.ua/campaign/\(campaign.codename)/") {
                UIApplication.shared.openURL(webURL)
            }
        default:
            return
        }
    }
}

// MARK: - Actions

extension ViewController {
    @objc func retry() {
        state = .initialFetch
        fetch()
    }
}
