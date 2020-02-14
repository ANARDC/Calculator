//
//  InfoView.swift
//  Calculator
//
//  Created by Anar on 13.02.2020.
//  Copyright © 2020 Commodo. All rights reserved.
//

import UIKit

// MARK: - protocol

protocol InfoViewDelegate: UIViewController {
  var presenter: CalculatorInfoViewPresenterDelegate! { get set }
  
  func makeView()
  func makeTextView(data text: String)
  func makeCloseButton()
}

// MARK: - class

final class InfoViewController: UIViewController, InfoViewDelegate {
  
  // MARK: - properties
  var presenter: CalculatorInfoViewPresenterDelegate!
  
  @IBOutlet weak var closeButton : UIButton!
  @IBOutlet weak var textView    : UITextView!
}

// MARK: - Life Cycle

extension InfoViewController {
  
  // MARK: - viewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    self.presenter.infoViewDidLoad()
  }
}

// MARK: - UI Making

extension InfoViewController {
  
  // MARK: - makeView
  func makeView() {
    self.view.layer.cornerRadius = self.closeButton.frame.height / 2
  }
  
  // MARK: - makeTextView
  func makeTextView(data text: String) {
    self.textView.text       = text
    self.textView.isEditable = false
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

// MARK: - Action

extension InfoViewController {
  
  // MARK: - closeButton
  @IBAction func closeButton(_ sender: UIButton) {
    self.presenter.infoViewCloseButton()
  }
}
