//
//  MyHistoryCell.swift
//  PARTNER
//
//  Created by RyoAbe on 2015/03/07.
//  Copyright (c) 2015年 RyoAbe. All rights reserved.
//

import UIKit

class MyHistoryCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func setup() {
        self.backgroundColor = UIColor.clearColor()
        
        if let textLabel = self.textLabel {
            textLabel.textColor = UIColor.blackColor()
            textLabel.font = UIFont.systemFontOfSize(12)
        }

        if let detailTextLabel = self.detailTextLabel {
            detailTextLabel.textColor = UIColor.blackColor()
            detailTextLabel.font = UIFont.systemFontOfSize(10)
        }

        if let imageView = self.imageView {
            imageView.tintColor = UIColor.blackColor()
            var f = imageView.frame
            f.size = CGSizeMake(20, 20)
            imageView.frame = f
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if let imageView = self.imageView {
            var f = imageView.frame
            f.size = CGSizeMake(30, 30)
            f.origin.y = frame.size.height * 0.5 - f.size.height * 0.5
            imageView.frame = f
        }
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)

        let f = self.imageView!.frame
        let c = self.imageView!.center
        let lineWidth = 1.0 / UIScreen.mainScreen().scale

        var circle = UIBezierPath(ovalInRect:CGRectInset(f, -3, -3))
        UIColor.blackColor().setStroke()
        circle.lineWidth = lineWidth
        circle.stroke()
        
        let margin = 10 as CGFloat

        var topLine = UIBezierPath();
        topLine.moveToPoint(CGPointMake(c.x,  0));
        topLine.addLineToPoint(CGPointMake(c.x, CGRectGetMinY(f) - margin));
        UIColor.blackColor().setStroke()
        topLine.lineWidth = lineWidth
        topLine.stroke();

        var bottomLine = UIBezierPath();
        bottomLine.moveToPoint(CGPointMake(c.x, CGRectGetMaxY(f) + margin));
        bottomLine.addLineToPoint(CGPointMake(c.x, frame.size.height));
        UIColor.blackColor().setStroke()
        bottomLine.lineWidth = lineWidth
        bottomLine.stroke();
    }
}
