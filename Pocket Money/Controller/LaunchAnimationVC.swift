//
//  LaunchAnimationVC.swift
//  Pocket Money
//
//  Created by Danit on 23/08/2022.
//

import UIKit


class LaunchAnimationVC: UIViewController {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        imageView.image = UIImage(named: "Logo")
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.center = view.center
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.animate()
        })
    }
    
    private func animate(){
        UIView.animate(withDuration: 1, animations: {
            let size = self.view.frame.size.width * 2
            let diffx = size - self.view.frame.width
            let diffy = self.view.frame.height - size
            
            self.imageView.frame = CGRect(
                x: -(diffx/2),
                y: diffy/2,
                width: size,
                height: size
            )
        })
        
        UIView.animate(withDuration: 1.5, animations: {
        self.imageView.alpha = 0
        })
            
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
//            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//            let mainVC = storyBoard.instantiateViewController(withIdentifier: "MainVC") as! MainVC
//            self.present(mainVC, animated:true, completion:nil)
            
            self.performSegue(withIdentifier: "goToStart", sender: self)
        })
        
        
    }
}

