//
//  CalculatorInteractor.swift
//  Calculator
//
//  Created by Anar on 13.02.2020.
//  Copyright © 2020 Commodo. All rights reserved.
//

import UIKit
import CoreData

final class CalculatorInteractor: CalculatorInteractorGeneralProtocol {
  weak var calculatorViewPresenter : CalculatorPresenterProtocol!
  weak var infoViewPresenter       : CalculatorInfoViewPresenterProtocol!
  weak var operationsViewPresenter : CalculatorOperationsViewPresenterProtocol!
  
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
}

// MARK: - CalculatorInteractorProtocol
extension CalculatorInteractor: CalculatorInteractorProtocol {
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
  
  func getAlertInfoText() -> String {
    return "Случаи некорректного ввода не обработаны, будьте бдительны"
  }
}

// MARK: - CalculatorInfoViewInteractorProtocol
extension CalculatorInteractor: CalculatorInfoViewInteractorProtocol {
  func getInfoText() -> String {
    "Это приложение сделано на коленке за пол дня специально для демонстрации моей любимой архитектуры и чтобы я мог показать хоть кому-то ту штуку с протоколами, которую я придумал. По всем вопросам Telegram: @AR_DC"
  }
}

// MARK: - CalculatorOperationsViewInteractorProtocol
extension CalculatorInteractor: CalculatorOperationsViewInteractorProtocol {
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
  }
}
