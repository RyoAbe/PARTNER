//
//  HistoryCell.swift
//  PARTNER
//
//  Created by RyoAbe on 2015/03/15.
//  Copyright (c) 2015年 RyoAbe. All rights reserved.
//

import UIKit

class HistoryBaseCell: UITableViewCell {

    var prevStatus: Status!
    var nextStatus: Status!
    var currentStatus: Status! {
        didSet {
            if currentStatus == nil {
                return
            }
            textLabel!.text = currentStatus.types.statusType.name
            imageView!.image = UIImage(named: currentStatus.types.statusType.iconImageName)
            let fmt = NSDateFormatter()
            fmt.dateFormat = "yyyy-MM-dd HH:mm"
            detailTextLabel?.text = fmt.stringFromDate(currentStatus.date)
            setNeedsDisplay()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.clearColor()
        
        if let textLabel = textLabel {
            textLabel.textColor = UIColor.blackColor()
            textLabel.font = UIFont.systemFontOfSize(12)
        }
        if let detailTextLabel = detailTextLabel {
            detailTextLabel.textColor = UIColor(white: 0.2, alpha: 1.000)
            detailTextLabel.font = UIFont.systemFontOfSize(10)
        }
        if let imageView = imageView {
            imageView.tintColor = UIColor.blackColor()
        }
    }

    var iconDiameter : CGFloat { return 30 }
    var iconRadius   : CGFloat { return iconDiameter * 0.5 }
    var lineWidth    : CGFloat { return 1 / UIScreen.mainScreen().scale }
    var lineColor    : UIColor { return UIColor.blackColor() }
    var iconMargin   : CGFloat { return 10 }
    var marginPointX : CGFloat { return 20 }
    var marginPointY : CGFloat { return 18 }

    override func layoutSubviews() {
        super.layoutSubviews()
        if let imageView = imageView {
            var f = imageView.frame
            f.size = CGSizeMake(iconDiameter, iconDiameter)
            f.origin.y = frame.size.height * 0.5 - f.size.height * 0.5
            imageView.frame = f
        }
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        drawCircle()
        drawUpperLine()
        drawLowerLine()
    }

    func drawCircle() {
        var circle = UIBezierPath(ovalInRect:CGRectInset(imageView!.frame, -4, -4))
        lineColor.setStroke()
        circle.lineWidth = lineWidth
        circle.stroke()
    }
    
    func drawUpperLine() {
        if prevStatus == nil {
            return
        }
        let isSameState = object_getClassName(prevStatus) == object_getClassName(currentStatus)

        let startPointX = isSameState ? imageView!.center.x : frame.size.width * 0.5
        let startPoint = CGPointMake(startPointX,  0)

        let endPointY = isSameState ? CGRectGetMinY(imageView!.frame) - iconMargin : imageView!.center.y
        var endPoint = CGPointMake(imageView!.center.x, endPointY)

        if !isSameState {
            if currentStatus is MyStatus {
                let marginPoint = calcMarginPoint(startPoint, endPoint: endPoint)
                endPoint = CGPointMake(endPoint.x + marginPointX, endPoint.y - marginPointY)
            } else if currentStatus is PartnersStatus {
                endPoint = CGPointMake(endPoint.x - marginPointX, endPoint.y - marginPointY)
            }
        }

        drawLineWithStartPoint(startPoint, endPoint: endPoint)
    }
   
    func drawLowerLine() {
        if nextStatus == nil {
            return
        }
        let isSameState = object_getClassName(nextStatus) == object_getClassName(currentStatus)

        let startPointY = isSameState ? CGRectGetMaxY(imageView!.frame) + iconMargin : imageView!.center.y
        let endPointX = isSameState ? imageView!.center.x : frame.size.width * 0.5
        
        var startPoint = CGPointMake(imageView!.center.x, startPointY)
        let endPoint = CGPointMake(endPointX, frame.size.height)

        if !isSameState {
            if currentStatus is MyStatus {
                startPoint = CGPointMake(startPoint.x + marginPointX, startPoint.y + marginPointY)
            } else if currentStatus is PartnersStatus {
                startPoint = CGPointMake(startPoint.x - marginPointX, startPoint.y + marginPointY)
            }
        }
        drawLineWithStartPoint(startPoint, endPoint: endPoint)
    }

    func calcMarginPoint(startPoint: CGPoint, endPoint: CGPoint) -> CGPoint {
        let x = endPoint.x - startPoint.x
        let y = endPoint.y - startPoint.y
        let radians = atan2f(Float(y), Float(x))
        let degree = radians * Float(180 / M_PI)
        Logger.debug("degree=\(degree), radians=\(radians)")

        let marginY = CGFloat(Float(iconRadius + iconMargin) * sinf(degree))
        let marginX = CGFloat(Float(iconRadius + iconMargin) * cosf(degree))
        
        return CGPointMake(marginX, marginY)
    }
    
    func drawLineWithStartPoint(startPoint: CGPoint, endPoint: CGPoint){
        var line = UIBezierPath()
        line.moveToPoint(startPoint)
        line.addLineToPoint(endPoint)
        lineColor.setStroke()
        line.lineWidth = lineWidth
        line.stroke();
    }
}
