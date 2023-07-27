//
//  TimerViewController.swift
//  Timer
//
//  Created by Sergey Savinkov on 27.06.2023.
//

import UIKit

class TimerViewController: UIViewController {
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Таймер"
        label.font = UIFont.boldSystemFont(ofSize: 48)
        label.textColor = .white
        label.numberOfLines = 1
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.text = "0.0"
        label.font = UIFont.boldSystemFont(ofSize: 48)
        label.textColor = .white
        label.numberOfLines = 1
        label.textAlignment = .center
        label.backgroundColor = .systemOrange
        label.layer.cornerRadius = 22.5
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ellipseImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Ellipse")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var startButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        button.setTitle("Начать тренировку", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.tintColor = .black
        button.layer.cornerRadius = 10
        button.addShadowOnView(opacity: 0.9, radius: 4.0)
        button.addTarget(self, action: #selector(startButtonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var finishButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGray
        button.setTitle("Закончить тренировку", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.tintColor = .black
        button.layer.cornerRadius = 10
        button.addShadowOnView(opacity: 0.9, radius: 4.0)
        button.addTarget(self, action: #selector(finishButtonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let timerView = TimerView()
    private let customAlert = CustomAlert()
    
    private var timer = Timer()
    private let shapeLayer = CAShapeLayer()
    
    private var isPaused = true
    private var isFirstTouch = true
    
    private var numberOfSets = 0
    private var durationTimer = 10
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        animationCircylar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setConstraints()
        setTimerParameters()
        addTaps()
        setDelegate()
    }
    
    private func setupViews() {
        view.backgroundColor = #colorLiteral(red: 0.1329308748, green: 0.1329308748, blue: 0.1329308748, alpha: 1)
        
        view.addSubview(headerLabel)
        view.addSubview(ellipseImageView)
        view.addSubview(timerLabel)
        view.addSubview(timerView)
        view.addSubview(startButton)
        view.addSubview(finishButton)
    }
    
    private func setDelegate() {
        timerView.nextSetTimerDelegate = self
    }
    
    private func setTimerParameters() {
        let min = UserSettings.shared.minInt
        let sec = UserSettings.shared.secInt
        
        timerView.numberOfSetLabel.text = "\(numberOfSets)/\(UserSettings.shared.setInt)"
        timerView.numberOfTimerLabel.text = "\(min) мин. \(sec) сек."
        
        timerLabel.text = "\(min.setZeroForSoceounds()):\(sec.setZeroForSoceounds())"
        durationTimer = (UserSettings.shared.minInt * 60) + UserSettings.shared.secInt
    }
    
    private func addTaps() {
        let tapLabel = UITapGestureRecognizer(target: self, action: #selector(startTimer))
        timerLabel.isUserInteractionEnabled = true
        timerLabel.addGestureRecognizer(tapLabel)
    }
    
    private func resetTimer() {
        timer.invalidate()
        basicAnimation(remove: true)
        pauseAnimation()
        durationTimer = (UserSettings.shared.minInt * 60) + UserSettings.shared.secInt
        let min = durationTimer / 60
        let sec = durationTimer % 60
        timerLabel.text = "\(min.setZeroForSoceounds()):\(sec.setZeroForSoceounds())"
    }
    
    @objc private func timerAction() {
        durationTimer -= 1
        
        if durationTimer == 0 {
            timer.invalidate()
            
            durationTimer = (UserSettings.shared.minInt * 60) + UserSettings.shared.secInt
            numberOfSets += 1
            
            basicAnimation(remove: true)
            pauseAnimation()
            startButton.setTitle("Продолжить", for: .normal)
            timerView.numberOfSetLabel.text = "\(numberOfSets)/\(UserSettings.shared.setInt)"
        }
        
        let min = durationTimer / 60
        let sec = durationTimer % 60
        timerLabel.text = "\(min.setZeroForSoceounds()):\(sec.setZeroForSoceounds())"
    }
    
    
    @objc private func startButtonAction() {
        startTimer()
    }
    
    @objc private func finishButtonAction() {
        if numberOfSets == UserSettings.shared.setInt {
            dismiss(animated: true)
        } else {
            alertOkCancel(title: "Внимание", message: "Отсчет не закончен", titleOk: "Ok", titleCancel: "Cancel") {
                self.dismiss(animated: true)
            }
        }
    }
    
    @objc private func startTimer() {
        if numberOfSets == UserSettings.shared.setInt {
            alertOk(title: "Повторения закончились", message: .none)
        } else {
            if isPaused && isFirstTouch {
                basicAnimation(remove: false)
                setTimer()
                startButton.setTitle("Пауза", for: .normal)
                isPaused = false
            } else if isFirstTouch == true && isPaused == false {
                pauseAnimation()
                isPaused = true
                isFirstTouch = false
                startButton.setTitle("Продолжить", for: .normal)
            } else if isFirstTouch == false && isPaused == true {
                resumeAnimation()
                setTimer()
                startButton.setTitle("Пауза", for: .normal)
                isPaused = false
                isFirstTouch = true
            }
        }
    }
    
    private func setTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(timerAction),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            
            headerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            headerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            
            ellipseImageView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 10),
            ellipseImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ellipseImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            ellipseImageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            
            timerLabel.centerXAnchor.constraint(equalTo: ellipseImageView.centerXAnchor),
            timerLabel.centerYAnchor.constraint(equalTo: ellipseImageView.centerYAnchor),
            
            timerView.topAnchor.constraint(equalTo: ellipseImageView.bottomAnchor, constant: 15),
            timerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            timerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            timerView.heightAnchor.constraint(equalToConstant: 200),
            
            startButton.topAnchor.constraint(equalTo: timerView.bottomAnchor, constant: 25),
            startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            startButton.heightAnchor.constraint(equalToConstant: 80),
            
            finishButton.topAnchor.constraint(equalTo: startButton.bottomAnchor, constant: 10),
            finishButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            finishButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            finishButton.heightAnchor.constraint(equalToConstant: 55),
        ])
    }
}

