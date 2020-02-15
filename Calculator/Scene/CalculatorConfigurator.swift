//
//  CalculatorConfigurator.swift
//  Calculator
//
//  Created by Anar on 13.02.2020.
//  Copyright © 2020 Commodo. All rights reserved.
//

// MARK: - protocol

protocol CalculatorConfiguratorDelegate {
  func configure(_ calculatorViewController: CalculatorViewDelegate)
  func configure(_ infoViewController: InfoViewDelegate)
  func configure(_ operationsViewController: OperationsViewDelegate)
  func configure(_ calculatorCollectionViewCell: CalculatorCollectionViewCellDelegate)
}

// MARK: - class

final class CalculatorConfigurator: CalculatorConfiguratorDelegate {
  
  // MARK: - properties
  weak var calculatorView : CalculatorViewDelegate!
  let infoView            : InfoViewDelegate!
  let operationsView      : OperationsViewDelegate!
  
  let presenter        : CalculatorPresenterGeneralProtocol
  let interactor       : CalculatorInteractorGeneralProtocol
  let computingFactory : ComputingFactoryDelegate
  
  init(_ calculatorViewController: CalculatorViewDelegate) {
    self.infoView       = InfoViewController(nibName: "InfoView", bundle: nil)
    self.operationsView = OperationsViewController(nibName: "OperationsView", bundle: nil)
    
    self.presenter = CalculatorPresenter(calculatorViewController, self.infoView, self.operationsView)
    
    self.interactor       = CalculatorInteractor()
    self.computingFactory = ComputingFactory(self.presenter)
    
    self.presenter.computingFactory = self.computingFactory
  }
  
  // MARK: - configure
  // Типом параметров являются протокоы специально для защиты от отсутствия инициализации конфигуратора
  func configure(_ calculatorViewController: CalculatorViewDelegate) {
    calculatorViewController.presenter      = self.presenter
    self.presenter.calculatorViewInteractor = self.interactor
    
    calculatorViewController.infoViewController       = self.infoView
    calculatorViewController.operationsViewController = self.operationsView
  }
  
  // MARK: - configure
  func configure(_ infoViewController: InfoViewDelegate) {
    infoViewController.presenter      = self.presenter
    self.presenter.infoViewInteractor = self.interactor
  }
  
  // MARK: - configure
  func configure(_ operationsViewController: OperationsViewDelegate) {
    operationsViewController.presenter      = self.presenter
    self.presenter.operationsViewInteractor = self.interactor
  }
  
  // MARK: - configure
  func configure(_ calculatorCollectionViewCell: CalculatorCollectionViewCellDelegate) {
    self.presenter.currentCell = calculatorCollectionViewCell
    calculatorCollectionViewCell.presenter = self.presenter
  }
}
