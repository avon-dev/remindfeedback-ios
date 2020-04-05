//
//  ViewController.swift
//  rfios
//
//  Created by Taeheon Woo on 2019/11/08.
//  Copyright © 2019 avon. All rights reserved.
//

import Floaty
import iOSDropDown
import Photos
import RxCocoa
import RxDataSources
import RxSwift
import RxViewController
import SideMenuSwift
import UIKit

/// 앱이 실행되고 처음 실행되는 컨트롤러. 사용자의 피드백 리스트가 보이는 화면
class MainViewController: UIViewController {
    
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
    
    /// 주제선택 드롭다운
    @IBOutlet weak var dropDown: DropDown!
    @IBOutlet weak var tableView: UITableView!
    /// 플로팅 버튼
    let floatingBtn = Floaty()
    
    /// 로그인 여부를 확인하는 플래그 변수, 기본값은 false
    var isLogin = false

    override func viewDidLoad() {
        super.viewDidLoad()
//        NWLog.sLog(contentName: "기본 Realm 위치", contents: Realm.Configuration.defaultConfiguration.fileURL!)
        setUI()
        setBinding()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        navigationItem.title = "RemindFeedback"
        if !isLogin { self.checkLogin() }
    }
    
    func setUI() {
        self.navigationController?.navigationBar.tintColor = .white
        SideMenuController.preferences.basic.menuWidth = 200
        
        // 드롭다운 설정
        // The list of array to display. Can be changed dynamically
        dropDown.optionArray = ["Option 1", "Option 2", "Option 3"]
        // Its Id Values and its optional
//        dropDown.optionIds = [1,23,54,22]
        
        // 테이블 뷰 설정
        let cellName = UINib(nibName: "FeedbackCell", bundle: nil)
        tableView.register(cellName, forCellReuseIdentifier: "feedbackCell")
        tableView.estimatedRowHeight = 80.0
        
        // 플로팅 버튼 설정
        // 플로팅 버튼 위치 상향 조정
        // floaty.paddingY = 80.0
        
        // 태헌 : 사용자가 플로팅 버튼을 클릭했을 때, 화면에 표시되는 하위 플로팅 버튼을 추가하는 코드
        
//        floaty.itemButtonColor = floaty.buttonColor
        
        // [예산추가] 하위 플로팅 버튼 추가, 해당 버튼을 눌렀을 때, 예산추가 화면으로 이동하기 위해 사용되는 코드
        self.floatingBtn.addItem("피드백추가", icon: nil, handler: { item in
            self.viewModel.onAddFeedback()
        })
        
        // 화면에 플로팅 버튼 추가
        self.view.addSubview(self.floatingBtn)
        
    }
    

}

// - MARK: Binding
extension MainViewController {
    
    func setBinding() {
        
        // MARK: Scene
        self.rx.isVisible
            .subscribe(onNext: { [weak self] in
                if $0 {
                    self?.viewModel.setScene(self ?? UIViewController())
                }
            })
            .disposed(by: self.disposeBag)
        
        // MARK: Output
        /// 테이블 뷰 셀을 좌측으로 스와이프할 때
        tableView.rx.itemDeleted
            .subscribe(onNext: {
                // 해당 피드백을 삭제
                self.viewModel.removeFeedback($0.item)
            })
            .disposed(by: self.disposeBag)
        
        /// 테이블 뷰 셀을 선택했을 때
        tableView.rx.itemSelected
            .map{ $0.item }
            .subscribe(onNext: {
                // 해당 피드백에 대한 상세 화면으로 이동
                self.viewModel.onBoard($0)
            })
            .disposed(by: self.disposeBag)
        
        /// 테이블 셀을 스크롤할 때
        tableView.rx.didScroll
            .subscribe(onNext: { [weak self] in
                
                guard let vc = self else { return }
                
                let offset: CGFloat = 100
                let bottomEdge = vc.tableView.contentOffset.y + vc.tableView.frame.size.height
                if (bottomEdge + offset >= vc.tableView.contentSize.height) {
                    vc.viewModel.fetchFeedbackList()
                }
            })
            .disposed(by: disposeBag)
        
        // MARK: Input
        /// 테이블뷰 설정
        viewModel.feedbackListOutput
            .bind(to: tableView.rx.items(cellIdentifier: FeedbackCell.identifier
                , cellType: FeedbackCell.self)) { [weak self] index, item, cell in
                
                cell.dataInput.onNext(item)
                cell.viewModel = self?.viewModel
                cell.index = index
            }
        .disposed(by: self.disposeBag)

    }
}

// MARK: Side Menu
extension MainViewController {
    @IBAction func showSideMenu(_ sender: Any) {
        self.sideMenuController?.revealMenu()
    }
}

// MARK: Check login
extension MainViewController {
    
    /// 로그인 여부를 체크하는 함수
    func checkLogin() {
        NWLog.cLog()
        
        guard let cookie = UserDefaultsHelper.sharedInstantce.getCookie() else {
            // 옵셔널이 없네;;
            let viewController = UIStoryboard(name: "Login", bundle: nil)
                .instantiateViewController(withIdentifier: "loginVC")
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: false, completion: nil)
            return
        }
        
//        guard !(HTTPCookieStorage.shared.cookies?.contains(cookie) ?? false) else { return }
        
        // 쿠키값 설정
        HTTPCookieStorage.shared.setCookie(cookie)
        NWLog.sLog(contentName: "쿠키", contents: cookie)
        
        // 사용자의 피드백 요청
        self.viewModel.fetchFeedbackList()
        
        // 로그인 여부 : true
        self.isLogin = true
    }
}