extension TimerViewController: NextSetTimerProtocol {
    func nextSetTimerTapped() {
        if numberOfSets < UserSettings.shared.setInt {
            numberOfSets += 1
            resetTimer()
            timerView.numberOfSetLabel.text = "\(numberOfSets)/\(UserSettings.shared.setInt)"
        } else {
            alertOk(title: "Повторения закончились", message: .none)
        }
    }
    
    func editingTimerTapped() {
        
        customAlert.AlertCustom(viewController: self) {
            [self] sets, minNumber, secNumber in
            
            let timeBool = minNumber + secNumber
            
            if sets != "" && timeBool != 0 {
                guard let numberOfSet = Int(sets) else { return }
                numberOfSets = 0
                timerView.numberOfSetLabel.text = "\(numberOfSets)/\(sets)"
                timerView.numberOfTimerLabel.text = "\(minNumber) мин. \(secNumber) сек."
                timerLabel.text = "\(minNumber.setZeroForSoceounds()):\(secNumber.setZeroForSoceounds())"
                
                durationTimer = minNumber * 60 + secNumber
                
                UserSettings.shared.updateTimer(model: UserSettings.shared.self, sets: numberOfSet, min: minNumber, sec: secNumber)
                resetTimer()
            } else {
                alertOk(title: "Введите повторы и время", message: .none)
            }
        }
    }
}

extension TimerViewController {
    
    private func animationCircylar() {
        
        let center = CGPoint(x: ellipseImageView.frame.width / 2,
                             y: ellipseImageView.frame.height / 2)
        let endAngle = (-CGFloat.pi / 2)
        let startAngle = 2 * CGFloat.pi + endAngle
        
        let circylarPath = UIBezierPath(arcCenter: center,
                                        radius: 135,
                                        startAngle: startAngle,
                                        endAngle: endAngle,
                                        clockwise: false)
        
        shapeLayer.path = circylarPath.cgPath
        shapeLayer.lineWidth = 14
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeEnd = 1
        shapeLayer.lineCap = .round
        shapeLayer.strokeColor = UIColor.systemOrange.cgColor
        ellipseImageView.layer.addSublayer(shapeLayer)
    }
    
    private func basicAnimation(remove: Bool) {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 0
        basicAnimation.speed = 1.0
        basicAnimation.duration = CFTimeInterval(durationTimer)
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = remove
        shapeLayer.add(basicAnimation, forKey: "basicAnimation")
    }
    
    private func pauseAnimation() {
        let pauseTime = shapeLayer.convertTime(CACurrentMediaTime(), from: nil)
        timer.invalidate()
        shapeLayer.speed = 0.0
        shapeLayer.timeOffset = pauseTime
    }
    
    private func resumeAnimation() {
        let pausedTime = shapeLayer.timeOffset
        shapeLayer.speed = 1.0
        shapeLayer.beginTime = 0.0
        let timeSinsePause = shapeLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        shapeLayer.beginTime = timeSinsePause
    }
}
