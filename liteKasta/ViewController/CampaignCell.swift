//
//  CampaignCell.swift
//  liteKasta
//
//  Created by Zoreslav Khimich on 4/3/18.
//  Copyright © 2018 Markason LLC. All rights reserved.
//

import UIKit

extension ViewController {
    class CampaignCell: UICollectionViewCell {
        let title = UILabel()
        let desc = UILabel()
        let picture = UIImageView()
        let cornersOverlay = UIImageView(image: UIImage(named: "CampaignCell/4ptClipCorners"))
        
        static let pictureAspect: CGFloat = 1.0 / 0.55
        static let captionBlockHeight: CGFloat = 76

        override init(frame: CGRect) {
            super.init(frame: frame)
            backgroundColor = .campaignCellBackground
            isOpaque = true
            
            addSubview(picture)
            
            title.font =  UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.medium)
            title.textColor = .normalText
            addSubview(title)
            
            desc.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.regular)
            title.textColor = .normalText
            addSubview(desc)
            
            addSubview(cornersOverlay)

        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("Not supported")
        }
        
        override func prepareForReuse() {
            picture.image = nil
            title.text = nil
            desc.text = nil
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            picture.frame = CGRect(x: 0, y: 0, width: bounds.width, height: floor(bounds.width / CampaignCell.pictureAspect))
            title.frame = CGRect(x: 16, y: picture.frame.maxY + 16, width: bounds.width - 32, height: 24)
            desc.frame = CGRect(x: title.frame.minX, y: title.frame.maxY + 4, width: title.frame.width, height: 16)
            
            cornersOverlay.frame = bounds
        }
        
        class func desiredHeightFor(columnWidth: CGFloat) -> CGFloat {
            return floor(columnWidth / pictureAspect) + captionBlockHeight;
        }

    }
}
