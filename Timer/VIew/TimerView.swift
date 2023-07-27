//
//  TimerView.swift
//  Timer
//
//  Created by Sergey Savinkov on 27.06.2023.
//

import UIKit

protocol NextSetTimerProtocol: AnyObject {
    func nextSetTimerTapped()
    func editingTimerTapped()
}

class TimerView: UIView {
    
    private let setsLabel: UILabel = {
        let label = UILabel()
        label.text = "Повторения"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let numberOfSetLabel: UILabel = {
        let label = UILabel()
        label.text = "1"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.text = "Время повтора"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let numberOfTimerLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let setLineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .white
        lineView.translatesAutoresizingMaskIntoConstraints = false
        return lineView
    }()
    
    private let timerLineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .white
        lineView.translatesAutoresizingMaskIntoConstraints = false
        return lineView
    }()
    
    private lazy var editingButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .none
        button.setTitle("Настройки", for: .normal)
        button.setImage(UIImage(systemName: "slider.vertical.3"), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.tintColor = .black
        button.addTarget(self, action: #selector(editingButtonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemOrange
        button.setTitle("Следущий повтор", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.tintColor = .black
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(nextButtonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    weak var nextSetTimerDelegate: NextSetTimerProtocol?
    
    private var setsStackView = UIStackView()
    private var timerStackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setConstraints()
    }
    
    private func setupViews() {
        backgroundColor = .systemGray.withAlphaComponent(0.9)
        layer.cornerRadius = 10.0
        addShadowOnView(opacity: 0.9, radius: 4.0)
        translatesAutoresizingMaskIntoConstraints = false
        
        setsStackView = UIStackView(arrangedSubviews: [setsLabel,
                                                       numberOfSetLabel],
                                    axis: .horizontal,
                                    spacing: 10)
        timerStackView = UIStackView(arrangedSubviews: [timerLabel,
                                                        numberOfTimerLabel],
                                     axis: .horizontal,
                                     spacing: 10)
        
        addSubview(setsStackView)
        addSubview(setLineView)
        addSubview(timerStackView)
        addSubview(timerLineView)
        addSubview(editingButton)
        addSubview(nextButton)
    }
    
    @objc private func editingButtonAction() {
        nextSetTimerDelegate?.editingTimerTapped()
    }
    
    @objc private func nextButtonAction() {
        nextSetTimerDelegate?.nextSetTimerTapped()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            
            editingButton.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            editingButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            editingButton.heightAnchor.constraint(equalToConstant: 10),
            
            setsStackView.topAnchor.constraint(equalTo: editingButton.bottomAnchor, constant: 20),
            setsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            setsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            
            setLineView.topAnchor.constraint(equalTo: setsStackView.bottomAnchor, constant: 15),
            setLineView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            setLineView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            setLineView.heightAnchor.constraint(equalToConstant: 1),
            
            timerStackView.topAnchor.constraint(equalTo: setLineView.bottomAnchor, constant: 15),
            timerStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            timerStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            
            timerLineView.topAnchor.constraint(equalTo: timerStackView.bottomAnchor, constant: 15),
            timerLineView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            timerLineView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            timerLineView.heightAnchor.constraint(equalToConstant: 1),
            
            nextButton.topAnchor.constraint(equalTo: timerLineView.bottomAnchor, constant: 15),
            nextButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            nextButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            nextButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
