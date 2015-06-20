//
//  FavoritesGraphViewController.swift
//  CalculatorBrain
//
//  Created by Tatiana Kornilova on 5/12/15.
//  Copyright (c) 2015 Tatiana Kornilova. All rights reserved.
//

import UIKit

class FavoritesGraphViewController: GraphViewController, UIPopoverPresentationControllerDelegate {
    
    var favoritePrograms: [PropertyList] {
        get { return defaults.objectForKey(FavoritesName.DefaultsKey) as? [PropertyList] ?? [] }
        set { defaults.setObject(newValue, forKey: FavoritesName.DefaultsKey) }
    }

    @IBAction func addFavorite() {
        if let favoriteProgram: PropertyList = program {
            favoritePrograms += [favoriteProgram]
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case FavoritesName.SegueIdentifierFavorite:
                if let ftvc = segue.destinationViewController
                                               as? FavoritesTableViewController {
                    if let ppc = ftvc.popoverPresentationController {
                        ppc.delegate = self
                    }
                    ftvc.programs = favoritePrograms
                    
                    // select closure
                    ftvc.didSelect = { [unowned self] (controller, index) in
                        // hide favorite scene
                        // controller.dismissViewControllerAnimated(true, completion: nil)
                        self.program = self.favoritePrograms [index]
                    }
                    // delete closure
                    ftvc.didDelete = { [unowned self] (controller, index) in
                        self.favoritePrograms.removeAtIndex(index)
                    }
                    // description closure
                    ftvc.descriptionProgram = {[unowned self] (controller, index) in
                        self.brain.program =  self.favoritePrograms[index]
                        return self.brain.description.componentsSeparatedByString(",").last ?? ""
                        
                    }
                }
                
            default: break
            }
        }
    }
    
    private struct FavoritesName {
        static let SegueIdentifierFavorite = "Show Favorites"
        static let DefaultsKey = "FavoritesGraphViewController.Favorites"
    }

    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController!,
                                  traitCollection: UITraitCollection!) -> UIModalPresentationStyle {
          return UIModalPresentationStyle.None
    }
    
  //----- кнопка Play для запуска анимации добавляется на верхнюю панель справа
    override func viewDidLoad() {
        super.viewDidLoad()
              // also add camera icon
            let animationButton = UIBarButtonItem(barButtonSystemItem: .Play, target: self, action: "animateGraphs:")
            if let button = navigationItem.rightBarButtonItem {
                navigationItem.rightBarButtonItems = [button,animationButton]
            } else {
                navigationItem.rightBarButtonItem = animationButton
            }
    }
   //----- action для анимации----
   // случайно выбираем график из списка favoritePrograms
   // случайно выбираем тип анимации из списка optionsAnimation
    func animateGraphs(sender: UIBarButtonItem) {
        if favoritePrograms.count > 0 {
            let i = Int(arc4random_uniform(UInt32(favoritePrograms.count)))
            let optionsAnimation = [UIViewAnimationOptions.TransitionFlipFromLeft,
                UIViewAnimationOptions.TransitionCrossDissolve,
                UIViewAnimationOptions.TransitionCurlUp,
                UIViewAnimationOptions.TransitionCrossDissolve,
                UIViewAnimationOptions.TransitionCurlDown,
                UIViewAnimationOptions.TransitionFlipFromBottom,
                UIViewAnimationOptions.TransitionFlipFromTop]
            let j = Int(arc4random_uniform(UInt32(optionsAnimation.count)))
            
            UIView.transitionWithView(graphView!, duration: 0.75,
                options: optionsAnimation[j],
                animations: { [unowned self] in self.program = self.favoritePrograms[i]},
                completion: nil)
            
        }
    }
}

