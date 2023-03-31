import Foundation
import UIKit

final class AnimatorForward: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let originFrame: CGRect
    
    init(originFrame: CGRect) {
        self.originFrame = originFrame
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
              let toVC = transitionContext.viewController(forKey: .to),
              let snapshot = toVC.view.snapshotView(afterScreenUpdates: true)
        else {
            return
        }
        
        let containerView = transitionContext.containerView
        let finalFrame = transitionContext.finalFrame(for: toVC)
        let scale = UIScreen.main.scale
        let yCoordinate = 20.0 * scale
        toVC.view.frame = CGRect(
            x: finalFrame.origin.x,
            y: yCoordinate,
            width: finalFrame.width,
            height: finalFrame.height
        )
        
        snapshot.frame = originFrame
        snapshot.layer.cornerRadius = 16
        snapshot.layer.masksToBounds = true
        
        containerView.addSubview(toVC.view)
        containerView.addSubview(snapshot)
        toVC.view.isHidden = true
        
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animateKeyframes(
            withDuration: duration,
            delay: 0,
            options: .calculationModeCubic,
            animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1.0) {
                    snapshot.frame = CGRect(
                        x: finalFrame.origin.x,
                        y: yCoordinate,
                        width: finalFrame.width,
                        height: finalFrame.height
                    )
                }
            },
            completion: { _ in
                toVC.view.isHidden = false
                snapshot.removeFromSuperview()
                fromVC.view.layer.transform = CATransform3DIdentity
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
    }
}
