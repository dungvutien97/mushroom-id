//
//  TCCamera.swift
//  mushroomapp
//
//  Created by Tien Dung Vu on 12/9/25.
//

import Foundation
import AVFoundation
import Foundation
import SnapKit
import UIKit

protocol TCCameraDelegate: AnyObject {
    func cameraDidCapturePhoto(_ image: UIImage)
    func cameraDidFail(with error: Error)
}

class TCCamera: UIViewController {
    weak var delegate: TCCameraDelegate?
    
    private let captureSession = AVCaptureSession()
    private var previewLayer: AVCaptureVideoPreviewLayer?
    
    private let photoOutput = AVCapturePhotoOutput()
    private let captureButton = UIButton()
    
    private var overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.isUserInteractionEnabled = false // để không chặn thao tác
        return view
    }()
    
    private var croppingOverlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var cropWidth: CGFloat = 0
    var cropHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
        setupCroppingOverlayView()

        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer?.frame = view.bounds
        applyMaskToOverlay()
    }
    
    private func setupCroppingOverlayView() {
        let boxWidth = view.bounds.width * 0.8
        let boxHeight = boxWidth /*boxWidth * 300 / 200*/
        
        cropWidth = boxWidth
        cropHeight = boxHeight
        
        // Thêm overlay trước
        overlayView.frame = view.bounds
        view.addSubview(overlayView)
        
        // Thêm crop box
        view.addSubview(croppingOverlayView)
        NSLayoutConstraint.activate([
            croppingOverlayView.widthAnchor.constraint(equalToConstant: boxWidth),
            croppingOverlayView.heightAnchor.constraint(equalToConstant: boxHeight),
            croppingOverlayView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            croppingOverlayView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func applyMaskToOverlay() {
        let path = UIBezierPath(rect: overlayView.bounds)
        let cropRect = croppingOverlayView.frame
        let transparentPath = UIBezierPath(rect: cropRect)
        path.append(transparentPath)
        path.usesEvenOddFillRule = true
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        maskLayer.fillRule = .evenOdd
        overlayView.layer.mask = maskLayer
    }
    
    private func setupCamera() {
        captureSession.sessionPreset = .photo
        
        guard let backCamera = AVCaptureDevice.DiscoverySession(
            deviceTypes: [
                .builtInTripleCamera,
                .builtInDualCamera,
                .builtInWideAngleCamera,
                .builtInDualWideCamera,
                .builtInUltraWideCamera,
                .builtInTelephotoCamera
            ],
            mediaType: .video,
            position: .back
        ).devices.first else {
            delegate?.cameraDidFail(with: NSError(domain: "Camera", code: -1, userInfo: [NSLocalizedDescriptionKey: "Không tìm thấy camera sau"]))
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }
            
            if captureSession.canAddOutput(photoOutput) {
                captureSession.addOutput(photoOutput)
            }
            
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer?.videoGravity = .resizeAspectFill
            previewLayer?.frame = view.bounds
            if let layer = previewLayer {
                view.layer.addSublayer(layer)
            }
            DispatchQueue.global().async { [self] in
                self.captureSession.startRunning()
            }
            
        } catch {
            delegate?.cameraDidFail(with: error)
        }
    }
    
    @objc func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
    
    func setupUI() {
        // Capture Button setup
        captureButton.setImage(UIImage(named: "capture_button"), for: .normal)
        captureButton.layer.cornerRadius = 30
        captureButton.tintColor = .white
        view.addSubview(captureButton)
        
        captureButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-32)
            make.width.height.equalTo(80)
            make.centerX.equalToSuperview()
        }
        
        captureButton.addTarget(self, action: #selector(capturePhoto), for: .touchUpInside)
        view.bringSubviewToFront(captureButton)
    }
    
    deinit {
        print("Camera deallocated")
    }
}

