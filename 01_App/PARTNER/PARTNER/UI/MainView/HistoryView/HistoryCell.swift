//
//  HistoryCell.swift
//  PARTNER
//
//  Created by RyoAbe on 2015/03/07.
//  Copyright (c) 2015年 RyoAbe. All rights reserved.
//

import UIKit

class HistoryCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clearColor()
        
        if let textLabel = self.textLabel {
            textLabel.textColor = UIColor.blackColor()
            textLabel.font = UIFont.systemFontOfSize(12)
        }
        if let imageView = self.imageView {
            imageView.tintColor = UIColor.blackColor()
            var f = imageView.frame
            f.size = CGSizeMake(20, 20)
            imageView.frame = f
        }
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

        var circle = UIBezierPath(ovalInRect:CGRectInset(f, -3, -3))
        UIColor.blackColor().setStroke()
        circle.lineWidth = 1
        circle.stroke()
        
        let margin = 10 as CGFloat

        var topLine = UIBezierPath();
        topLine.moveToPoint(CGPointMake(c.x,  0));
        topLine.addLineToPoint(CGPointMake(c.x, CGRectGetMinY(f) - margin));
        UIColor.blackColor().setStroke()
        topLine.lineWidth = 1
        topLine.stroke();

        var bottomLine = UIBezierPath();
        bottomLine.moveToPoint(CGPointMake(c.x, CGRectGetMaxY(f) + margin));
        bottomLine.addLineToPoint(CGPointMake(c.x, frame.size.height));
        UIColor.blackColor().setStroke()
        bottomLine.lineWidth = 1
        bottomLine.stroke();
    }
}
