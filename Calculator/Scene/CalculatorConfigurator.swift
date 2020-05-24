//
//  CalculatorConfigurator.swift
//  Calculator
//
//  Created by Anar on 13.02.2020.
//  Copyright © 2020 Commodo. All rights reserved.
//

final class CalculatorConfigurator: CalculatorConfiguratorProtocol {
  weak var calculatorView : CalculatorViewProtocol!
  let infoView            : InfoViewProtocol!
  let operationsView      : OperationsViewProtocol!
  
  let presenter        : CalculatorPresenterGeneralProtocol
  let interactor       : CalculatorInteractorGeneralProtocol
  let computingFactory : ComputingFactoryProtocol
  
  init(_ calculatorViewController: CalculatorViewProtocol) {
    self.infoView       = InfoViewController(nibName: "InfoView", bundle: nil)
    self.operationsView = OperationsViewController(nibName: "OperationsView", bundle: nil)
    
    self.presenter = CalculatorPresenter(calculatorViewController, self.infoView, self.operationsView)
    
    self.interactor       = CalculatorInteractor()
    self.computingFactory = ComputingFactory(self.presenter)
    
    self.presenter.computingFactory = self.computingFactory
  }
  
  // Типом параметров являются протокоы специально для защиты от отсутствия инициализации конфигуратора
  func configure(_ calculatorViewController: CalculatorViewProtocol) {
    calculatorViewController.presenter      = self.presenter
    self.presenter.calculatorViewInteractor = self.interactor
    
    calculatorViewController.infoViewController       = self.infoView
    calculatorViewController.operationsViewController = self.operationsView
  }
  
  func configure(_ infoViewController: InfoViewProtocol) {
    infoViewController.presenter      = self.presenter
    self.presenter.infoViewInteractor = self.interactor
  }
  
  func configure(_ operationsViewController: OperationsViewProtocol) {
    operationsViewController.presenter      = self.presenter
    self.presenter.operationsViewInteractor = self.interactor
  }
  
  func configure(_ calculatorCollectionViewCell: CalculatorCollectionViewCellProtocol) {
    self.presenter.currentCell = calculatorCollectionViewCell
    calculatorCollectionViewCell.presenter = self.presenter
  }
}
