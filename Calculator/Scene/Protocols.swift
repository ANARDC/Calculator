//
//  Protocols.swift
//  Calculator
//
//  Created by Anar on 24.05.2020.
//  Copyright © 2020 Commodo. All rights reserved.
//

import UIKit

// MARK: Calculator View

protocol CalculatorViewProtocol: class {
  var presenter                : CalculatorPresenterProtocol! { get set }
  var infoViewController       : InfoViewProtocol! { get set }
  var operationsViewController : OperationsViewProtocol! { get set }
  
  var blur: CustomIntensityVisualEffectView! { get set }
  
  func makeInfoButton()
  func makeOperationsButton()
  func makeResultLabel()
  func makeBlur()
  func makeInfoView()
  func makeOperationsView()
  func makeAlertInfoLabel(data text: String)
  func makeResultLabel(string: String)
  func clearResultLabel()
  
  func makeCalculatorCollectionView()
}

// MARK: Info View

protocol InfoViewProtocol: UIViewController {
  var presenter: CalculatorInfoViewPresenterProtocol! { get set }
  
  func makeView()
  func makeTextView(data text: String)
  func makeCloseButton()
}

// MARK: Operations View

protocol OperationsViewProtocol: UIViewController {
  var presenter: CalculatorOperationsViewPresenterProtocol! { get set }
  
  func setOperationsData(data operationsData: [String?])
  
  func makeView()
  func makeCloseButton()
  
  func makeOperationsTableView()
}

protocol CalculatorCollectionViewCellProtocol: class {
  var presenter: CalculatorCollectionViewCellPresenterProtocol! { get set }
  
  var currentCellIndex: Int! { get set }
  
  func cellViewDidLoad()
  
  func makeCell()
  func makeCellLabel()
}

// MARK: Presenter

protocol CalculatorPresenterGeneralProtocol: CalculatorPresenterProtocol, CalculatorInfoViewPresenterProtocol, CalculatorOperationsViewPresenterProtocol, CalculatorCollectionViewCellPresenterProtocol {}

protocol CalculatorPresenterProtocol: class {
  var calculatorViewInteractor : CalculatorInteractorProtocol! { get set }
  var computingFactory         : ComputingFactoryProtocol! { get set }
  
  func viewDidLoad()
  
  func didSelectItemAt(rowIndex: Int)
  func infoButton()
  func operationsButton()
}

protocol CalculatorInfoViewPresenterProtocol: class {
  var infoViewInteractor: CalculatorInfoViewInteractorProtocol! { get set }
  func infoViewDidLoad()
  
  func infoViewCloseButton()
}

protocol CalculatorOperationsViewPresenterProtocol: class {
  var operationsViewInteractor: CalculatorOperationsViewInteractorProtocol! { get set }
  func operationsViewDidLoad()
  
  func operationsViewCloseButton()
}

protocol CalculatorCollectionViewCellPresenterProtocol: class {
  var currentCell: CalculatorCollectionViewCellProtocol! { get set }
  
  func cellViewDidLoad()
}

// MARK: Interactor

protocol CalculatorInteractorGeneralProtocol: CalculatorInteractorProtocol, CalculatorInfoViewInteractorProtocol, CalculatorOperationsViewInteractorProtocol {}

protocol CalculatorInteractorProtocol {
  var calculatorViewPresenter: CalculatorPresenterProtocol! { get set }
  
  func saveOperationData(data operationData: String)
  func getAlertInfoText() -> String
}

protocol CalculatorInfoViewInteractorProtocol {
  var infoViewPresenter: CalculatorInfoViewPresenterProtocol! { get set }
  
  func getInfoText() -> String
}

protocol CalculatorOperationsViewInteractorProtocol {
  var operationsViewPresenter: CalculatorOperationsViewPresenterProtocol! { get set }
  
  func getOperationsData() -> [String?]
}

// MARK: Computing Factory

protocol ComputingFactoryProtocol {
  var presenter : CalculatorPresenterGeneralProtocol! { get set }
  
  func compute(firstNumber: Float, secondNumber: Float, operation: Operation) -> Float
  func percent(number: Float) -> Float
}

// MARK: Configurator

protocol CalculatorConfiguratorProtocol {
  func configure(_ calculatorViewController: CalculatorViewProtocol)
  func configure(_ infoViewController: InfoViewProtocol)
  func configure(_ operationsViewController: OperationsViewProtocol)
  func configure(_ calculatorCollectionViewCell: CalculatorCollectionViewCellProtocol)
}
