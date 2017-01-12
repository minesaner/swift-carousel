//
//  CarouselView.swift
//  Carousel
//
//  Created by 贾江旭 on 2017/1/10.
//  Copyright © 2017年 saner. All rights reserved.
//

import UIKit

@IBDesignable class CarouselView: UIView {

    fileprivate var scrollView: UIScrollView = UIScrollView()
    fileprivate var pageControl: UIPageControl = UIPageControl()
    fileprivate var timer: Timer?
    var images: [String] = [String]()
    
    @IBInspectable var pageCount: Int = 3 {
        didSet {
            createSubviews()
        }
    }
    @IBInspectable var controlActiveColor: UIColor = UIColor.blue {
        didSet {
            createSubviews()
        }
    }
    @IBInspectable var controlDefaultColor: UIColor = UIColor.purple {
        didSet {
            createSubviews()
        }
    }
    @IBInspectable var interval: Double = 3 {
        didSet {
            createSubviews()
        }
    }
    @IBInspectable var pageBottom: CGFloat = 30 {
        didSet {
            createSubviews()
        }
    }
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createSubviews()
        setupTimer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        createSubviews()
        setupTimer()
    }
    
    convenience init(frame: CGRect, images: [String], pageCount: Int, controlActiveColor: UIColor, controlDefaultColor: UIColor) {
        self.init(frame: frame)
        
        self.images = images
        self.pageCount = pageCount
        self.controlActiveColor = controlActiveColor
        self.controlDefaultColor = controlDefaultColor
        setupTimer()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setSize()
    }
    
    // MARK: public
    public func carouselImages(_ images: [String]) {
        self.images = images
        
        createSubviews()
    }
    
    // MARK: Privates
    private func createSubviews() {
        addSubview(scrollView)
        addSubview(pageControl)
        
        setupLayout()
    }
    
    fileprivate func setupTimer() {
        timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(CarouselView.nextImage), userInfo: nil, repeats: true)
    }
    
    private func setupLayout() {
        // ScrollView
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        
        // Images
        for image in images {
            let img = UIImage(named: image)
            let imageView = UIImageView()
            imageView.image = img
            
            scrollView.addSubview(imageView)
        }
        
        setSize()
        
        // PageControl
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: pageBottom).isActive = true
        pageControl.setNeedsUpdateConstraints()
        
        pageControl.numberOfPages = pageCount
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = controlActiveColor
        pageControl.pageIndicatorTintColor = controlDefaultColor
    }
    
    private func setSize() {
        scrollView.contentSize = CGSize(width: CGFloat(pageCount) * frame.width, height: frame.height)
        scrollView.contentOffset = CGPoint(x: CGFloat(pageControl.currentPage) * frame.width, y: 0)
        
        for (i, _) in images.enumerated() {
            scrollView.subviews[i].frame = CGRect(x: CGFloat(i) * frame.width, y: 0, width: frame.width, height: frame.height)
        }
    }
    
    @objc private func nextImage() {
        var currentIndex = pageControl.currentPage
        
        if (currentIndex == pageControl.numberOfPages - 1) {
            currentIndex = 0
        } else {
            currentIndex += 1
        }
        
        scrollView.setContentOffset(CGPoint(x: CGFloat(currentIndex) * frame.width, y: 0), animated: true)
        pageControl.currentPage = currentIndex
    }
}

extension CarouselView: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x / frame.width)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        timer?.invalidate()
        timer = nil
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        setupTimer()
    }
}