extension TCCamera: AVCapturePhotoCaptureDelegate {
    // Trong TCCamera class (phần xử lý chụp ảnh)
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            delegate?.cameraDidFail(with: error)
            return
        }
        
        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData)
        else {
            delegate?.cameraDidFail(with: NSError(domain: "com.yourapp.camera", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to process photo"]))
            fatalError("Check here")
        }
        
        let screenSize = view.bounds.size
        let temp = image.fixedOrientation()
        
        // Chuẩn hoá về ảnh theo màn hình
        let screenSizedImage = temp.croppedToFill(targetSize: screenSize)!
        
        // Lấy kích cỡ của overlay view, nếu không có crop thì trả về screenSizedImage là được
        let overlayRect = croppingOverlayView.frame
        
        // Lấy ảnh theo kích cỡ overlay - cho các dạng identify, crop ảnh ở giữa
        let maskedImage = screenSizedImage.crop(to: overlayRect, in: screenSize)!
        
        let resized = maskedImage.resizedToFit(maxSize: CGSize.init(width: 512, height: 512))!
        let resize3 = resized.resized(by: 0.7)!
        // Trả về ảnh đã crop
        delegate?.cameraDidCapturePhoto(resize3)
        
    }
}

// MARK: - Helper

extension UIImage {
    func crop(to rect: CGRect, in viewSize: CGSize) -> UIImage? {
        guard let cgImage = self.cgImage else { return nil }
        
        // Tính tỷ lệ giữa kích thước ảnh thực tế và kích thước hiển thị trên view
        let widthRatio = size.width / viewSize.width
        let heightRatio = size.height / viewSize.height
        
        // Chuyển đổi tọa độ từ view sang ảnh gốc
        let cropRect = CGRect(
            x: rect.origin.x * widthRatio,
            y: rect.origin.y * heightRatio,
            width: rect.size.width * widthRatio,
            height: rect.size.height * heightRatio
        )
        
        // Thực hiện crop
        guard let croppedCGImage = cgImage.cropping(to: cropRect) else { return nil }
        
        return UIImage(cgImage: croppedCGImage, scale: self.scale, orientation: self.imageOrientation)
    }
    
    /**
     
     // Giả sử:
     // - Ảnh gốc có kích thước 4000x3000 pixels
     // - Hiển thị trên view có kích thước 400x300 points
     // - User vẽ rect muốn crop có kích thước 100x100 ở góc (50,50)
     
     let viewSize = CGSize(width: 400, height: 300)
     let cropRect = CGRect(x: 50, y: 50, width: 100, height: 100)
     
     if let croppedImage = originalImage.crop(to: cropRect, in: viewSize) {
     // croppedImage sẽ là phần 500x500 pixels từ ảnh gốc
     }
     
     */
    
}

extension UIImage {
    
    /// Cắt ảnh theo kích thước màn hình chất lượng ảnh như ảnh gốc (similar to `.scaleAspectFill`)
    /// - Parameter targetSize: The target size to fill
    /// - Returns: The cropped image, or nil if cropping fails
    func croppedToFill(targetSize: CGSize) -> UIImage? {
        guard targetSize.width > 0, targetSize.height > 0 else {
            return self
        }
        
        let imageSize = size
        guard imageSize.width > 0, imageSize.height > 0 else {
            return self
        }
        
        let widthRatio = targetSize.width / imageSize.width
        let heightRatio = targetSize.height / imageSize.height
        
        // Determine the crop rectangle
        let cropRect: CGRect
        if widthRatio > heightRatio {
            // Scale based on width, crop height
            let scaledHeight = targetSize.height / widthRatio
            let originY = (imageSize.height - scaledHeight) * 0.5
            cropRect = CGRect(x: 0,
                              y: originY,
                              width: imageSize.width,
                              height: scaledHeight)
        } else if heightRatio > widthRatio {
            // Scale based on height, crop width
            let scaledWidth = targetSize.width / heightRatio
            let originX = (imageSize.width - scaledWidth) * 0.5
            cropRect = CGRect(x: originX,
                              y: 0,
                              width: scaledWidth,
                              height: imageSize.height)
        } else {
            // Aspect ratios are identical, no need to crop
            cropRect = CGRect(origin: .zero, size: imageSize)
        }
        
        // Perform cropping
        guard let cgImage = cgImage?.cropping(to: cropRect) else {
            return nil
        }
        
        return UIImage(cgImage: cgImage, scale: scale, orientation: imageOrientation)
    }
    
    /// Trả về ảnh với orientation đã được chỉnh về `.up`
    func fixedOrientation() -> UIImage {
        // Nếu đã đúng orientation thì trả về luôn
        guard imageOrientation != .up else { return self }
        
        // Tạo context mới và vẽ lại ảnh
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(in: CGRect(origin: .zero, size: size))
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return normalizedImage ?? self
    }
}
