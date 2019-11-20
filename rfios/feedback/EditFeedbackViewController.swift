//
//  EditFeedbackViewController.swift
//  rfios
//
//  Created by Taeheon Woo on 2019/11/10.
//  Copyright © 2019 avon. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class EditFeedbackViewController: UIViewController {

    @IBOutlet weak var titleTextview: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegate()
        setUI()
    }
    
    func setDelegate() {
        self.titleTextview.delegate = self
    }
    
    func setUI() {
        self.titleTextview.textContainer.maximumNumberOfLines = 2
        self.titleTextview.textContainer.lineBreakMode = .byTruncatingTail
    }
    
    func setBinding() {
        
    }
    


}

extension EditFeedbackViewController: UITextViewDelegate {
    
    
    // TextView의 글자 수 제한을 위한 함수
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        print(1)
        // 피드백 주제 글자 수 제한
        if textView == self.titleTextview {print(2)
            guard let str = textView.text else { return true }
            let newLength = str.count + text.count - range.length
            return newLength <= 20 // 20자 제한
        }
        
        return true
    }
    
}
