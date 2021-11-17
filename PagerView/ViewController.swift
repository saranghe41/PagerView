//
//  ViewController.swift
//  PagerView
//
//  Created by 김지은 on 2021/11/17.
//

import UIKit
import FSPagerView

class ViewController: UIViewController, FSPagerViewDataSource, FSPagerViewDelegate {
    
    fileprivate let imageNames = ["1", "2", "3", "4"]

    @IBOutlet weak var myPagerView: FSPagerView! {
        didSet {
            // 페이저뷰에 셀을 등록한다.
            self.myPagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            // 아이템 크기 설정
            self.myPagerView.itemSize = FSPagerView.automaticSize
            // 무한스크롤 설정
            self.myPagerView.isInfinite = true
            // 스크롤 타임 설정
            self.myPagerView.automaticSlidingInterval = 4.0
        }
    }
    
    @IBOutlet weak var myPageControl: FSPageControl! {
        didSet {
            // 페이지의 표시 수 설정
            self.myPageControl.numberOfPages = imageNames.count
            // 페이지 표시 위치 설정
            self.myPageControl.contentHorizontalAlignment = .center
            // 페이지 표시 점과 점사이의 간격
            self.myPageControl.itemSpacing = 16
            //
            self.myPageControl.interitemSpacing = 16
        }
    }
    
    @IBOutlet weak var rightBtn: UIButton!
    @IBOutlet weak var leftBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print("ViewController - viewDidLoad() called")
        
        self.myPagerView.dataSource = self
        self.myPagerView.delegate = self
    
        rightBtn.layer.cornerRadius = self.rightBtn.frame.height / 2
        leftBtn.layer.cornerRadius = self.leftBtn.frame.height / 2
    }
    
    // MARK: - IBActions
    @IBAction func onLeftBtnClicked(_ sender: Any) {
        print("ViewController - onLeftBtnClicked() called")
        
        self.myPageControl.currentPage = self.myPageControl.currentPage - 1
        self.myPagerView.scrollToItem(at: self.myPageControl.currentPage, animated: true)
    }
    
    @IBAction func onRightBtnClicked(_ sender: Any) {
        print("ViewController - onRightBtnClicked() called")
        
        self.myPageControl.currentPage = self.myPageControl.currentPage + 1
        // 아웃오브레인지 에러가 나기 때문에 조건걸기 (currentPage의 수가 imageNames의 수를 넘어가면 에러남)
        if (self.myPageControl.currentPage == self.imageNames.count - 1) {
            self.myPageControl.currentPage = 0
        }
        else {
            self.myPagerView.scrollToItem(at: self.myPageControl.currentPage, animated: true)
        }
    }

    // MARK: - FSPagerView DataSource
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return imageNames.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        print("imageNames: \(imageNames[index])")
        cell.imageView?.image = UIImage(named: imageNames[index])
        cell.imageView?.contentMode = .scaleAspectFit
        return cell
    }

    // MARK: - FSPagerView Delegate
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        // 이미지를 드래깅했을때 페이지표시 변경
        self.myPageControl.currentPage = targetIndex
    }
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
        // 페이지가 자동 스크롤 되었을때 페이지표시 변경
        self.myPageControl.currentPage = pagerView.currentIndex
    }
    
    func pagerView(_ pagerView: FSPagerView, shouldHighlightItemAt index: Int) -> Bool {
        // 이미지 포커싱(선택표시) 제거
        return false
    }
}

