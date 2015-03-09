//
//  QRReaderViewController.swift
//  PARTNER
//
//  Created by RyoAbe on 2014/09/07.
//  Copyright (c) 2014年 RyoAbe. All rights reserved.
//

import UIKit
import AVFoundation

class QRCodeReaderMaskView: UIView {    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func drawRect(rect: CGRect) {
        super.drawRect(rect)

        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, UIColor(white: 0, alpha: 0.5).CGColor)
        CGContextFillRect(context, rect)

        let width = rect.width * 0.8
        let x = self.center.x - (width * 0.5)
        let y =  self.center.y - (width * 0.5) + UIApplication.sharedApplication().statusBarFrame.height
        let frame = CGRectMake(x, y, width, width)

        let lineWidth = CGFloat(2)
        CGContextSetLineWidth(context, lineWidth)
        CGContextSetStrokeColorWithColor(context, UIColor.whiteColor().CGColor);
        CGContextStrokeRect(context, CGRectInset(frame, -lineWidth * 0.5, -lineWidth * 0.5))

        CGContextSetFillColorWithColor(context, UIColor.clearColor().CGColor)
        CGContextSetBlendMode(context, kCGBlendModeClear)
        CGContextFillRect(context, frame)
    }
}

class QRReaderViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    // ???: Locationで友達になるパターンも実装
    var session: AVCaptureSession!
    var maskView: QRCodeReaderMaskView!
    var previewLayer: AVCaptureVideoPreviewLayer!
    @IBOutlet weak var backButtonView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        if !UIImagePickerController.isSourceTypeAvailable(.Camera) {
            self.navigationController!.popViewControllerAnimated(true)
            return
        }

        // TODO: 認証されていないときはログイン画面への誘導を入れる（scheme入れよう）
        let status = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)
        switch status {
        case .Restricted:
            println("Restricted")
        case .Denied:
            println("Denied")
        case .NotDetermined:
            AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo, completionHandler: { granted in
                dispatch_sync(dispatch_get_main_queue(), {
                    if(granted){
                        self.congigCamera()
                        return
                    }
                    self.navigationController!.popViewControllerAnimated(true)
                })
            })
        case .Authorized:
            congigCamera()
        }
        maskView = QRCodeReaderMaskView(frame: CGRectZero)
        self.view.addSubview(maskView)

        self.view.bringSubviewToFront(backButtonView)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if(maskView == nil){
            return
        }
        maskView.frame = self.view.bounds
        previewLayer.frame = self.view.bounds
    }

    func congigCamera() -> Bool {
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        // TODO: error
        if(device == nil){
            return false
        }

        var error: NSErrorPointer = nil
        var input = AVCaptureDeviceInput.deviceInputWithDevice(device, error: error) as AVCaptureInput
        // TODO: error
        if(error != nil){
            return false
        }

        let output = AVCaptureMetadataOutput()
        session = AVCaptureSession()
        session.sessionPreset = AVCaptureSessionPresetPhoto
        session.addInput(input)
        session.addOutput(output)
        output.metadataObjectTypes = [AVMetadataObjectTypeQRCode]

        previewLayer = AVCaptureVideoPreviewLayer.layerWithSession(self.session) as AVCaptureVideoPreviewLayer
        previewLayer.frame = view.bounds
        view.layer.addSublayer(previewLayer)
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        session.startRunning()
        
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())

        return true
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        for metadataObject in metadataObjects {
            if !metadataObject.isKindOfClass(AVMetadataMachineReadableCodeObject) || metadataObject.type != AVMetadataObjectTypeQRCode {
                continue
            }
            if !verifyPartnersId(metadataObject.stringValue) {
                // TODO: 読み取ったのがobjectIdはじゃなければエラーのトースト or アラートを表示
                continue
            }
            session.stopRunning()
            return
        }
    }

    // TODO: PFUser拡張したほうがいいわ
    func verifyPartnersId(id: NSString) -> Bool {
        
        let op = GetUserOperation(objectId: id)
        op.completionBlock = {
            if let user = op.result as PFUser! {
                if (user["hasPartner"] as Bool) {
                    // TODO: パートナーがいた場合のパターン考慮
                    return
                }
                self.showConfirmBecomePartner(user)
            }
        }
        dispatchAsyncOperation(op)
        return true
    }

    func showConfirmBecomePartner(user: PFUser){
        // ???: 既にパートナーがいる場合は、チェンジしたいいか確認
        let alert = UIAlertController(title: "Confirm", message: "Do you become partner with \"\(user.username)\"?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler:{ action in
            let op = AddPartnerOperation(candidatePartner: user)
            op.completionBlock = {
                // TODO: アラートで友達になったよ的なのを出す。それでからpop
                self.navigationController!.popViewControllerAnimated(true)
                return
            }
            self.dispatchAsyncOperation(op)
        }))
        presentViewController(alert, animated: true, completion: nil)
    }


    @IBAction func didTapBackButton(sender: AnyObject) {
        navigationController!.popViewControllerAnimated(true)
    }

    @IBAction func useLocation(sender: UIButton) {
        var query = PFQuery(className:PFUser.parseClassName())
    }
}
