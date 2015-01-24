//
//  MyQRCodePreviewController.swift
//  PARTNER
//
//  Created by RyoAbe on 2014/11/30.
//  Copyright (c) 2014年 RyoAbe. All rights reserved.
//

import UIKit

class MyQRCodePreviewController: UIViewController {

    // TODO: ここblurにしよう
    @IBOutlet weak var qrCodeImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0, alpha: 0.8);

        let myProfile = MyProfile.read()
        qrCodeImageView.image = qrCodeImageForString(myProfile.id, size: qrCodeImageView.frame.size)
    }

    @IBAction func didTapCloseButton(sender: AnyObject) {
        self .dismissViewControllerAnimated(true, completion: nil)
    }

    func qrCodeImageForString(string: String!, size: CGSize) -> UIImage? {
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter.setValue(string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false), forKey: "inputMessage")
        filter.setValue("H", forKey: "inputCorrectionLevel")
        let outputImage = filter.outputImage

        let cgImage = CIContext(options: nil).createCGImage(outputImage, fromRect: outputImage.extent())
        let scale = UIScreen.mainScreen().scale

        UIGraphicsBeginImageContext(CGSizeMake(size.width * scale, size.height))

        let context = UIGraphicsGetCurrentContext()
        CGContextSetInterpolationQuality(context, kCGInterpolationNone)
        CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage)

        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        let result = UIImage(CGImage: resizedImage.CGImage, scale: scale, orientation: UIImageOrientation.DownMirrored)
        return result
    }
}
