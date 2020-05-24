//
//  CalculatorView.swift
//  Calculator
//
//  Created by Anar on 13.02.2020.
//  Copyright © 2020 Commodo. All rights reserved.
//

import UIKit

final class CalculatorViewController: UIViewController, CalculatorViewProtocol {
  var configurator : CalculatorConfiguratorProtocol!
  var presenter    : CalculatorPresenterProtocol!
  
  var infoViewController       : InfoViewProtocol!
  var operationsViewController : OperationsViewProtocol!
  
  let cellID = "cellID"
  
  var blur: CustomIntensityVisualEffectView!
  
  @IBOutlet weak var infoButton               : UIButton!
  @IBOutlet weak var operationsButton         : UIButton!
  @IBOutlet weak var resultLabel              : UILabel!
  @IBOutlet weak var calculatorCollectionView : UICollectionView!
  @IBOutlet weak var alertInfoLabel           : UILabel!
}

// MARK: - Life Cycle
extension CalculatorViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    self.configurator = CalculatorConfigurator(self)
    self.configurator.configure(self)
    self.configurator.configure(self.infoViewController)
    self.configurator.configure(self.operationsViewController)
    self.presenter.viewDidLoad()
  }
}

// MARK: - Actions
extension CalculatorViewController {
  @IBAction func infoButton(_ sender: UIButton) {
    self.presenter.infoButton()
  }
  
  @IBAction func operationsButton(_ sender: UIButton) {
    self.presenter.operationsButton()
  }
}

// MARK: - UI Making
extension CalculatorViewController {
  func makeInfoButton() {
    self.infoButton.layer.cornerRadius = self.infoButton.frame.height / 2
    self.infoButton.backgroundColor    = .blue
    self.infoButton.alpha              = 0.6
    self.infoButton.setTitleColor(.white, for: .normal)
    
    self.infoButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
  }
  
  func makeOperationsButton() {
    self.operationsButton.layer.cornerRadius = self.infoButton.frame.height / 2
    self.operationsButton.backgroundColor    = .red
    self.operationsButton.alpha              = 0.6
    self.operationsButton.setTitleColor(.white, for: .normal)
    
    self.operationsButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
  }
  
  func makeResultLabel() {
    self.resultLabel.textAlignment     = .right
    self.resultLabel.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor
    self.resultLabel.layer.borderWidth = 1
    self.resultLabel.font              = UIFont(name: "Futura-Medium", size : 30)
    self.resultLabel.text              = ""
  }
  
  func makeBlur() {
    let blurEffect = UIBlurEffect(style: .dark)
    let blur       = CustomIntensityVisualEffectView(effect: blurEffect, intensity: 0.2)
    blur.translatesAutoresizingMaskIntoConstraints = false
    blur.frame = self.view.frame
    
    self.view.addSubview(blur)
    
    self.blur = blur
  }
  
  func makeInfoView() {
    self.addChild(self.infoViewController)
    self.view.addSubview(self.infoViewController.view)
    
    self.infoViewController.view.frame = CGRect(x: self.view.center.x - 150,
                                                y: self.view.center.y - 125,
                                                width: 300,
                                                height: 250)
  }
  
  func makeOperationsView() {
    self.addChild(self.operationsViewController)
    self.view.addSubview(self.operationsViewController.view)
    
    self.operationsViewController.view.frame = CGRect(x: self.view.center.x - 150,
                                                      y: self.view.center.y - 200,
                                                      width: 300,
                                                      height: 400)
  }
  
  func makeAlertInfoLabel(data text: String) {
    self.alertInfoLabel.text          = text
    self.alertInfoLabel.numberOfLines = 0
    self.alertInfoLabel.textAlignment = .center
    self.alertInfoLabel.widthAnchor.constraint(equalToConstant: self.view.frame.width * 0.8).isActive = true
  }
  
  func makeResultLabel(string: String) {
    self.resultLabel.text! += string
  }
  
  func clearResultLabel() {
    self.resultLabel.text = ""
  }
}

// MARK: - UICollectionView
extension CalculatorViewController {
  func makeCalculatorCollectionView() {
    self.calculatorCollectionView.register(CalculatorCollectionViewCell.self, forCellWithReuseIdentifier: self.cellID)
    
    self.calculatorCollectionView.delegate   = self
    self.calculatorCollectionView.dataSource = self
    
    self.calculatorCollectionView.isScrollEnabled = false
    
    self.calculatorCollectionView.layer.backgroundColor = UIColor.clear.cgColor
    
    let layout = UICollectionViewFlowLayout()
    
    layout.sectionInset            = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    layout.minimumLineSpacing      = 0
    layout.minimumInteritemSpacing = 0
    
    self.calculatorCollectionView.collectionViewLayout = layout
  }
}

// MARK: - UICollectionViewDataSource
extension CalculatorViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { 18 }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellID, for: indexPath) as! CalculatorCollectionViewCellProtocol & UICollectionViewCell
    self.configurator.configure(cell)
    cell.currentCellIndex = indexPath.row
    
    cell.cellViewDidLoad()
    return cell
  }
}

// MARK: - UICollectionViewDelegate
extension CalculatorViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    self.presenter.didSelectItemAt(rowIndex: indexPath.row)
  }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CalculatorViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width  = collectionView.frame.width / 5 - 0.01
    let height = collectionView.frame.height / 4 - 0.01
    
    switch indexPath.row {
      case 15: return CGSize(width: width * 3, height: height)
      default: return CGSize(width: width, height: height)
    }
  }
}

// MARK: - CustomIntensityVisualEffectView
final class CustomIntensityVisualEffectView: UIVisualEffectView {
  /**
   * Создание вида визуального эффекта с заданным эффектом и его интенсивностью
   *
   * - Параметры:
   *   - effect: визуальный эффект, например: UIBlurEffect(style: .dark)
   *   - intensity: пользовательская интенсивность
   *                от 0.0 (без эффекта) до 1.0 (полный эффект)
   *                с использованием линейной шкалы
   */
  init(effect: UIVisualEffect, intensity: CGFloat) {
    super.init(effect: nil)
    animator = UIViewPropertyAnimator(duration: 1, curve: .linear) { [unowned self] in self.effect = effect }
    animator.fractionComplete = intensity
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError()
  }
  
  // MARK: Private
  private var animator: UIViewPropertyAnimator!
}
