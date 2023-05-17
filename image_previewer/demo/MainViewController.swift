//
//  MainViewController.swift
//  image_previewer
//
//  Created by zhujiaming on 2023/5/6.
//

import Foundation
import UIKit
import SnapKit
import PhotosUI

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        let button = UIButton()
        
        button.setTitle("从相册选择图片进入预览", for: .normal)
        button.setTitleColor(.white, for: .normal)
        
        self.view.addSubview(button)

        button.backgroundColor = .gray
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        
        button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        
        button.snp.makeConstraints{
            make in
            make.center.equalToSuperview()
            make.width.equalTo(260)
            make.height.equalTo(50)
        }
        
    }
    
    @objc func buttonClicked() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 5
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }


}

extension MainViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        print("picker => \(results.count)")
        dismiss(animated: true)
        var targets : [UIImage] = []
        var count = results.count
        for ip in results{
            let itemProvider = ip.itemProvider
            if itemProvider.canLoadObject(ofClass: UIImage.self){
                itemProvider.loadObject(ofClass: UIImage.self) {
                    [weak self] image, error in
                    if let image  = image as? UIImage {
                        targets.append(image)
                    }
                    count -= 1
                    if count == 0 {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            [weak self] in
                            self?.navigationController?.pushViewController(UIImagePreviewController(imageArray: targets, bgColor: .black), animated: true)
                        }
                    }
                }
            }
        }
    }
}
