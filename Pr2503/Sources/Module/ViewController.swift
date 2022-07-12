
import UIKit

class ViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var buttonColorView: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var buttonStart: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    
    private var isSearchPassword = true
    
    private var isBlack: Bool = false {
        didSet {
            if isBlack {
                changeColorElements(isBlack: isBlack)
            } else {
                changeColorElements(isBlack: isBlack)
            }
        }
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.isSecureTextEntry.toggle()
        activityIndicator.hidesWhenStopped = true
    }
    
    // MARK: - Actions
    
    @IBAction func changeColorView(_ sender: Any) {
        isBlack.toggle()
    }

// Generate password method with queue operation
    
    @IBAction func generateRandomPassword(_ sender: Any) {
        
        if isSearchPassword {
            changingStatesElements(passwordSelectionState: .start)
        } else {
            changingStatesElements(passwordSelectionState: .searching)

            let passwordText = textField.text ?? "Error"
            let character =  passwordText.split(by: Metric.characterCount)
            let queue = OperationQueue()
            var arrayBruteForce: [BruteForcePassword] = []

            for i in character {
                arrayBruteForce.append(BruteForcePassword(password: i))
            }

            for i in arrayBruteForce {
                queue.addOperation(i)
            }

            queue.addBarrierBlock {
                DispatchQueue.main.async {
                    self.changingStatesElements(passwordSelectionState: .finished)
                }
            }
        }
    }
    
    // MARK: - Setup elements

//     This method is used to change appearance when backgroung - isBlack.

    private func changeColorElements(isBlack: Bool) {
        if isBlack {
            view.backgroundColor = .black
            label.textColor = .white
            buttonColorView.backgroundColor = .white
            buttonColorView.tintColor = .black
            buttonStart.backgroundColor = .systemTeal
            buttonStart.tintColor = .black
        } else {
            view.backgroundColor = .white
            label.textColor = .black
            buttonColorView.backgroundColor = .black
            buttonColorView.tintColor = .white
            buttonStart.backgroundColor = .systemTeal
            buttonStart.tintColor = .white
        }
    }
    
    // MARK: - Password selection status
    
//     This method change elements appearance when PasswordSate is changed.
    
    private func changingStatesElements(passwordSelectionState: PasswordState) {
        
        switch passwordSelectionState {
        case .start:
            label.text = "Password has been generated! \n Press Start to show password!"
            textField.text = String.random(length: 10)
            textField.isSecureTextEntry = true
            isSearchPassword = false
            activityIndicator.stopAnimating()
            buttonStart.backgroundColor = .systemTeal
        case .searching:
            label.text = "Here will be your password!"
            textField.isUserInteractionEnabled = false
            buttonStart.isUserInteractionEnabled = false
            buttonStart.setTitle("Password is generating...", for: .normal)
            buttonStart.titleLabel?.textAlignment = .center
            changeColorElements(isBlack: isBlack)
            isSearchPassword = true
            activityIndicator.startAnimating()
        case .finished:
            label.text = "Your password is: \(self.textField.text ?? "Error") \n Press Start to generate new password!"
            textField.isSecureTextEntry = false
            textField.isUserInteractionEnabled = true
            buttonStart.isUserInteractionEnabled = true
            buttonStart.setTitle("Start", for: .normal)
            activityIndicator.stopAnimating()
        }
    }
}

extension ViewController {

    enum Metric {
        static let characterCount = 2
    }
}
