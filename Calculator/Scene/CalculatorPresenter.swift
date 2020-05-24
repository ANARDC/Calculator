//
//  CalculatorPresenter.swift
//  Calculator
//
//  Created by Anar on 13.02.2020.
//  Copyright © 2020 Commodo. All rights reserved.
//

import Foundation

final class CalculatorPresenter: CalculatorPresenterGeneralProtocol {
  weak var calculatorView : CalculatorViewProtocol!
  weak var infoView       : InfoViewProtocol!
  weak var operationsView : OperationsViewProtocol!
  weak var currentCell    : CalculatorCollectionViewCellProtocol!
  
  var computingFactory         : ComputingFactoryProtocol!
  var calculatorViewInteractor : CalculatorInteractorProtocol!
  var infoViewInteractor       : CalculatorInfoViewInteractorProtocol!
  var operationsViewInteractor : CalculatorOperationsViewInteractorProtocol!
  
  var currentOperation: String? = String()
  
  init(_ calculatorView: CalculatorViewProtocol, _ infoView: InfoViewProtocol, _ operationsView: OperationsViewProtocol) {
    self.calculatorView = calculatorView
    self.infoView       = infoView
    self.operationsView = operationsView
  }
}

// MARK: - CalculatorPresenterProtocol
extension CalculatorPresenter: CalculatorPresenterProtocol {
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

// MARK: - CalculatorInfoViewPresenterProtocol
extension CalculatorPresenter: CalculatorInfoViewPresenterProtocol {
  func infoViewDidLoad() {
    self.infoView.makeView()
    self.infoView.makeTextView(data: self.infoViewInteractor.getInfoText())
    self.infoView.makeCloseButton()
  }
  
  func infoViewCloseButton() {
    self.infoView.view.removeFromSuperview()
    self.infoView.removeFromParent()
    self.calculatorView.blur.removeFromSuperview()
  }
}

// MARK: - CalculatorOperationsViewPresenterProtocol
extension CalculatorPresenter: CalculatorOperationsViewPresenterProtocol {
  func operationsViewDidLoad() {
    self.operationsView.setOperationsData(data: self.operationsViewInteractor.getOperationsData())
    self.operationsView.makeOperationsTableView()
    self.operationsView.makeView()
    self.operationsView.makeCloseButton()
  }
  
  func operationsViewCloseButton() {
    self.operationsView.view.removeFromSuperview()
    self.operationsView.removeFromParent()
    self.calculatorView.blur.removeFromSuperview()
  }
}

// MARK: - CalculatorCollectionViewCellPresenterProtocol
extension CalculatorPresenter: CalculatorCollectionViewCellPresenterProtocol {
  func cellViewDidLoad() {
    self.currentCell.makeCell()
    self.currentCell.makeCellLabel()
  }
}
