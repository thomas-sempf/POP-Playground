/*:
 # Example UIView
 
 Some fun with UIViews
 
 Don't forget to show the assistant editor to get a live-preview of the view controller
 */

import UIKit
import PlaygroundSupport

protocol Animation {
    var view: UIView! { get }
    
    func rotate360Degrees(_ duration: CFTimeInterval, repeatCount: Float, reverse: Bool, completionDelegate: Any?)
    func hasPending360DegreesAnimation() -> Bool
    func stop360DegreesAnimation()
}

extension Animation {
    func rotate360Degrees(_ duration: CFTimeInterval = 1.0, repeatCount: Float = 0, reverse: Bool = false, completionDelegate: Any? = nil) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = reverse ? CGFloat(M_PI * 2.0): 0.0
        rotateAnimation.toValue = reverse ? 0.0: CGFloat(M_PI * 2.0)
        rotateAnimation.duration = duration
        rotateAnimation.repeatCount = repeatCount == 0 ? MAXFLOAT : repeatCount
        
        if let delegate = completionDelegate as? CAAnimationDelegate {
            rotateAnimation.delegate = delegate
        }
        
        view.layer.add(rotateAnimation, forKey: "360DegreeAnimation\(type(of: self))")
    }
    
    func hasPending360DegreesAnimation() -> Bool {
        if view.layer.animation(forKey: "360DegreeAnimation\(type(of: self))") != nil {
            return true
        } else {
            return false
        }
    }
    
    func stop360DegreesAnimation() {
        view.layer.removeAnimation(forKey: "360DegreeAnimation\(type(of: self))")
    }
}

//: UIView adaption

extension UIView: Animation {
    var view: UIView! { return self }
}

let containerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 375.0, height: 667.0))
containerView.backgroundColor = .green

let button = UIButton(frame: CGRect(x: containerView.bounds.width/2, y: containerView.bounds.height/2, width: 100, height: 20))
button.backgroundColor = .red
containerView.addSubview(button)


let label = UILabel(frame: CGRect(x: containerView.bounds.width/2, y: containerView.bounds.height/2, width: 100, height: 20))
label.text = "Hello World"
containerView.addSubview(label)

button.rotate360Degrees(1, repeatCount: 100, completionDelegate: nil)
label.rotate360Degrees(5, repeatCount:  100, reverse: true)

//: ViewController adaption

class AnimateViewController: UIViewController, Animation {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let button = UIButton(frame: CGRect(x: containerView.bounds.width/2, y: containerView.bounds.height/2, width: 100, height: 20))
        button.backgroundColor = .red
        view.addSubview(button)
        
        
        let label = UILabel(frame: CGRect(x: containerView.bounds.width/2, y: containerView.bounds.height/2, width: 100, height: 20))
        label.text = "Hello World"
        view.addSubview(label)
    
        button.rotate360Degrees(2, repeatCount: 100, completionDelegate: nil)
        label.rotate360Degrees(5, repeatCount:  100, reverse: true)
    }
}

let myVC = AnimateViewController()

PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundPage.current.liveView = myVC.view//containerView
