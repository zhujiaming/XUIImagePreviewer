//
//  ImagePreviewViewController.swift
//  image_previewer 图片预览器
//
//  Created by zhujiaming on 2023/5/17.
//

import Foundation
import UIKit

class ImagePreviewViewController : UIViewController, UIScrollViewDelegate {

    private var imageArray : [UIImage] = []
    private var currentPosition = 0
    
    private lazy var scrollView: UIScrollView = {
        return UIScrollView()
    }()
        
    convenience init(imageArray: [UIImage] , position: Int = 0 , bgColor: UIColor = .white) {
        self.init()
        self.imageArray = imageArray
        self.currentPosition = position
        if position >= imageArray.count {
            self.currentPosition = imageArray.count - 1
        }
        self.view.backgroundColor = bgColor
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        initView()
    }
    
    private func initView(){
        self.view.layoutIfNeeded()
        self.updateTitle()
        for iv in imageArray {
            let uiImageView = ImagePreviewView(image: iv)
            scrollView.addSubview(uiImageView)
        }
        self.scrollView.delegate = self
        self.scrollView.isPagingEnabled = true
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.showsVerticalScrollIndicator = false
        self.view.addSubview(scrollView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.scrollView.frame = self.view.bounds
        
        scrollView.contentSize = CGSize(width: scrollView.bounds.width * (CGFloat(imageArray.count)), height: self.view.bounds.height)
        
        var i:CGFloat  = 0
        let cI = CGFloat(self.currentPosition)
        for imageView in scrollView.subviews {
            imageView.frame = CGRect(x: scrollView.bounds.width * i, y: 0, width: scrollView.bounds.width, height: scrollView.bounds.height)
            i += 1
            if i == cI {
                scrollView.contentOffset = CGPoint(x: scrollView.bounds.width * i, y: 0)
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.bounds.width
        let pageIndex = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
        self.currentPosition = pageIndex
        self.updateTitle()
    }
    
    private func updateTitle(){
        self.title = "\(self.currentPosition + 1)/\(self.imageArray.count)"
    }
}

// MARK: - ImagePreviewView
class ImagePreviewView: UIView, UIScrollViewDelegate{
    
    private lazy var targetImageView: UIImageView = {
        return UIImageView()
    }()
    
    private lazy var scrollview: UIScrollView = {
        return UIScrollView()
    }()
    
    private var image : UIImage?
    
    convenience init(image: UIImage?) {
        self.init()
        self.image = image
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self._layoutSubviews()
    }
    
    private func _layoutSubviews(){
        self.layoutIfNeeded()
        self.isMultipleTouchEnabled = true

        let pWidth = self.bounds.width
        let pHeight = self.bounds.height
        
        self.scrollview.frame = self.bounds
        
        self.scrollview.maximumZoomScale = 3.0
        self.scrollview.minimumZoomScale = 1
        self.scrollview.delegate = self
        self.scrollview.showsVerticalScrollIndicator = false
        self.scrollview.showsHorizontalScrollIndicator = false
        self.scrollview.contentSize = CGSize(width: pWidth, height: pHeight)
        self.scrollview.contentInset = UIEdgeInsets.zero
        self.scrollview.contentOffset = CGPoint(x: 0, y: 0)
        self.scrollview.bounces     = true
        self.addSubview(scrollview)
        self.targetImageView.frame = CGRect(x: 0, y: 0, width: pWidth, height: pHeight)
        self.targetImageView.contentMode = .scaleAspectFit
        self.targetImageView.clipsToBounds = true
        self.targetImageView.isUserInteractionEnabled = true
        self.targetImageView.image = self.image
        self.scrollview.addSubview(self.targetImageView)
        self.targetImageView.center = CGPoint(x: scrollview.contentSize.width * 0.5, y: scrollview.contentSize.height * 0.5)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        tapGesture.numberOfTapsRequired = 2
        self.targetImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleDoubleTap(){
        if (self.scrollview.zoomScale < 2 ){
            self.scrollview.setZoomScale(2, animated: true)
        } else if(self.scrollview.zoomScale < 3){
            self.scrollview.setZoomScale(3, animated: true)
        } else {
            self.scrollview.setZoomScale(1, animated: true)
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.targetImageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let pWidth = self.scrollview.contentSize.width
        let pHeight = self.scrollview.contentSize.height
        self.targetImageView.center = CGPoint(x: pWidth/2, y: pHeight/2)
    }
    
}
