//
//  ComputingFactory.swift
//  Calculator
//
//  Created by Anar on 13.02.2020.
//  Copyright © 2020 Commodo. All rights reserved.
//

final class ComputingFactory: ComputingFactoryProtocol {
  weak var presenter : CalculatorPresenterGeneralProtocol!
  
  init(_ presenter: CalculatorPresenterGeneralProtocol) {
    self.presenter = presenter
  }
  
  func compute(firstNumber: Float, secondNumber: Float, operation: Operation) -> Float {
    switch operation {
      case .addition: return firstNumber + secondNumber
      case .subtraction: return firstNumber - secondNumber
      case .multiplication: return firstNumber * secondNumber
      case .division: return firstNumber / secondNumber
    }
  }
  
  func percent(number: Float) -> Float {
    return number / 100
  }
}

enum Operation: String {
  case addition       = "+"
  case subtraction    = "−"
  case multiplication = "×"
  case division       = "÷"
}
