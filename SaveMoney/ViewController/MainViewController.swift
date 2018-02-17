//
//  MainViewController.swift
//  SaveMoney
//
//  Created by Semyon on 17.02.2018.
//  Copyright © 2018 Semyon. All rights reserved.
//

import RxCocoa
import RxSwift
import RxSwiftExt
import UIKit

final class MainViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet var firstView: UIView!
    @IBOutlet var secondView: UIView!
    @IBOutlet var thirdView: UIView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var scrollView: UIScrollView!
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    // MARK: - Members
    
    // MARK: - Methods
}

extension MainViewController: UIScrollViewDelegate {
    
    private func updateScroll(progress: CGFloat) { self.pageControl.currentPage = Int(round(progress)) }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let w = UIScreen.main.bounds.width
        let progress = (scrollView.contentOffset.x / w).bound(min: 0, max: 2)
        
        updateScroll(progress: progress)
        view.endEditing(true)
    }
}
