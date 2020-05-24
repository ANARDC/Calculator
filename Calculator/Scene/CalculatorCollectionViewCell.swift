//
//  CalculatorCollectionViewCell.swift
//  Calculator
//
//  Created by Anar on 14.02.2020.
//  Copyright © 2020 Commodo. All rights reserved.
//

import UIKit

final class CalculatorCollectionViewCell: UICollectionViewCell, CalculatorCollectionViewCellProtocol {
  var presenter: CalculatorCollectionViewCellPresenterProtocol!
  
  var currentCellIndex: Int!
}

// MARK: - Life Cycle
extension CalculatorCollectionViewCell {
  func cellViewDidLoad() {
    self.presenter.cellViewDidLoad()
  }
}

// MARK: - UI Making
extension CalculatorCollectionViewCell {
  func makeCell() {
    switch self.currentCellIndex! {
      // Числа
      case 0...2, 5...7, 10...12, 15: self.backgroundColor = .gray
      // Удаление
      case 4: self.backgroundColor = .red
      // Операции
      default: self.backgroundColor = .black
    }
  }
  
  func makeCellLabel() {
    let numberLabel = UILabel()
    numberLabel.textColor = .white
    numberLabel.font = UIFont(name: "Futura-Medium", size: 30)
    
    // FIXME: сделай нормально с помощью enum
    switch self.currentCellIndex! {
      case 0:  numberLabel.text = "1"
      case 1:  numberLabel.text = "2"
      case 2:  numberLabel.text = "3"
      case 3:  numberLabel.text = "÷"
      case 4:  numberLabel.text = "С"
      case 5:  numberLabel.text = "4"
      case 6:  numberLabel.text = "5"
      case 7:  numberLabel.text = "6"
      case 8:  numberLabel.text = "×"
      case 9:  numberLabel.text = "."
      case 10: numberLabel.text = "7"
      case 11: numberLabel.text = "8"
      case 12: numberLabel.text = "9"
      case 13: numberLabel.text = "+"
      case 14: numberLabel.text = "%"
      case 15: numberLabel.text = "0"
      case 16: numberLabel.text = "−"
      case 17: numberLabel.text = "="
      default: break
    }
    
    self.addSubview(numberLabel)
    
    numberLabel.translatesAutoresizingMaskIntoConstraints = false
    
    numberLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    numberLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
  }
}
