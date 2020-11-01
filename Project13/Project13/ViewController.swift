//
//  ViewController.swift
//  Project13
//
//  Created by Alexander Ha on 10/12/20.
//

import UIKit
import CoreImage

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var changeFilterLabel: UIButton!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var intensity: UISlider!
    var currentImage: UIImage!
    var context: CIContext!
    var currentFilter: CIFilter!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "MasterPiece"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
        
        context = CIContext()
        currentFilter = CIFilter(name: "CISepiaTone")

        changeFilterLabel.setTitle("Change Filter", for: .normal)
    }

    @IBAction func changeFilter(_ sender: UIButton) {
        
        let ac = UIAlertController(title: "Choose filter", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "CIBumpDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIGaussianBlur", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIPixellate", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CISepiaTone", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CITwirlDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIUnsharpMask", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIVignette", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
        
    }
    
    @IBAction func save(_ sender: UIButton) {
        //safely unwraps the image
        guard let image = imageView.image else {
            let ac = UIAlertController(title: "No photo selected", message: "Please select a photo", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            return
        }
        //the selector method is called when it saves the image.
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)

    }
    
    @IBAction func intensityChanged(_ sender: UISlider) {
        applyProcessing()
    }
    
    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else { return }
        dismiss(animated: true)
        currentImage = image
        
        if let beginImage = CIImage(image: currentImage) {
            currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
            applyProcessing()
        }
    }
    
    func applyProcessing() {
        
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey)
        }
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(intensity.value * 200, forKey: kCIInputRadiusKey)
        }
        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(intensity.value * 10, forKey: kCIInputScaleKey)
        }
        if inputKeys.contains(kCIInputCenterKey) {
            currentFilter.setValue(CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2), forKey: kCIInputCenterKey)
        }
    
        guard let image = currentFilter.outputImage else { return }
        
        if let cgImage = context.createCGImage(image, from: image.extent) {
            let processedImage = UIImage(cgImage: cgImage)
            //animate fade in image view
            self.imageView.image = processedImage
            self.imageView.alpha = 0
            UIView.animate(withDuration: 1) {
                self.imageView.alpha = 1
            }
        }
    }
    
    func setFilter(action: UIAlertAction) {
        
        changeFilterLabel.setTitle(action.title, for: .normal) 
        
        //makes sure we have valid image before continuing
        guard currentImage != nil else { return }
        
        //safely reads the alert actions title
        guard let actionTitle = action.title else { return }
        
        //uses the UIAlertActions title property to set the filter
        currentFilter = CIFilter(name: actionTitle)
        
        //converts UIImage to CIImage
        let beginImage = CIImage(image: currentImage)
        
        //passes in which image we'd like to filter next
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        
        //calls applyProcessing() method
        applyProcessing()
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        
        //code runs if we got back an error and not nil!
        if let error = error {
           // error.localizedDescription shows error in users own language
            let ac = UIAlertController(title: "Save Error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            //code runs if saving image was successful
            let ac = UIAlertController(title: "Saved!", message: "Your edited image has been saved to photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
}

