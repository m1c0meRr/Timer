//
//  CustomAlert.swift
//  Timer
//
//  Created by Sergey Savinkov on 06.07.2023.
//

import UIKit

class CustomAlert: UIView {
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        view.alpha = 0
        return view
    }()
    
    private let alertView: UIView = {
       let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        view.layer.cornerRadius = 20
        return view
    }()
    
    private lazy var pickerButton = UIPickerView()
    private let scrollView = UIScrollView()
    private var mainView: UIView?
    private let setTextField = UITextField()
    private let timerTextField = UITextField()
        
    var buttonAction: ( (String, Int, Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        registerForKeyNotification()
        addDoneButtonOnKeyboard()
        setDelegate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setDelegate() {
        pickerButton.dataSource = self
        pickerButton.delegate = self
    }
    
    func AlertCustom(viewController: UIViewController,
                     complition: @escaping(String, Int, Int) -> Void) {
        
        guard let parentView = viewController.view else { return }
        mainView = parentView
        
        scrollView.frame = parentView.frame
        parentView.addSubview(scrollView)
        
        backgroundView.frame = parentView.frame
        scrollView.addSubview(backgroundView)
        
        alertView.frame = CGRect(x: 40,
                                 y: -400,
                                 width: parentView.frame.width - 80,
                                 height: 600)
        scrollView.addSubview(alertView)
        
        let alertImageView = UIImageView(frame: CGRect(x: (alertView.frame.width - alertView.frame.height * 0.3) / 2,
                                                       y: 30,
                                                       width: alertView.frame.width * 0.55,
                                                       height: alertView.frame.height * 0.4))
        alertImageView.image = UIImage(named: "alertImage")
        alertImageView.contentMode = .scaleAspectFit
        alertView.addSubview(alertImageView)
        
        let editingLabel = UILabel(frame: CGRect(x: 10,
                                                 y: alertView.frame.height * 0.4 + 25 ,
                                                 width: alertView.frame.width - 20,
                                                 height: 25))
        editingLabel.text = "Настройки"
        editingLabel.textColor = .white
        editingLabel.textAlignment = .center
        editingLabel.font = UIFont.boldSystemFont(ofSize: 23)
        alertView.addSubview(editingLabel)
        
        let setsLabel = UILabel(frame: CGRect(x: 30,
                                              y: editingLabel.frame.maxY + 10,
                                             width: alertView.frame.width - 60,
                                             height: 25))
        setsLabel.text = "Повторы"
        setsLabel.textColor = .white
        setsLabel.font = UIFont.systemFont(ofSize: 20)
        setsLabel.translatesAutoresizingMaskIntoConstraints = true
        alertView.addSubview(setsLabel)
        
        setTextField.frame = CGRect(x: 20,
                                    y: setsLabel.frame.maxY + 5,
                                    width: alertView.frame.width - 40,
                                    height: 30)
        setTextField.backgroundColor = .white
        setTextField.borderStyle = .none
        setTextField.text = "1"
        setTextField.layer.cornerRadius = 10
        setTextField.textColor = .black
        setTextField.font = UIFont.systemFont(ofSize: 20)
        setTextField.leftView = UIView(frame: CGRect(x: 0,
                                                     y: 0,
                                                     width: 15,
                                                     height: setTextField.frame.height))
        setTextField.leftViewMode = .always
        setTextField.clearButtonMode = .always
        setTextField.returnKeyType = .done
        setTextField.keyboardType = .numberPad
        alertView.addSubview(setTextField)
        
        let timerLabel = UILabel(frame: CGRect(x: 30,
                                              y: setTextField.frame.maxY + 10,
                                             width: alertView.frame.width - 60,
                                             height: 20))
        timerLabel.text = "Таймер"
        timerLabel.textColor = .white
        timerLabel.font = UIFont.systemFont(ofSize: 20)
        timerLabel.translatesAutoresizingMaskIntoConstraints = true
        alertView.addSubview(timerLabel)
        
        pickerButton.layer.cornerRadius = 10
        pickerButton.backgroundColor = .white
        pickerButton.frame = CGRect(x: 20,
                                    y: timerLabel.frame.maxY + 10,
                                    width: alertView.frame.width - 30,
                                    height: 80)
        
        alertView.addSubview(pickerButton)
        
        let okButton = UIButton(frame: CGRect(x: 50,
                                              y: pickerButton.frame.maxY + 25,
                                              width: alertView.frame.width - 100,
                                              height: 35))
        okButton.backgroundColor = .systemOrange
        okButton.setTitle("Сохранить", for: .normal)
        okButton.titleLabel?.textColor = .white
        okButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        okButton.layer.cornerRadius = 10
        okButton.addTarget(self, action: #selector(okButtonAction), for: .touchUpInside)
        alertView.addSubview(okButton)
        
        buttonAction = complition
        
        UIView.animate(withDuration: 0.3) {
            self.backgroundView.alpha = 0.8
        } completion: { done in
            if done {
                UIView.animate(withDuration: 0.3) {
                    self.alertView.center = parentView.center
                }
            }
        }
        
        let cancelButton = UIButton(frame: CGRect(x: 50,
                                              y: okButton.frame.maxY + 10,
                                              width: alertView.frame.width - 100,
                                              height: 35))
        cancelButton.backgroundColor = .systemRed
        cancelButton.setTitle("Отмена", for: .normal)
        cancelButton.titleLabel?.textColor = .white
        cancelButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        cancelButton.layer.cornerRadius = 10
        cancelButton.addTarget(self, action: #selector(dismisAlert), for: .touchUpInside)
        alertView.addSubview(cancelButton)
        
        buttonAction = complition
        
        UIView.animate(withDuration: 0.3) {
            self.backgroundView.alpha = 0.8
        } completion: { done in
            if done {
                UIView.animate(withDuration: 0.3) {
                    self.alertView.center = parentView.center
                }
            }
        }
    }
    
    @objc private func okButtonAction() {
        guard let setNumber = setTextField.text else { return }
        let minNumber = pickerButton.selectedRow(inComponent: 0)
        let timerNumber = pickerButton.selectedRow(inComponent: 1)
        
        buttonAction?(setNumber, minNumber, timerNumber)
        dismisAlert()
    }

    @objc private func dismisAlert() {
        guard let targetView = mainView else { return }
        
        UIView.animate(withDuration: 0.3) {
            self.alertView.frame = CGRect(x: 40,
                                          y: targetView.frame.height,
                                          width: targetView.frame.width - 80,
                                          height: 400)
        } completion: { done in
            if done {
                UIView.animate(withDuration: 0.3) {
                    self.backgroundView.alpha = 0
                } completion: { [weak self] done in
                    guard let self = self else { return }
                    if done {
                        self.alertView.removeFromSuperview()
                        self.backgroundView.removeFromSuperview()
                        self.scrollView.removeFromSuperview()
                        self.removeForKeyNotification()
                        self.setTextField.text = ""
                        self.timerTextField.text = ""
                    }
                }
            }
        }
    }
    
    private func registerForKeyNotification() {
        print("registerForKeyNotification")
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    private func removeForKeyNotification() {
        print("removeForKeyNotification")
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }
    
    private func addDoneButtonOnKeyboard() {
        let doneToolBar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolBar.barStyle = UIBarStyle.default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Хорошо", style: .done, target: self, action: #selector(doneButtonAction))
        
        let item = [flexSpace, done]
        doneToolBar.items = item
        doneToolBar.sizeToFit()
        
        self.setTextField.inputAccessoryView = doneToolBar
    }
    
    @objc private func doneButtonAction() {
        self.setTextField.resignFirstResponder()
    }
    
    @objc private func keyboardWillShow() {
        scrollView.contentOffset = CGPoint(x: 0, y: 120)
    }
    
    @objc private func keyboardWillHide() {
        scrollView.contentOffset = CGPoint.zero
    }
}

extension CustomAlert: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return "\(row) мин"
        } else {
            return "\(row) сек"
        }
    }
}

extension CustomAlert: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return 24
        } else if component == 1 {
            return 60
        }
        return 0
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(row)
    }
}
    

