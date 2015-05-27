//
//  GraphViewController.swift
//  CalculatorBrain
//
//  Created by Tatiana Kornilova on 5/6/15.
//  Copyright (c) 2015 Tatiana Kornilova. All rights reserved.
//

import UIKit


class GraphViewController: UIViewController {
    
    @IBOutlet weak var graphView: GraphView! {
        didSet {

            graphView.addGestureRecognizer(UIPinchGestureRecognizer(target: graphView,
                action: "scale:"))
            graphView.addGestureRecognizer(UIPanGestureRecognizer(target: graphView,
                action: "originMove:"))
            let tap = UITapGestureRecognizer(target: graphView, action: "origin:")
            tap.numberOfTapsRequired = 2
            graphView.addGestureRecognizer(tap)
            
            graphView.scale = scale
            graphView.originRelativeToCenter = originRelative
            
            graphView.yForX =  { [unowned self](x:Double)  in
                self.brain.setVariable("M", value: Double (x))
                return self.brain.evaluate()
            }
            updateUI()
        }
    }
    
    
    typealias PropertyList = AnyObject
    var program: PropertyList? {
        didSet {
            brain.setVariable("M", value: 0)
            brain.program = program!
            let descript = brain.description.componentsSeparatedByString(",").last ?? " "
            title = "y = " + descript ?? " "
            updateUI()
        }
    }
    
    var brain = CalculatorBrain()
    
    func updateUI() {
        graphView?.setNeedsDisplay()
    }

    private var scale: CGFloat {
        get { return defaults.objectForKey(Keys.Scale) as? CGFloat ?? 50.0 }
        set { defaults.setObject(newValue, forKey: Keys.Scale) }
    }
    
    private var originRelative: CGPoint {
        get {
            var origin = CGPointZero
            if let originArray = defaults.objectForKey(Keys.Origin) as? [CGFloat] {
                origin.x = originArray.first!
                origin.y = originArray.last!
            }
            return origin
        }
        set {
                defaults.setObject([newValue.x, newValue.y], forKey: Keys.Origin)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        scale = graphView.scale
        originRelative = graphView.originRelativeToCenter
    }
    
    let defaults = NSUserDefaults.standardUserDefaults()
    private struct Keys {
        static let Scale = "GraphViewController.Scale"
        static let Origin = "GraphViewController.Origin"
    }
    
}
