//
//  ImagePostViewController.swift
//  LambdaTimeline
//
//  Created by Spencer Curtis on 10/12/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import UIKit
import Photos

class ImagePostViewController: ShiftableViewController {
    
    private var originalImage: UIImage? {
        didSet {
            
            updateImageView()
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //configure Vignette slider
        configureSlider(radiusSlider, from: selectedFilter?.attributes["inputRadius"])
        configureSlider(intensitySlider, from: selectedFilter?.attributes["inputIntensity"])
        
        setImageViewHeight(with: 1.0)
        
        updateViews()
    }
    
    func updateViews() {
        
        guard let imageData = imageData,
            let image = UIImage(data: imageData) else {
                title = "New Post"
                filterChooserSegmentedControl.isHidden = true
                chooseFilterLabel.isHidden = true
                vignetteSliderStack.isHidden = true
                return
        }
        
        title = post?.title
        
        setImageViewHeight(with: image.ratio)
        
        imageView.image = image
        
        chooseImageButton.setTitle("", for: [])
    }
    
    private func presentImagePickerController() {
        
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            presentInformationalAlertController(title: "Error", message: "The photo library is unavailable")
            return
        }
        
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        
        imagePicker.sourceType = .photoLibrary

        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func createPost(_ sender: Any) {
        
        view.endEditing(true)
        
        guard let imageData = imageView.image?.jpegData(compressionQuality: 0.1),
            let title = titleTextField.text, title != "" else {
            presentInformationalAlertController(title: "Uh-oh", message: "Make sure that you add a photo and a caption before posting.")
            return
        }
        
        postController.createPost(with: title, ofType: .image, mediaData: imageData, ratio: imageView.image?.ratio) { (success) in
            guard success else {
                DispatchQueue.main.async {
                    self.presentInformationalAlertController(title: "Error", message: "Unable to create post. Try again.")
                }
                return
            }
            
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func chooseImage(_ sender: Any) {
        
        let authorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch authorizationStatus {
        case .authorized:
            presentImagePickerController()
        case .notDetermined:
            
            PHPhotoLibrary.requestAuthorization { (status) in
                
                guard status == .authorized else {
                    NSLog("User did not authorize access to the photo library")
                    self.presentInformationalAlertController(title: "Error", message: "In order to access the photo library, you must allow this application access to it.")
                    return
                }
                
                self.presentImagePickerController()
            }
            
        case .denied:
            self.presentInformationalAlertController(title: "Error", message: "In order to access the photo library, you must allow this application access to it.")
        case .restricted:
            self.presentInformationalAlertController(title: "Error", message: "Unable to access the photo library. Your device's restrictions do not allow access.")
            
        }
        presentImagePickerController()
    }
    
    func setImageViewHeight(with aspectRatio: CGFloat) {
        
        imageHeightConstraint.constant = imageView.frame.size.width * aspectRatio
        
        view.layoutSubviews()
    }
    
    var postController: PostController!
    var post: Post?
    var imageData: Data?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var chooseImageButton: UIButton!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var postButton: UIBarButtonItem!
    
    //MARK: - Filter Picker SegmentedControl, shows only after user chooses photo
    
    @IBOutlet weak var chooseFilterLabel: UILabel!
    
    @IBOutlet weak var filterChooserSegmentedControl: UISegmentedControl!
    
    @IBAction func segmentedControlSegmentSelectedAction(_ sender: UISegmentedControl) {
        switch filterChooserSegmentedControl.selectedSegmentIndex {
            case 0:
                selectedFilter = filter0
                vignetteSliderStack.isHidden = true
            case 1:
                selectedFilter = filter1
                vignetteSliderStack.isHidden = true
            case 2:
                selectedFilter = filter2
                vignetteSliderStack.isHidden = true
            case 3:
                selectedFilter = filter3
                vignetteSliderStack.isHidden = true
            case 4:
                selectedFilter = filter4
                vignetteSliderStack.isHidden = false
            case 5:
                selectedFilter = filter5
                vignetteSliderStack.isHidden = false
            default:
                vignetteSliderStack.isHidden = true
        }
        updateImageView()
        
        
    }
    //MARK: - Filter Slider controls
    private let filter0 = CIFilter(name: "CIColorInvert")!
    private let filter1 = CIFilter(name: "CIPhotoEffectChrome")!
    private let filter2 = CIFilter(name: "CIPhotoEffectInstant")!
    private let filter3 = CIFilter(name: "CIPhotoEffectNoir")!
    private let filter4 = CIFilter(name: "CIVignette")!
    private let filter5 = CIFilter(name: "CIGloom")!

    private var selectedFilter: CIFilter?
    private let context = CIContext(options: nil)
    
    @IBOutlet weak var vignetteSliderStack: UIStackView!
    
    @IBOutlet weak var radiusSlider: UISlider!
    @IBOutlet weak var intensitySlider: UISlider!
    
    @IBAction func sliderChanged(_ sender: Any) {
        
        updateImageView()
    }
    
    private func updateImageView() {
        guard let image = originalImage else { return }
        DispatchQueue.main.async {
            self.imageView?.image = self.applyFilterToImage(to: image)
        }
    }
    
    private func configureSlider(_ slider: UISlider, from attributes: Any?) {
        let attrs = attributes as? [String: Any] ?? [:]
        
        if let min = attrs[kCIAttributeSliderMin] as? Float,
            let max = attrs[kCIAttributeSliderMax] as? Float,
            let value = attrs[kCIAttributeDefault] as? Float {
            slider.minimumValue = min
            slider.maximumValue = max
            slider.value = value
        }else {
            slider.minimumValue = 0
            slider.maximumValue = 12
            slider.value = 0.5
        }
    }
    
    private func applyFilterToImage(to image: UIImage) -> UIImage {
        let inputImage: CIImage
        
        if let ciImage = image.ciImage {
            inputImage = ciImage
        }else if let cgImage = image.cgImage {
            inputImage = CIImage(cgImage: cgImage)
        }else {
            return image
        }
        selectedFilter?.setValue(inputImage, forKey: kCIInputImageKey)
        
        if filterChooserSegmentedControl.selectedSegmentIndex == 4 || filterChooserSegmentedControl.selectedSegmentIndex == 5 {
            
            selectedFilter?.setValue(radiusSlider.value, forKey: "inputRadius")
            selectedFilter?.setValue(intensitySlider.value, forKey: "inputIntensity")
        }
       
        guard let outputImage = selectedFilter?.outputImage else {
            return image
        }
        
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            return image
        }
        
        return UIImage(cgImage: cgImage)
    }
    
}

extension ImagePostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        chooseImageButton.setTitle("", for: [])
        
        originalImage = info[.originalImage] as? UIImage
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        
        imageView.image = image
        
        setImageViewHeight(with: image.ratio)
        
        //MARK: - Filters
        filterChooserSegmentedControl.isHidden = false
        chooseFilterLabel.isHidden = false
        
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
