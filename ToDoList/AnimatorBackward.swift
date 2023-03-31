import Foundation
import UIKit

final class AnimatorBackward: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
              let toVC = transitionContext.viewController(forKey: .to) else { return }
        
        let containerView = transitionContext.containerView
        
        fromVC.beginAppearanceTransition(false, animated: true)
        toVC.beginAppearanceTransition(true, animated: true)
        
        containerView.addSubview(fromVC.view)
        UIView.animate(withDuration: 1, animations: {
            
            fromVC.view.frame.origin.y = UIScreen.main.bounds.maxY
            toVC.view.layer.transform = CATransform3DMakeScale(1, 1, 1)
        }, completion: { _ in
            
            fromVC.endAppearanceTransition()
            toVC.endAppearanceTransition()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
