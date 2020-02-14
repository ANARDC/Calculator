//
//  CalculatorInteractor.swift
//  Calculator
//
//  Created by Anar on 13.02.2020.
//  Copyright © 2020 Commodo. All rights reserved.
//

import CoreData

// MARK: - protocols

protocol CalculatorInteractorGeneralProtocol: CalculatorInteractorDelegate, CalculatorInfoViewInteractorDelegate, CalculatorOperationsViewInteractorDelegate {
  // Тут мы можем создавать общие для всех интеракторов свойства и методы
}

protocol CalculatorInteractorDelegate {
  var calculatorViewPresenter: CalculatorPresenterDelegate! { get set }
  
  // Тут можем обрабатывать данные для презентера основного экрана
}

protocol CalculatorInfoViewInteractorDelegate {
  var infoViewPresenter: CalculatorInfoViewPresenterDelegate! { get set }
  
  func getInfoText() -> String
}

protocol CalculatorOperationsViewInteractorDelegate {
  var operationsViewPresenter: CalculatorOperationsViewPresenterDelegate! { get set }
  
  func getOperationsData() -> [String]
}

// MARK: - class

final class CalculatorInteractor: CalculatorInteractorGeneralProtocol {
  
  // MARK: - properties
  weak var calculatorViewPresenter : CalculatorPresenterDelegate!
  weak var infoViewPresenter       : CalculatorInfoViewPresenterDelegate!
  weak var operationsViewPresenter : CalculatorOperationsViewPresenterDelegate!
}

// MARK: - CalculatorInteractorDelegate

extension CalculatorInteractor: CalculatorInteractorDelegate {
  
}

// MARK: - CalculatorInteractorDelegate

extension CalculatorInteractor: CalculatorInfoViewInteractorDelegate {
  
  func getInfoText() -> String {
    "Это приложение сделано на коленке за пол дня специально для демонстрации моей любимой архитектуры и чтобы я мог показать хоть кому-то ту штуку с протоколами, которую я придумал. По всем вопросам Telegram: @AR_DC"
  }
}

// MARK: - CalculatorOperationsViewInteractorDelegate

extension CalculatorInteractor: CalculatorOperationsViewInteractorDelegate {
  
  func getOperationsData() -> [String] {
    // FIXME: Работа с CoreData
    return ["1+2=3", "2*6=12", "3,4*5,2=17,68", "30/7=4,28"]
  }
}
