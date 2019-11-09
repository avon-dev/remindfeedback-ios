//
//  ViewController.swift
//  rfios
//
//  Created by Taeheon Woo on 2019/11/08.
//  Copyright © 2019 avon. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        self.checkLogin()

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        print("viewDidDisappear")
    }
    
    // 로그인 여부를 체크하는 함수
    func checkLogin() {
        let isLogin = true

        guard isLogin else {


//            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "loginVC") {
//
//                vc.modalPresentationStyle = .fullScreen
//                self.present(vc, animated: true, completion: nil)
//            }

            // 옵셔널이 없네;;
            let vc = UIStoryboard(name: "Login", bundle: nil)
                .instantiateViewController(withIdentifier: "loginVC")

            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: false, completion: nil)


            return
        }
    }
    


}

