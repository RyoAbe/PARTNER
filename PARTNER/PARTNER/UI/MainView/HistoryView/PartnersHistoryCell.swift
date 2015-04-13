//
//  PartnersHistoryCell.swift
//  PARTNER
//
//  Created by RyoAbe on 2015/03/07.
//  Copyright (c) 2015年 RyoAbe. All rights reserved.
//

import UIKit

class PartnersHistoryCell: HistoryBaseCell {

    override func layoutSubviews() {
        super.layoutSubviews()
        if let imageView = self.imageView {
            var f = imageView.frame
            f.origin.x = frame.size.width - f.origin.x - f.size.width
            imageView.frame = f
        }
        if let textLabel = self.textLabel {
            var f = textLabel.frame
            f.origin.x = frame.size.width - f.origin.x - f.size.width
            textLabel.textAlignment = .Right
            textLabel.frame = f
        }
        if let detailTextLabel = self.detailTextLabel {
            var f = detailTextLabel.frame
            f.origin.x = frame.size.width - f.origin.x - f.size.width
            detailTextLabel.frame = f
            detailTextLabel.textAlignment = .Right
        }
    }
}
