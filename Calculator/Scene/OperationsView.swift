//
//  OperationsView.swift
//  Calculator
//
//  Created by Anar on 13.02.2020.
//  Copyright © 2020 Commodo. All rights reserved.
//

import UIKit

// MARK: - protocol

protocol OperationsViewDelegate: UIViewController {
  var presenter: CalculatorOperationsViewPresenterDelegate! { get set }
  
  func setOperationsData(data operationsData: [String?])
  
  func makeView()
  func makeCloseButton()
  
  func makeOperationsTableView()
}

// MARK: - class

final class OperationsViewController: UIViewController, OperationsViewDelegate {
  
  // MARK: - properties
  var presenter  : CalculatorOperationsViewPresenterDelegate!
  
  let cellID = "cellID"
  
  var operationsData: [String?] = [nil]
  
  @IBOutlet weak var operationsTableView: UITableView!
  @IBOutlet weak var closeButton: UIButton!
}

// MARK: - Life Cycle

extension OperationsViewController {
  
  // MARK: - viewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    self.presenter.operationsViewDidLoad()
  }
}

// MARK: - Action

extension OperationsViewController {
  
  // MARK: - closeButton
  @IBAction func closeButton(_ sender: UIButton) {
    self.presenter.operationsViewCloseButton()
  }
}

// MARK: - UITableView

extension OperationsViewController {
  
  // MARK: - makeOperationsTableView
  func makeOperationsTableView() {
    self.operationsTableView.delegate   = self
    self.operationsTableView.dataSource = self
    self.operationsTableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellID)
  }
}

// MARK: - Data

extension OperationsViewController {
  
  // MARK: - setOperationsData
  func setOperationsData(data operationsData: [String?]) {
    self.operationsData = operationsData
  }
}

// MARK: - UI Making

extension OperationsViewController {
  
  // MARK: - makeView
  func makeView() {
    self.view.layer.cornerRadius = self.closeButton.frame.height / 2
  }
  
  // MARK: - makeCloseButton
  func makeCloseButton() {
    self.closeButton.layer.cornerRadius = self.closeButton.frame.height / 2
    self.closeButton.backgroundColor    = #colorLiteral(red: 0.714621114, green: 0.1241069765, blue: 0.0462721673, alpha: 1)
    self.closeButton.setTitleColor(.white, for: .normal)
    self.closeButton.setTitle("Close", for: .normal)
    
    self.closeButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
  }
}

// MARK: - UICollectionViewDataSource

extension OperationsViewController: UITableViewDataSource {
  
  // MARK: - numberOfRowsInSection
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    self.operationsData.count
  }
  
  // MARK: - cellForRowAt
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath)
    cell.textLabel?.text = self.operationsData[indexPath.row]
    return cell
  }
}

// MARK: - UITableViewDelegate

extension OperationsViewController: UITableViewDelegate {
  
  // MARK: - heightForRowAt
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    50
  }
}
