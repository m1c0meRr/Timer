//
//  ViewController.swift
//  Timer
//
//  Created by Sergey Savinkov on 27.06.2023.
//

import UIKit

class ViewController: UIViewController {
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Установите таймер"
        label.font = UIFont.boldSystemFont(ofSize: 48)
        label.textColor = .white
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var setButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemOrange
        button.setTitle("Начать", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(setButtonAction), for: .touchUpInside)
        button.addShadowOnView(opacity: 0.9, radius: 4.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let setsAndTimerView = ParametersView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setConstraints()
    }
    
    private func setupViews() {
        view.backgroundColor = .black
        view.addSubview(headerLabel)
        view.addSubview(setsAndTimerView)
        view.addSubview(setButton)
    }
    private func saveSetAndTime() {
        UserSettings.shared.minInt = setsAndTimerView.pickerButton.selectedRow(inComponent: 0)
        UserSettings.shared.secInt = setsAndTimerView.pickerButton.selectedRow(inComponent: 1)
        UserSettings.shared.setInt = Int(setsAndTimerView.setsSlider.value)
    }
    
    private func sheetPresentation() {
        let vc = TimerViewController()
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = true
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = false
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 30
        }
        present(vc, animated: true)
    }
    
    private func presentTimer() {
        let min = setsAndTimerView.pickerButton.selectedRow(inComponent: 0)
        let sec = setsAndTimerView.pickerButton.selectedRow(inComponent: 1)
        
        if min + sec != 0 {
            saveSetAndTime()
            sheetPresentation()
        } else {
            alertOk(title: "Установите ", message: "значение слайдера")
        }
    }
    
    @objc private func setButtonAction() {
        presentTimer()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            
            headerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            headerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            
            setsAndTimerView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 50),
            setsAndTimerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            setsAndTimerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            setsAndTimerView.heightAnchor.constraint(equalToConstant: 230),
            
            setButton.topAnchor.constraint(equalTo: setsAndTimerView.bottomAnchor, constant: 50),
            setButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            setButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            setButton.heightAnchor.constraint(equalToConstant: 55)
        ])
    }
}
