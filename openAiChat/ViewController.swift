//
//  ViewController.swift
//  openAiChat
//
//  Created by ethan on 2023/1/31.
//

import UIKit
import ProgressHUD
import Combine

class ViewController: UIViewController {
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerLabel: UITextView!
    @IBOutlet weak var aiButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    private let aiViewModel = AIViewModel()
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    let input: PassthroughSubject<AIViewModel.Input, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
        addNotification()
    }

    private func setupBinding() {
        let output = aiViewModel.transform(input: input.eraseToAnyPublisher())
        
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
            switch event {
            case .didSucceeded(let response):
                self?.view.endEditing(true)
                self?.textField.text = nil
                self?.answerLabel.attributedText = NSAttributedString(attributedString: response)
            case .didFailed(let error):
                print(error)
            case .isLoading(let isLoading):
                self?.questionLabel.text = self?.textField.text ?? ""
                isLoading ? self?.startLoading() : self?.stopLoading()
            }
        }.store(in: &cancellables)
    }
    
    private func addNotification() {
        NotificationCenter.default.addObserver(
             self,
             selector: #selector(self.keyboardWillShow),
             name: UIResponder.keyboardWillShowNotification,
             object: nil)

         NotificationCenter.default.addObserver(
             self,
             selector: #selector(self.keyboardWillHide),
             name: UIResponder.keyboardWillHideNotification,
             object: nil)
    }
    
    @IBAction func aiButtonClicked(_ sender: Any) {
        guard let text = textField.text, !text.isEmpty else { return }
        input.send(.sendRequest(input: text))
        
    }
    @IBAction func clearQuestionButtonClicked(_ sender: Any) {
        questionLabel.text = nil
        answerLabel.text = nil
        aiViewModel.clearQuestions()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}
extension ViewController {
    func startLoading() {
        ProgressHUD.animationType = .lineScaling
        ProgressHUD.show()
        self.view.isUserInteractionEnabled = false
    }

    func stopLoading() {
        ProgressHUD.dismiss()
        self.view.isUserInteractionEnabled = true
        
    }
}


extension ViewController {
    @objc func keyboardWillShow(_ notification: NSNotification) {
        // Move the view only when the usernameTextField or the passwordTextField are being edited
        if textField.isEditing {
            moveViewWithKeyboard(notification: notification, viewBottomConstraint: self.bottomConstraint, keyboardWillShow: true)
        }
    }
        
    @objc func keyboardWillHide(_ notification: NSNotification) {
        moveViewWithKeyboard(notification: notification, viewBottomConstraint: self.bottomConstraint, keyboardWillShow: false)
    }

    func moveViewWithKeyboard(notification: NSNotification, viewBottomConstraint: NSLayoutConstraint, keyboardWillShow: Bool) {
        // Keyboard's size
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let keyboardHeight = keyboardSize.height
        
        // Keyboard's animation duration
        let keyboardDuration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        
        // Keyboard's animation curve
        let keyboardCurve = UIView.AnimationCurve(rawValue: notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! Int)!
        
        // Change the constant
        if keyboardWillShow {
            let safeAreaExists = (self.view?.window?.safeAreaInsets.bottom != 0) // Check if safe area exists
            let bottomConstant: CGFloat = 20
            viewBottomConstraint.constant = keyboardHeight + (safeAreaExists ? 0 : bottomConstant)
        }else {
            viewBottomConstraint.constant = 20
        }
        
        // Animate the view the same way the keyboard animates
        let animator = UIViewPropertyAnimator(duration: keyboardDuration, curve: keyboardCurve) { [weak self] in
            // Update Constraints
            self?.view.layoutIfNeeded()
        }
        
        // Perform the animation
        animator.startAnimation()
    }
    
}
