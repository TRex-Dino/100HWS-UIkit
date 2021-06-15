//
//  ViewController.swift
//  Challange 1
//
//  Created by Dmitry on 15.06.2021.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var selectedImage: UIImageView!
    
    var imageName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let imageToLoad = imageName {
            selectedImage.image = UIImage(named: imageToLoad)
        }
        
        setupUI()
    }
    
    func setupUI() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        selectedImage.layer.borderWidth = 1
        selectedImage.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    @objc func shareTapped() {
        guard let image = selectedImage.image?.jpegData(compressionQuality: 0.8) else {
            print("No image Found")
            return
        }
        
        let nameOfPicture = imageName ?? ""
        
        let vc = UIActivityViewController(activityItems: [image, nameOfPicture], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }

}
