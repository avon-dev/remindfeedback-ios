//
//  MyPageViewController.swift
//  rfios
//
//  Created by Taeheon Woo on 2020/02/12.
//  Copyright © 2020 avon. All rights reserved.
//

import Kingfisher
import RxCocoa
import RxGesture
import RxSwift
import RxViewController
import SCLAlertView
import UIKit

class MyPageViewController: UIViewController {
    
    var viewModel: MyPageViewModelType
    var disposeBag = DisposeBag()
    var picker: RxMediaPicker!
    
    init(viewModel: MyPageViewModelType = MyPageViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        viewModel = MyPageViewModel()
        super.init(coder: aDecoder)
    }
    
    deinit {
        self.disposeBag = DisposeBag()
    }
    
    @IBOutlet weak var portraitImg: UIImageView!
    @IBOutlet weak var portraitBtn: UIButton!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var nicknameBtn: UIButton!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var introLabel: UILabel!
    @IBOutlet weak var introBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setBinding()
    }
    
}

// MARK: UI
extension MyPageViewController {
    func setUI() {
        setNavUI()
    }
    
    func setNavUI() {
        self.navigationController?.navigationBar.topItem?.title = ""
        navigationItem.title = "마이페이지"
    }
}

// MARK: Binding
extension MyPageViewController {
    
    func setBinding() {
        // MARK: Scene
        self.rx.isVisible
            .subscribe(onNext: { [weak self] in
                if $0 {
                    self?.viewModel.setScene(self ?? UIViewController())
                    self?.viewModel.fetchMyPage()
                }
            })
            .disposed(by: disposeBag)
        
        // MARK: Set RxMediaPicker
        picker = RxMediaPicker(delegate: self)
        
        // MARK: Output
        // 프로필 변경 버튼
        portraitBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.bindActionSheet()
            })
            .disposed(by: disposeBag)
        
        // 닉네임 변경 버튼
        nicknameBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.editNickName()
            })
            .disposed(by: disposeBag)
        
        // 소개글 변경 버튼
        introBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.editIntro()
            })
            .disposed(by: disposeBag)
        
        // MARK: Input
        // 로그인한 유저 정보 옵저버블
        viewModel.userOutput
            .asObservable()
            .subscribe(onNext: { [weak self] in
                self?.nicknameLabel.text = $0.nickname
                self?.emailLabel.text = $0.email
                if !$0.introduction.isEmpty { self?.introLabel.text = $0.introduction }
                if !$0.portrait.isEmpty {
                    self?.portraitImg.kf.setImage(with: URL(string: RemindFeedback.imgURL + $0.portrait))
                    self?.portraitImg.layer.cornerRadius = (self?.portraitImg.frame.height ?? 40)/2
                    self?.portraitImg.clipsToBounds = true
                }
            })
            .disposed(by: disposeBag)
        
        keyboardHeight()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.view.frame.origin.y = -$0/2
            })
            .disposed(by: disposeBag)
    }
}

// MARK: RxMedia
extension MyPageViewController: RxMediaPickerDelegate {
    func present(picker: UIImagePickerController) {
        present(picker, animated: true, completion: nil)
    }
    
    func dismiss(picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func pickPhoto() {
        picker.selectImage(editable: true)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (image, editedImage) in
                self?.portraitImg.image = editedImage ?? image
                self?.viewModel.modifyPortrait(editedImage ?? image)
            }, onError: { error in
                print("Picker photo error: \(error)")
            }, onCompleted: {
                print("Completed")
            }, onDisposed: {
                print("Disposed")
            })
            .disposed(by: disposeBag)
    }
    
    func pickCamera() {
        picker.takePhoto(editable: true)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (image, editedImage) in
                self?.portraitImg.image = editedImage ?? image
                self?.viewModel.modifyPortrait(editedImage ?? image)
            }, onError: { error in
                print("Picker photo error: \(error)")
            }, onCompleted: {
                print("Completed")
            }, onDisposed: {
                print("Disposed")
            })
            .disposed(by: disposeBag)
    }
    
    func bindActionSheet() {
        actionSheet(title: "프로필 이미지 변경", text: "프로필 이미지를 변경합니다.",
                    actions: [("사진 앱에서 이미지 선택", pickPhoto), ("카메라 앱에서 이미지 선택", pickCamera)])
            .subscribe()
            .disposed(by: disposeBag)
    }
}

// TODO: Modify to change MVVM style
// MARK: Edit
extension MyPageViewController {
    func editNickName() {
        let hexString = "1389FF"
        let colorInt = UInt(String(hexString.suffix(6)), radix: 16) ?? SCLAlertViewStyle.edit.defaultColorInt
        
        let alert = SCLAlertView()
        let editField: UITextField? = alert.addTextField(self.viewModel.user.nickname)
        editField?.backgroundColor = .white
        editField?.textColor = .black
        alert.addButton("변경") { [weak self] in
            if let txt = editField?.text {
                self?.viewModel.modifyNickname(txt)
            }
        }
        
        alert.showEdit("닉네임 변경", subTitle: "변경할 닉네임을 입력해주세요", closeButtonTitle: "취소" , colorStyle: colorInt)
    }
    
    func editIntro() {
        let hexString = "1389FF"
        let colorInt = UInt(String(hexString.suffix(6)), radix: 16) ?? SCLAlertViewStyle.edit.defaultColorInt
        
        let alert = SCLAlertView()
        let editField: UITextField? = alert.addTextField(self.viewModel.user.introduction)
        editField?.backgroundColor = .white
        editField?.textColor = .black
        alert.addButton("변경") { [weak self] in
            if let txt = editField?.text {
                self?.viewModel.modifyIntroduction(txt)
            }
        }
        
        alert.showEdit("소개글 변경", subTitle: "변경할 소개글을 입력해주세요", closeButtonTitle: "취소" , colorStyle: colorInt)
    }
}
