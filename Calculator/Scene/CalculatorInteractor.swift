//
//  CalculatorInteractor.swift
//  Calculator
//
//  Created by Anar on 13.02.2020.
//  Copyright © 2020 Commodo. All rights reserved.
//

import UIKit
import CoreData

// MARK: - protocols

protocol CalculatorInteractorGeneralProtocol: CalculatorInteractorDelegate, CalculatorInfoViewInteractorDelegate, CalculatorOperationsViewInteractorDelegate {
  // Тут мы можем создавать общие для всех интеракторов свойства и методы
}

protocol CalculatorInteractorDelegate {
  var calculatorViewPresenter: CalculatorPresenterDelegate! { get set }
  
  func saveOperationData(data operationData: String)
  func getAlertInfoText() -> String
}

protocol CalculatorInfoViewInteractorDelegate {
  var infoViewPresenter: CalculatorInfoViewPresenterDelegate! { get set }
  
  func getInfoText() -> String
}

protocol CalculatorOperationsViewInteractorDelegate {
  var operationsViewPresenter: CalculatorOperationsViewPresenterDelegate! { get set }
  
  func getOperationsData() -> [String?]
}

// MARK: - class

final class CalculatorInteractor: CalculatorInteractorGeneralProtocol {
  
  // MARK: - properties
  weak var calculatorViewPresenter : CalculatorPresenterDelegate!
  weak var infoViewPresenter       : CalculatorInfoViewPresenterDelegate!
  weak var operationsViewPresenter : CalculatorOperationsViewPresenterDelegate!

  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
}

// MARK: - CalculatorInteractorDelegate

extension CalculatorInteractor: CalculatorInteractorDelegate {
  
  // MARK: - saveOperationData
  func saveOperationData(data operationData: String) {
    // Получаем необходимые свойства
    let entity        = NSEntityDescription.entity(forEntityName: "OperationData", in: self.context)
    let storageObject = NSManagedObject(entity: entity!, insertInto: context) as! OperationData
    
    // Присваивание значений свойствам объекта
    storageObject.operation = operationData
    
    // Сохранение контекста
    do {
      try self.context.save()
    } catch {
      print(error.localizedDescription)
    }
  }
  
  // MARK: - getAlertInfoText
  func getAlertInfoText() -> String {
    return "Случаи некорректного ввода не обработаны, будьте бдительны"
  }
}

// MARK: - CalculatorInteractorDelegate

extension CalculatorInteractor: CalculatorInfoViewInteractorDelegate {
  
  // MARK: - getInfoText
  func getInfoText() -> String {
    "Это приложение сделано на коленке за пол дня специально для демонстрации моей любимой архитектуры и чтобы я мог показать хоть кому-то ту штуку с протоколами, которую я придумал. По всем вопросам Telegram: @AR_DC"
  }
}

// MARK: - CalculatorOperationsViewInteractorDelegate

extension CalculatorInteractor: CalculatorOperationsViewInteractorDelegate {
  
  // MARK: - getOperationsData
  func getOperationsData() -> [String?] {
    
    var operationsData = [String?]()
    
    let fetchRequest: NSFetchRequest<OperationData> = OperationData.fetchRequest()
    
    do {
      let data = try self.context.fetch(fetchRequest)
      data.forEach { (session) in
        operationsData.append(session.operation)
      }
    } catch {
      print(error.localizedDescription)
    }
    
    return operationsData
    
//    return ["1+2=3", "2*6=12", "3,4*5,2=17,68", "30/7=4,28"]
  }
}
