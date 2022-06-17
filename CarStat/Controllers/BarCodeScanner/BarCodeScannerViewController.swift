import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import AVFoundation

class BarCodeScannerViewController: CSPopUpViewController {
    // MARK: - UI
    private var descriptionLabel: UILabel!
    private var videoPreview: UIView!
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    private var hintLabel: UILabel!
    private var flashButton: UIButton!

    // MARK: - Properties
    var viewModel: BarCodeScannerViewModel!
    private var captureSession = AVCaptureSession()
    
    private let supportedCodeTypes = [AVMetadataObject.ObjectType.qr]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subscribe()
        startScaningSession()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let connection = self.videoPreviewLayer?.connection {
            updatePreviewLayer(layer: connection, orientation: .portrait)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        flashOff()
    }
    
    // MARK: - Functions
    private func subscribe() {
        flashButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                self.toggleFlash()
            })
            .disposed(by: viewModel.disposeBag)
        
        viewModel.isParsingFinished
            .subscribe(onNext: { [weak self] value in
                guard let self = self else { return }
                
                if value {
                    self.captureSession.stopRunning()
                    self.configureMainLoaderWithBlurEffect(isHidden: false)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        self.configureMainLoaderWithBlurEffect(isHidden: true)
                        
                        AlertManager.showAction(on: self,
                                                title: "Полученные данные",
                                                message: self.viewModel.makeStringFromParsedData()) { action in
                            switch action {
                            case true: //self.captureSession.startRunning()
                                self.viewModel.generateResult()
                                self.dismissWithAnimaion()
                                // TODO: - Add pick data from QR and add ti result
                                
                            case false: self.dismissWithAnimaion()
                            }
                        }
                    }
                }
            })
            .disposed(by: viewModel.disposeBag)
    }
    
    private func startScaningSession() {
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            print("Failed to get the camera device")
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)
            
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            
        } catch {
            
            print(error.localizedDescription)
            return
        }
        
        captureSession.startRunning()
    }
    
    private func updatePreviewLayer(layer: AVCaptureConnection, orientation: AVCaptureVideoOrientation) {
        layer.videoOrientation = orientation
        videoPreviewLayer?.frame = self.videoPreview.bounds
    }
    
    private func toggleFlash() {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        if device.hasTorch {
            do {
                try device.lockForConfiguration()
                if device.torchMode == AVCaptureDevice.TorchMode.on {
                    device.torchMode = AVCaptureDevice.TorchMode.off
                    configureFlashButton(isOn: false)
                } else {
                    do {
                        configureFlashButton(isOn: true)
                        try device.setTorchModeOn(level: 1.0)
                    } catch {
                        print("Error toggleFlash: \(error.localizedDescription)")
                    }
                }
                device.unlockForConfiguration()
            } catch {
                print("Error toggleFlash: \(error.localizedDescription)")
            }
        }
    }
    
    private func flashOff() {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        if device.hasTorch {
            do {
                try device.lockForConfiguration()
                device.torchMode = AVCaptureDevice.TorchMode.off
            } catch {
                print("Error flashOff: \(error.localizedDescription)")
            }
        }
    }
}

extension BarCodeScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        if metadataObjects.count == 0 { return }
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type) {
            viewModel.metadata.accept(metadataObj.stringValue)
        }
    }
}

// MARK: - Picker controller
extension BarCodeScannerViewController: PickerController {
    var result: Observable<PickerResult?> {
        self.viewModel.result.compactMap { $0 }.asObservable()
    }
}

extension BarCodeScannerViewController {
    override func makeUI() {
        super.makeUI()

        // DESCRIPTION LABEL
        descriptionLabel = UILabel()
        descriptionLabel.text = "Наведите камеру на QR-код"
        descriptionLabel.textAlignment = .center
        descriptionLabel.setFontSize(size: 17)
        containerView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(separator.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(16)
        }
        
        // VIDEO PREVIEW
        videoPreview = UIView()
        videoPreview.layer.cornerRadius = 2
        videoPreview.layer.masksToBounds = true
        videoPreview.backgroundColor = .lightGray
        containerView.addSubview(videoPreview)
        videoPreview.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(48)
            $0.left.right.equalToSuperview().inset(Device.deviceWidth / 4)
            $0.height.equalTo(videoPreview.snp.width)
        }
        
        // VIDEO PREVIEW LAYER
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.backgroundColor = UIColor.lightGray.cgColor
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = videoPreview.layer.bounds
        videoPreview.layer.addSublayer(videoPreviewLayer!)
        
        // HINT LABEL
        hintLabel = UILabel()
        hintLabel.text = "Поместите QR-код в рамку для сканирования"
        hintLabel.textAlignment = .center
        hintLabel.setFontSize(size: 13)
        containerView.addSubview(hintLabel)
        hintLabel.snp.makeConstraints {
            $0.top.equalTo(videoPreview.snp.bottom).offset(32)
            $0.left.right.equalToSuperview().inset(16)
        }
        
        // FLASH BUTTON
        flashButton = UIButton()
        flashButton.layer.borderWidth = 1
        flashButton.layer.borderColor = UIColor.lightBlue.cgColor
        flashButton.layer.cornerRadius = 25
        flashButton.clipsToBounds = true
        configureFlashButton(isOn: false)
        containerView.addSubview(flashButton)
        flashButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(hintLabel.snp.bottom).offset(20)
            $0.size.equalTo(50)
            $0.bottom.equalToSuperview().inset(160)
        }
    }
    
    private func configureFlashButton(isOn: Bool) {
        flashButton.tintColor = isOn ? .white : .black
        flashButton.backgroundColor = isOn ? .black : .white
        flashButton.setImage(isOn ? UIImage(systemName: "flashlight.on.fill") : UIImage(systemName: "flashlight.off.fill"), for: .normal)
    }
}
