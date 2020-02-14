//
//  CalculatorPresenter.swift
//  Calculator
//
//  Created by Anar on 13.02.2020.
//  Copyright © 2020 Commodo. All rights reserved.
//

// MARK: - protocols

protocol CalculatorPresenterGeneralProtocol: CalculatorPresenterDelegate, CalculatorInfoViewPresenterDelegate, CalculatorOperationsViewPresenterDelegate, CalculatorCollectionViewCellPresenterDelegate {
  // Тут мы можем создавать общие для всех презентеров свойства и методы
  var calculatorViewInteractor : CalculatorInteractorDelegate! { get set }
  var infoViewInteractor       : CalculatorInfoViewInteractorDelegate! { get set }
  var operationsViewInteractor : CalculatorOperationsViewInteractorDelegate! { get set }
}

protocol CalculatorPresenterDelegate: class {
  var computingFactory : ComputingFactoryDelegate! { get set }
  
  func viewDidLoad()
  
  func infoButton()
  func operationsButton()
}

protocol CalculatorInfoViewPresenterDelegate: class {
  func infoViewDidLoad()
  
  func infoViewCloseButton()
}

protocol CalculatorOperationsViewPresenterDelegate: class {
  func operationsViewDidLoad()
  
  func operationsViewCloseButton()
}

protocol CalculatorCollectionViewCellPresenterDelegate: class {
  var currentCell: CalculatorCollectionViewCellDelegate! { get set }
  
  func cellViewDidLoad()
}

// MARK: - class

final class CalculatorPresenter: CalculatorPresenterGeneralProtocol {
  
  // MARK: - properties
  weak var calculatorView : CalculatorViewDelegate!
  weak var infoView       : InfoViewDelegate!
  weak var operationsView : OperationsViewDelegate!
  weak var currentCell    : CalculatorCollectionViewCellDelegate!
  
  var computingFactory         : ComputingFactoryDelegate!
  var calculatorViewInteractor : CalculatorInteractorDelegate!
  var infoViewInteractor       : CalculatorInfoViewInteractorDelegate!
  var operationsViewInteractor : CalculatorOperationsViewInteractorDelegate!
  
  init(_ calculatorView: CalculatorViewDelegate, _ infoView: InfoViewDelegate, _ operationsView: OperationsViewDelegate) {
    self.calculatorView = calculatorView
    self.infoView       = infoView
    self.operationsView = operationsView
  }
}

// MARK: - CalculatorPresenterDelegate

extension CalculatorPresenter: CalculatorPresenterDelegate {
  
  // MARK: - Life Cycle
  func viewDidLoad() {
    self.calculatorView.makeInfoButton()
    self.calculatorView.makeOperationsButton()
    self.calculatorView.makeResultLabel()
    self.calculatorView.makeCalculatorCollectionView()
  }
  
  // MARK: - Actions
  func infoButton() {
    self.calculatorView.makeBlur()
    self.calculatorView.makeInfoView()
  }
  
  func operationsButton() {
    self.calculatorView.makeBlur()
    self.calculatorView.makeOperationsView()
  }
}

// MARK: - CalculatorInfoViewPresenterDelegate

extension CalculatorPresenter: CalculatorInfoViewPresenterDelegate {
  
  // MARK: - Life Cycle
  func infoViewDidLoad() {
    self.infoView.makeView()
    self.infoView.makeTextView(data: self.infoViewInteractor.getInfoText())
    self.infoView.makeCloseButton()
  }
  
  // MARK: - Action
  func infoViewCloseButton() {
    self.infoView.view.removeFromSuperview()
    self.infoView.removeFromParent()
    self.calculatorView.blur.removeFromSuperview()
  }
}

// MARK: - CalculatorOperationsViewPresenterDelegate

extension CalculatorPresenter: CalculatorOperationsViewPresenterDelegate {
  
  // MARK: - Life Cycle
  func operationsViewDidLoad() {
    self.operationsView.setOperationsData(data: self.operationsViewInteractor.getOperationsData())
    self.operationsView.makeOperationsTableView()
    self.operationsView.makeView()
    self.operationsView.makeCloseButton()
  }
  
  // MARK: - Action
  func operationsViewCloseButton() {
    self.operationsView.view.removeFromSuperview()
    self.operationsView.removeFromParent()
    self.calculatorView.blur.removeFromSuperview()
  }
}

// MARK: - CalculatorCollectionViewCellPresenterDelegate

extension CalculatorPresenter: CalculatorCollectionViewCellPresenterDelegate {
  func cellViewDidLoad() {
    self.currentCell.makeCell()
    self.currentCell.makeCellLabel()
  }
}
