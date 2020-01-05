//
//  ViewController.swift
//  rfios
//
//  Created by Taeheon Woo on 2019/11/08.
//  Copyright © 2019 avon. All rights reserved.
//

import Floaty
import iOSDropDown
import RxCocoa
import RxSwift
import RxViewController
import SideMenuSwift
import UIKit

class MainViewController: UIViewController {
    
    
    // - MARK: RX
    var viewModel: MainViewModelType
    var disposeBag = DisposeBag()
    
    init(viewModel: MainViewModelType = MainViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        viewModel = MainViewModel()
        super.init(coder: aDecoder)
    }
    
    // - MARK: View
    @IBOutlet weak var dropDown: DropDown! // 주제선택 드롭다운
    @IBOutlet weak var tableView: UITableView! // 피드백 테이블 뷰
    let floatingBtn = Floaty()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        setUI()
        setBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
//        self.checkLogin()
    }
    
    func setUI() {
        // 드롭다운 설정
        // The list of array to display. Can be changed dynamically
        dropDown.optionArray = ["Option 1", "Option 2", "Option 3"]
        // Its Id Values and its optional
//        dropDown.optionIds = [1,23,54,22]
        
        // 테이블 뷰 설정
        let cellName = UINib(nibName: "FeedbackCell", bundle: nil)
        tableView.register(cellName, forCellReuseIdentifier: "feedbackCell")
        tableView.estimatedRowHeight = 80.0
//        tableView.rowHeight = UITableView.automaticDimension
//        self.tableView.rowHeight = 80
        
        // 플로팅 버튼 설정
        // 플로팅 버튼 위치 상향 조정
        // floaty.paddingY = 80.0
        
        // 태헌 : 사용자가 플로팅 버튼을 클릭했을 때, 화면에 표시되는 하위 플로팅 버튼을 추가하는 코드
        
//        floaty.itemButtonColor = floaty.buttonColor
        
        // [예산추가] 하위 플로팅 버튼 추가, 해당 버튼을 눌렀을 때, 예산추가 화면으로 이동하기 위해 사용되는 코드
        self.floatingBtn.addItem("피드백추가", icon: nil, handler: {

            item in

            let storyBoard = UIStoryboard(name: "Feedback", bundle: nil)
            let viewController = storyBoard.instantiateViewController(withIdentifier: "editFeedbackVC") as! EditFeedbackViewController
            self.navigationController?.pushViewController(viewController, animated: true)
            
//            categoryBtn.rx.tap
//            .subscribe(onNext: { [weak self] in
//                print("on주제설정")
//                self?.sideMenuController?.hideMenu()
//                self?.viewModel.onCategory()
//            })
//            .disposed(by: self.disposeBag)

        })
        
        // 화면에 플로팅 버튼 추가
        self.view.addSubview(self.floatingBtn)
        
        
    }
    
    func setBinding() {
        
        // Scene
        self.rx.isVisible
            .subscribe(onNext: { [weak self] in
                if $0 { self?.viewModel.setScene(self ?? UIViewController()) }
            })
            .disposed(by: self.disposeBag)
        
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
        print("로그인 체크")
        guard let cookie = UserDefaultsHelper.sharedInstantce.getCookie() else {
            
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
        
        HTTPCookieStorage.shared.setCookie(cookie)
        print("쿠키?", cookie)
        
    }
    

}

