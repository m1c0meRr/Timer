//
//  TimerView.swift
//  Timer
//
//  Created by Sergey Savinkov on 27.06.2023.
//

import UIKit

class ParametersView: UIView {
    
    private let setsLabel: UILabel = {
        let label = UILabel()
        label.text = "Повторения"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let numberOfSetLabel: UILabel = {
        let label = UILabel()
        label.text = "1"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.text = "Таймер"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var setsSlider: UISlider = {
       let slider = UISlider()
        slider.minimumValue = 1
        slider.maximumValue = 20
        slider.minimumTrackTintColor = .systemOrange
        slider.maximumTrackTintColor = .black
        slider.addTarget(self, action: #selector(setsSliderChanged), for: .valueChanged)
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    var pickerButton: UIPickerView = {
        let picker = UIPickerView()
        picker.backgroundColor = .white
        picker.layer.cornerRadius = 10
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private var setsStackView = UIStackView()
    private var timerStackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setConstraints()
        setDelegate()
    }
    
    private func setDelegate() {
        pickerButton.dataSource = self
        pickerButton.delegate = self
    }
    
    private func setupViews() {
        backgroundColor = .systemGray
        addShadowOnView(opacity: 0.9, radius: 4.0)
        layer.cornerRadius = 10.0
        translatesAutoresizingMaskIntoConstraints = false
        
        setsStackView = UIStackView(arrangedSubviews: [setsLabel,
                                                       numberOfSetLabel],
                                    axis: .horizontal,
                                    spacing: 10)
        
        addSubview(setsStackView)
        addSubview(setsSlider)
        addSubview(timerLabel)
        addSubview(pickerButton)
    }
    
    @objc private func setsSliderChanged() {
        numberOfSetLabel.text = "\(Int(setsSlider.value))"
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
        
            setsStackView.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            setsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            setsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            
            setsSlider.topAnchor.constraint(equalTo: setsStackView.bottomAnchor, constant: 10),
            setsSlider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            setsSlider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            
            timerLabel.topAnchor.constraint(equalTo: setsSlider.bottomAnchor, constant: 15),
            timerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            timerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            
            pickerButton.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: 10),
            pickerButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            pickerButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            pickerButton.heightAnchor.constraint(equalToConstant: 80),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ParametersView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return "\(row) мин"
        } else {
            return "\(row) сек"
        }
    }
}

extension ParametersView: UIPickerViewDataSource {
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
}
