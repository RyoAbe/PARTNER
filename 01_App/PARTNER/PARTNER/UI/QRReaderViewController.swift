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

        let lineWidth = CGFloat(1)
        CGContextSetLineWidth(context, lineWidth)
        CGContextSetStrokeColorWithColor(context, UIColor.whiteColor().CGColor);
        CGContextStrokeRect(context, CGRectInset(frame, -lineWidth * 0.5, -lineWidth * 0.5))

        CGContextSetFillColorWithColor(context, UIColor.clearColor().CGColor)
        CGContextSetBlendMode(context, kCGBlendModeClear)
        CGContextFillRect(context, frame)
    }
}

class QRReaderViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    // ???: 【保留】QRコードでどうやって友達になるかを検討（とりあえずQRコードにみにしてLocationのやつはなしにする？）
    // ???: 【保留】友達追加が成功したらCoreDataに保存
    var session: AVCaptureSession!
    var maskView: QRCodeReaderMaskView!
    var previewLayer: AVCaptureVideoPreviewLayer!
    @IBOutlet weak var backButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // ???: 認証されていないときの処理
        let status = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)
        switch status {
        case .Restricted:
            println("Restricted")
        case .Denied:
            println("Denied")
        case .NotDetermined:
            AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo, completionHandler: { granted in
                // ???: 逆？
                if(granted){
                    self.congigCamera()
                }
                self.navigationController!.popViewControllerAnimated(true)
            })
            
        case .Authorized:
            congigCamera()
        }
        maskView = QRCodeReaderMaskView(frame: CGRectZero)
        self.view.addSubview(maskView)

        self.view.bringSubviewToFront(backButton)
        backButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        maskView.frame = self.view.bounds
        previewLayer.frame = self.view.bounds
    }

    func congigCamera() -> Bool {
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        if(device == nil){
            return false
        }

        var error: NSErrorPointer = nil
        var input = AVCaptureDeviceInput.deviceInputWithDevice(device, error: error) as AVCaptureInput
        if(error != nil){
            return false
        }

        let output = AVCaptureMetadataOutput()
        output.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        session = AVCaptureSession()
        session.sessionPreset = AVCaptureSessionPresetPhoto
        session.addInput(input)
        session.addOutput(output)

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
            if metadataObject.isKindOfClass(AVMetadataMachineReadableCodeObject) || metadataObject.type != AVMetadataObjectTypeQRCode {
                continue
            }
            if !verifyPartnersId(metadataObject as NSString) {
                // ???: 失敗アラート表示
                continue
            }
            session.stopRunning()
            return
        }
    }

    func verifyPartnersId(id: NSString) -> Bool {
        if NSURL(string: id) != nil {
            return false
        }

        MRProgressOverlayView.show()
        let op = GetUserOperation(id: id)
        op.start()
        op.completionBlock = {
            MRProgressOverlayView.hide()
            if let user = op.result {
                self.showConfirmBecomePartner(user)
            }
        }

        return true
    }

    func showConfirmBecomePartner(user: PFUser){

        let alert = UIAlertController(title: "Confirm", message: "Do you become partner with \(user.username) ?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: nil))
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler:{ action in
            MRProgressOverlayView.show()
            let op = UpdateMyProfileOperation(hasPartner:true)
            op.start()
            op.completionBlock = { MRProgressOverlayView.hide() }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }


    @IBAction func didTapBackButton(sender: AnyObject) {
        navigationController!.popViewControllerAnimated(true)
    }

    @IBAction func useLocation(sender: UIButton) {
        var query = PFQuery(className:PFUser.parseClassName())
    }
}
