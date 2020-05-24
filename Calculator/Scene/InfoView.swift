//
//  InfoView.swift
//  Calculator
//
//  Created by Anar on 13.02.2020.
//  Copyright © 2020 Commodo. All rights reserved.
//

import UIKit

final class InfoViewController: UIViewController, InfoViewProtocol {
  var presenter: CalculatorInfoViewPresenterProtocol!
  
  @IBOutlet weak var closeButton : UIButton!
  @IBOutlet weak var textView    : UITextView!
}

// MARK: - Life Cycle
extension InfoViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    self.presenter.infoViewDidLoad()
  }
}

// MARK: - UI Making
extension InfoViewController {
  func makeView() {
    self.view.layer.cornerRadius = self.closeButton.frame.height / 2
  }
  
  func makeTextView(data text: String) {
    self.textView.text       = text
    self.textView.isEditable = false
  }
  
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
  @IBAction func closeButton(_ sender: UIButton) {
    self.presenter.infoViewCloseButton()
  }
}
