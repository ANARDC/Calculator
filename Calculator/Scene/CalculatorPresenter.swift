//
//  CalculatorPresenter.swift
//  Calculator
//
//  Created by Anar on 13.02.2020.
//  Copyright © 2020 Commodo. All rights reserved.
//

import Foundation

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
  
  func didSelectItemAt(rowIndex: Int)
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
  
  var currentOperation: String? = String()
  
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
    self.calculatorView.makeAlertInfoLabel(data: self.calculatorViewInteractor.getAlertInfoText())
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
  
  func didSelectItemAt(rowIndex: Int) {
    var input = String()
    
    switch rowIndex {
    case 0:  input = "1"
    case 1:  input = "2"
    case 2:  input = "3"
    case 3:  input = "÷"
    case 4:  input = "С"
    case 5:  input = "4"
    case 6:  input = "5"
    case 7:  input = "6"
    case 8:  input = "×"
    case 9:  input = "."
    case 10: input = "7"
    case 11: input = "8"
    case 12: input = "9"
    case 13: input = "+"
    case 14: input = "%"
    case 15: input = "0"
    case 16: input = "−"
    case 17: input = "="
    default: break
    }
    
    if input == "=" {
      let operation = self.currentOperation?.filter({ ["+", "−", "×", "÷"].contains($0) })
      let numbers   = self.currentOperation?.components(separatedBy: ["+", "−", "×", "÷"])
      let result    = self.computingFactory?.compute(firstNumber: (numbers![0] as NSString).floatValue,
                                                    secondNumber: (numbers![1] as NSString).floatValue,
                                                    operation: Operation(rawValue: operation!)!)
      self.currentOperation? += " = \(String(result!))"
      
      self.calculatorView.makeResultLabel(string: " = \(String(result!))")
      self.calculatorViewInteractor.saveOperationData(data: self.currentOperation!)
      self.currentOperation = ""
    } else if input == "С" {
      self.calculatorView.clearResultLabel()
    } else if input == "%" {
      let result = self.computingFactory?.percent(number: (self.currentOperation! as NSString).floatValue)
      
      self.calculatorView.makeResultLabel(string: "% = \(String(result!))")
      self.currentOperation? += "% = \(String(result!))"
      
      self.calculatorViewInteractor.saveOperationData(data: self.currentOperation!)
    } else {
      self.calculatorView.makeResultLabel(string: input)
      self.currentOperation? += input
    }
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
