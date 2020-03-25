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
    
    // - MARK: Rx
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
    /// 주제선택 드롭다운
    @IBOutlet weak var dropDown: DropDown!
    /// 피드백 테이블 뷰
    @IBOutlet weak var tableView: UITableView!
    /// 플로팅 버튼
    let floatingBtn = Floaty()
    
    // - MARK: Variable
    /// 로그인 여부를 확인하는 플래그 변수, 기본값은 false
    var isLogin = false

    // - MARK: Life Cycle
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
        SideMenuController.preferences.basic.menuWidth = 250
        
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

//            let storyBoard = UIStoryboard(name: "Feedback", bundle: nil)
//            let viewController = storyBoard.instantiateViewController(withIdentifier: "editFeedbackVC") as! EditFeedbackViewController
//            self.navigationController?.pushViewController(viewController, animated: true)
            
            self.viewModel.onAddFeedback()

        })
        
        // 화면에 플로팅 버튼 추가
        self.view.addSubview(self.floatingBtn)
        
    }
    

}

// - MARK: Binding
extension MainViewController {
    
    func setBinding() {
        
        // - MARK: V to VM
        
        // Scene
        self.rx.isVisible
            .subscribe(onNext: { [weak self] in
                if $0 { self?.viewModel.setScene(self ?? UIViewController()) }
            })
            .disposed(by: self.disposeBag)
        
        // 테이블 뷰 셀을 좌측으로 스와이프할 때
        self.tableView.rx.itemDeleted
            .subscribe(onNext: {
                // 해당 피드백을 삭제
                self.viewModel.delFeedback($0.item)
            })
            .disposed(by: self.disposeBag)
        
        // 테이블 뷰 셀을 선택했을 때
        self.tableView.rx.itemSelected
            .map{ $0.item }
            .subscribe(onNext: {
                // 해당 피드백에 대한 상세 화면으로 이동
                self.viewModel.onBoard($0)
            })
            .disposed(by: self.disposeBag)
        
        // - MARK: VM to V
        
        // 테이블뷰 설정
        viewModel.feedbackListOb
            .bind(to: tableView.rx.items(cellIdentifier: FeedbackCell.identifier, cellType: FeedbackCell.self)) { index, item, cell in

                cell.colorView.backgroundColor = UIUtil.hexStringToUIColor(item.category.color)
                cell.feedbackLabel.text = item.title

                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")

                cell.dateLabel.text = dateFormatter.string(from: item.date)

                // 사실 bind안에 subscribe하는 방법은 좋지 않은 방법이라고 생각된다.
                // 추후 바꿔줄 필요가 있을 것 같다.
                cell.rx.longPressGesture()
                    .when(.recognized)
                    .take(1) // 이게 다른 화면 갔다가 오면 중복으로 등록되는 경우가 있음, 다른 디스포즈백을 사용해야 할 듯(계속 등록되면 낭비될 것 같음)
                    .subscribe(onNext: { [weak self] in
                        NWLog.sLog(contentName: "피드백 셀 롱 클릭", contents: $0)
                        self?.viewModel.onModFeedback(index)
                    })
                    .disposed(by: self.disposeBag)
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
        self.viewModel.reqGetMyFeedbacks()
        
        // 로그인 여부 : true
        self.isLogin = true
    }
}

