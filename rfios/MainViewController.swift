//
//  ViewController.swift
//  rfios
//
//  Created by Taeheon Woo on 2019/11/08.
//  Copyright © 2019 avon. All rights reserved.
//

import RxCocoa
import RxSwift
import RxViewController
import SideMenuSwift
import UIKit

class MainViewController: UIViewController {
    
    
    var viewModel: MainViewModelType
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var tableView: UITableView!
    
    init(viewModel: MainViewModelType = MainViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        viewModel = MainViewModel()
        super.init(coder: aDecoder)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cellName = UINib(nibName: "FeedbackCell", bundle: nil)
        tableView.register(cellName, forCellReuseIdentifier: "feedbackCell")
        tableView.estimatedRowHeight = 80.0
//        tableView.rowHeight = UITableView.automaticDimension
//        self.tableView.rowHeight = 80
        setBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("main viewWillAppear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        print("main viewDidAppear")
        self.checkLogin()
        
//        let transition = CATransition()
//        transition.duration = 0.2
//        transition.type = CATransitionType.push
//        transition.subtype = CATransitionSubtype.fromRight
//        self.view.window!.layer.add(transition, forKey: kCATransition)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        print("main viewWillDisappear")
        self.navigationController?.navigationBar.frame.height
    }
    
    func setBinding() {
        
        // 테이블뷰 설정
        viewModel.feedbackList
//            .bind(to: tableView.rx.items) {
//                (tableView, index, element) in
//
//                let indexPath = IndexPath(item: index, section: 0)
//
//                guard let cell = tableView.dequeueReusableCell(withIdentifier: "feedbackCell", for: indexPath) as? FeedbackCell else { return UITableViewCell() }
//
//                cell.feedbackLabel.text = element
//
//                return cell
//            }
            .bind(to: tableView.rx.items(cellIdentifier: FeedbackCell.identifier, cellType: FeedbackCell.self)) {
                
//                index, element, cell in
                _, item, cell in
                
                cell.feedbackLabel.text = item
            }
            .disposed(by: disposeBag)

    }
    
    @IBAction func showSideMenu(_ sender: Any) {
        sideMenuController?.revealMenu()
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

