//
//  ComputingFactory.swift
//  Calculator
//
//  Created by Anar on 13.02.2020.
//  Copyright © 2020 Commodo. All rights reserved.
//

// MARK: - protocol

protocol ComputingFactoryDelegate {
  var presenter : CalculatorPresenterGeneralProtocol! { get set }
}

// MARK: - class

final class ComputingFactory: ComputingFactoryDelegate {
  
  // MARK: - properties
  weak var presenter : CalculatorPresenterGeneralProtocol!
  
  init(_ presenter: CalculatorPresenterGeneralProtocol) {
    self.presenter = presenter
  }
}
