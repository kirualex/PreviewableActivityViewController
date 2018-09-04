
//
//  PreviewableActivityViewController.swift
//  Ride
//
//  Created by Kane Cheshire on 20/09/2017.
//  Copyright © 2017 Kane Cheshire. All rights reserved.
//

import UIKit

/// A `UIActivityViewController` that provides the ability to show a preview
/// of the image being shared.
///
/// The preview is shown on top of the dimmed out window that the system displays
/// when `UIActivityViewController` is presented.
open class PreviewableActivityViewController: UIActivityViewController {
    
    // MARK: - Properties -
    // MARK: Public
    
    /// The duration of the simple fade-in animation when showing the preview view.
    /// Defaults to 0.2 seconds.
    open var animationDuration: TimeInterval = 0.2

    /// The size of the margin, in points, between the preview view and the
    /// top of the activity view controller's main view.
    open var previewImageViewMargin: CGFloat = 8
    
    /// Holder blur style
    open var holderViewEffectStyle: UIBlurEffectStyle = .extraLight
    
    /// Set the `previewImageView`s image to be your preview before
    /// presenting the view controller to the user.
    /// By default, the controller will assign the first image passed in
    /// during initialisation, if any.
    
    lazy var holderView: UIVisualEffectView = {
        let holderView = UIVisualEffectView()
        holderView.effect = UIBlurEffect(style: self.holderViewEffectStyle)
        holderView.clipsToBounds = true
        holderView.layer.cornerRadius = 12
        holderView.alpha = 0
        holderView.translatesAutoresizingMaskIntoConstraints = false
        return holderView
    }()
    
    lazy var previewImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Overrides -
    
    public override init(activityItems: [Any], applicationActivities: [UIActivity]? = nil) {
        super.init(activityItems: activityItems, applicationActivities: applicationActivities)
        let images: [UIImage] = activityItems.compactMap { return $0 as? UIImage }
        previewImageView.image = images.first
    }
    
    // MARK: Functions
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        view.window?.addSubview(holderView)
        holderView.contentView.addSubview(previewImageView)
        addConstraints()
        UIView.animate(withDuration: animationDuration) {
            self.holderView.alpha = 1
        }
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       self.holderView.removeFromSuperview()
    }
    
    func addConstraints() {
        guard #available(iOS 11.0, *) else {
            return
        }
        NSLayoutConstraint.activate([
            holderView.leftAnchor.constraint(equalTo: view.leftAnchor),
            holderView.rightAnchor.constraint(equalTo: view.rightAnchor),
            holderView.bottomAnchor.constraint(equalTo: view.topAnchor,
                                               constant: -8),
            holderView.topAnchor.constraint(equalTo: view.window!.safeAreaLayoutGuide.topAnchor,
                                            constant: 8),
            previewImageView.leftAnchor.constraint(equalTo: holderView.leftAnchor,
                                                   constant: previewImageViewMargin),
            previewImageView.rightAnchor.constraint(equalTo: holderView.rightAnchor,
                                                    constant: -previewImageViewMargin),
            previewImageView.bottomAnchor.constraint(equalTo: holderView.bottomAnchor,
                                                     constant: -previewImageViewMargin),
            previewImageView.topAnchor.constraint(equalTo: holderView.topAnchor,
                                                  constant: previewImageViewMargin)
            ])
    }
}
