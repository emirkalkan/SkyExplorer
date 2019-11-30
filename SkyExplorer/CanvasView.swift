//
//  CanvasView.swift
//  SkyExplorer
//
//  Created by Emir Kalkan on 24.11.2019.
//  Copyright © 2019 Emir Kalkan. All rights reserved.
//

import Foundation
import UIKit

class Canvasview: UIView {

    var halfFrameWidth : CGFloat = 0
    var fullFrameWidth : CGFloat = 0
    var centerView : CGPoint?
    var needleBottomWith : CGFloat = 10.0
    var needleLength : CGFloat = 0
    var changedegree = 90
    override func draw(_ rect: CGRect) {
        self.halfFrameWidth = self.bounds.width/2
        self.fullFrameWidth = self.bounds.width
        needleLength = halfFrameWidth * 0.5
        centerView = CGPoint(x: halfFrameWidth, y: halfFrameWidth)
        createNeedle()
        createCompassMarks()
        
    }
    
 
    func createNeedle()
    {
        
        let upperNeedle = UIBezierPath()
        upperNeedle.move(to: CGPoint(x: halfFrameWidth - needleBottomWith, y: halfFrameWidth))
        upperNeedle.addLine(to: CGPoint(x: halfFrameWidth, y: needleLength))
        upperNeedle.addLine(to: CGPoint(x: halfFrameWidth + needleBottomWith, y: halfFrameWidth))
        upperNeedle.close()
        UIColor(red: 252/255, green: 214/255, blue: 73/255, alpha: 1.0).setFill()
        upperNeedle.fill()
        
        let lowerNeedle = UIBezierPath()
        lowerNeedle.move(to: CGPoint(x: halfFrameWidth - needleBottomWith, y: halfFrameWidth))
        lowerNeedle.addLine(to: CGPoint(x: halfFrameWidth, y: fullFrameWidth - needleLength))
        lowerNeedle.addLine(to: CGPoint(x: halfFrameWidth + needleBottomWith, y: halfFrameWidth))
        lowerNeedle.close()
        UIColor(red: 252/255, green: 214/255, blue: 73/255, alpha: 1.0).setFill()
        lowerNeedle.fill()
        
        
        let centrePin = UIBezierPath(arcCenter: centerView!, radius: 5.0, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        UIColor.darkGray.setFill()
        centrePin.fill()
        
        let innerRing = UIBezierPath(arcCenter: centerView!, radius: halfFrameWidth * 0.9, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        UIColor.white.setStroke()
        innerRing.lineWidth = 2.0
        innerRing.stroke()
        
        let outerRing = UIBezierPath(arcCenter: centerView!, radius: halfFrameWidth * 0.98, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        UIColor.white.setStroke()
        outerRing.lineWidth = 1.0
        outerRing.stroke()
    }
    
    
    
    func archLocationPoint(degree : CGFloat, distance : CGFloat) -> CGPoint
    {
        let location : CGPoint
        let radian :  CGFloat = degree * .pi / 180
        let arcPath = UIBezierPath(arcCenter: centerView!, radius: halfFrameWidth * distance, startAngle: 0, endAngle: radian, clockwise: true)
        location = arcPath.currentPoint
        return location
    }
    
  
    
    func drawLineFromPoint(start : CGPoint, toPoint end:CGPoint, ofColor lineColor: UIColor, inView view:UIView)
    {
        //design the path
        var path = UIBezierPath()
        path.move(to: start)
        path.addLine(to: end)
        
        //design path in layer
        var shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.lineWidth = 1.0
        view.layer.addSublayer(shapeLayer)
    }
    
    
    
    func createCompassMarks()
    {
        for degree in stride(from: 0, to: 360, by: 2)
        {
            let outerArcPoint = archLocationPoint(degree: CGFloat(degree), distance: 0.9)
            
            let markLength = degree % 10
            var innerArcDistance : CGFloat = 0
            if markLength == 0
            {
                innerArcDistance = 0.8
                if changedegree == 360
                {
                    changedegree = 0
                }
                addDegree(degree: changedegree, location: archLocationPoint(degree: CGFloat(degree), distance: 0.95))
                changedegree = changedegree + 10
            }else
            {
                innerArcDistance = 0.85
            }
            let innerArcPoint = archLocationPoint(degree: CGFloat(degree), distance: innerArcDistance)
            
            let markline = UIBezierPath()
            markline.move(to: outerArcPoint)
            markline.addLine(to: innerArcPoint)
            UIColor.white.setStroke()
            markline.lineWidth = 1.0
            markline.stroke()
        }
        
        
        var degree = 0
//        for result in ["E", "SE", "S", "SW", "W", "NW", "N", "NE"]
        for result in ["E", "S", "W", "N"] {
            addDirection(direction: result, degree: degree, location: archLocationPoint(degree: CGFloat(degree), distance: 0.75))
            degree = degree + 90
        }
    }
    
    
    func addDegree(degree : Int, location : CGPoint)
    {
        let textLayer = CATextLayer()
        textLayer.frame = CGRect(x: location.x - 10, y: location.y - 5, width: 20, height: 10)
        textLayer.foregroundColor = UIColor.white.cgColor
        textLayer.fontSize =  CGFloat(10)
        textLayer.font = "Arial" as CFString
        textLayer.string =  String(degree)
        textLayer.alignmentMode = CATextLayerAlignmentMode.center
        textLayer.contentsScale = UIScreen.main.scale
        self.layer.addSublayer(textLayer)
        textLayer.transform = CATransform3DMakeRotation(CGFloat(degree) * .pi/180, 0.0, 0.0, 1.0)
    }
    
    
    func addDirection (direction : String, degree : Int, location : CGPoint)
    {
        let textLayer = CATextLayer()
        textLayer.frame = CGRect(x: location.x - 15, y: location.y - 10, width: 30, height: 20)
        textLayer.foregroundColor = UIColor.white.cgColor
        textLayer.fontSize =  CGFloat(18)
        textLayer.font = "Arial" as CFString
        textLayer.string =  String(direction)
        textLayer.alignmentMode = CATextLayerAlignmentMode.center
        textLayer.contentsScale = UIScreen.main.scale
        self.layer.addSublayer(textLayer)
        textLayer.transform = CATransform3DMakeRotation(CGFloat(degree) * .pi/180, 0.0, 0.0, 1.0)
    }
    

}
