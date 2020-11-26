//
//  ViewController.swift
//  Project27
//
//  Created by Alexander Ha on 11/25/20.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    var currentDrawType = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        drawTwin()
        
    }
    
    @IBAction func redrawTapped(_ sender: UIButton) {
        
        currentDrawType += 1
        
        if currentDrawType > 7 {
            currentDrawType = 0
        }
        switch currentDrawType {
        case 0:
            drawRectangle()
        case 1:
            drawCircle()
        case 2:
            drawCheckerboard()
        case 3:
            drawRotatedSquares()
        case 4:
            drawLines()
        case 5:
            drawImagesAndText()
        case 6:
            drawEmoji()
        case 7:
            drawTwin()
        default:
            break
        }
    }
    //MARK: - Draws Rectangle
    
    func drawRectangle() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
            //drawing code
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512)
            
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)
            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        imageView.image = img
    }
    
    //MARK: - Draws Circle
    
    func drawCircle() {
        
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
            //drawing code
            let circle = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 5, dy: 5)
            
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)
            ctx.cgContext.addEllipse(in: circle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        imageView.image = img
    }
    
    //MARK: - Draws checkerboard
    
    func drawCheckerboard() {
        
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
            //drawing code
            ctx.cgContext.setFillColor(UIColor.black.cgColor)
            
            for row in 0 ..< 8 {
                for col in 0 ..< 8 {
                    if (row + col) % 2 == 0 {
                        ctx.cgContext.fill(CGRect(x: col * 64, y: row * 64, width: 64, height: 64))
                    }
                }
            }
        }
        imageView.image = img
    }
    
    //MARK: - Draws Rotated Squares
    
    func drawRotatedSquares() {
        
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
            
            ctx.cgContext.translateBy(x: 256, y: 256)
            
            let rotations = 16
            let amount = Double.pi / Double(rotations)
            
            for _ in 0 ..< rotations {
                ctx.cgContext.rotate(by: CGFloat(amount))
                ctx.cgContext.addRect(CGRect(x: -128, y: -128, width: 256, height: 256))
            }
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
        }
        imageView.image = img
    }
    
    //MARK: - Draws boxes with lines in decreasing size
    
    func drawLines() {
        
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
            
            ctx.cgContext.translateBy(x: 256, y: 256)
            
            var first = true
            var length: CGFloat = 256
            
            for _ in 0 ..< 256 {
                ctx.cgContext.rotate(by: .pi / 2)
                if first {
                    ctx.cgContext.move(to: CGPoint(x: length, y: 50))
                    first = false
                } else {
                    ctx.cgContext.addLine(to: CGPoint(x: length, y: 50))
                }
                length *= 0.99
            }
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
        }
        imageView.image = img
    }
    
    //MARK: - Draw Images and Text
    
    func drawImagesAndText() {
        
        // 1.
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        let img = renderer.image { ctx in
            // 2.
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            // 3.
            let attributes: [NSAttributedString.Key : Any] = [
                .font : UIFont.systemFont(ofSize: 36),
                .paragraphStyle : paragraphStyle
            ]
            // 4.
            let string = "The best-laid schemes o'\nmice an' men gang aft agly"
            let attributedString = NSAttributedString(string: string, attributes: attributes)
            // 5.
            attributedString.draw(with: CGRect(x: 32, y: 32, width: 448, height: 448), options: .usesLineFragmentOrigin, context: nil)
            // 5.
            let mouse = UIImage(named: "mouse")
            mouse?.draw(at: CGPoint(x: 165, y: 150))
        }
        // 6.
        imageView.image = img
    }
    
    
    //MARK: - Test Functions Hacking with Swift Challenges
    
    
    /* Pick an emoji and create it using core graphics */
    
    func drawEmoji() {  // 🙂
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 5, dy: 5)
            
            ctx.cgContext.setFillColor(UIColor.yellow.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)
            
            ctx.cgContext.addEllipse(in: rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
            // eyes
            ctx.cgContext.setFillColor(UIColor.black.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            
            let eyeRect1 = CGRect(x: 128, y: 170, width: 20, height: 20)
            let eyeRect2 = CGRect(x: 384, y: 170, width: 20, height: 20)
            ctx.cgContext.addEllipse(in: eyeRect1)
            ctx.cgContext.addEllipse(in: eyeRect2)
            ctx.cgContext.drawPath(using: .fillStroke)
            
            //            ctx.cgContext.move(to: CGPoint(x: 256, y: 340))
            //                ctx.cgContext.beginPath()
            ctx.cgContext.addArc(center: CGPoint(x: 256, y: 220),radius: 220,  startAngle: CGFloat(2), endAngle: CGFloat(1), clockwise: true)
            ctx.cgContext.drawPath(using: .stroke)
        }
        
        imageView.image = img
        
    }
    
    /* use a combination of move(to:) and addLine(to:) to create and stroke a path that spells "TWIN" on the canvas */
    
    func drawTwin() {
        
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { context in
            
            let cx = context.cgContext
            cx.translateBy(x: 100, y: 200)
            cx.setStrokeColor(UIColor.black.cgColor)
            cx.setLineWidth(10)
            
            // T
            cx.move(to: CGPoint(x: 10, y: 0))
            cx.addLine(to: CGPoint(x: 110, y: 0))
            cx.move(to: CGPoint(x: 60, y: 0))
            cx.addLine(to: CGPoint(x: 60, y: 100))
            
            //W
            cx.move(to: CGPoint(x: 120, y: 0))
            cx.addLine(to: CGPoint(x: 135, y: 100))
            cx.move(to: CGPoint(x: 135, y: 100))
            cx.addLine(to: CGPoint(x: 155, y: 0))
            cx.move(to: CGPoint(x: 155, y: 0))
            cx.addLine(to: CGPoint(x: 175, y: 100))
            cx.move(to: CGPoint(x: 175, y: 100))
            cx.addLine(to: CGPoint(x: 190, y: 0))
            
            //I
            cx.move(to: CGPoint(x: 220, y: 0))
            cx.addLine(to: CGPoint(x: 220, y: 100))
            
            //N
            cx.move(to: CGPoint(x: 250, y: 100))
            cx.addLine(to: CGPoint(x: 250, y: 0))
            cx.move(to: CGPoint(x: 250, y: 0))
            cx.addLine(to: CGPoint(x: 295, y: 100))
            cx.move(to: CGPoint(x: 295, y: 100))
            cx.addLine(to: CGPoint(x: 295, y: 0))
            
            cx.drawPath(using: .fillStroke)
        }
        imageView.image = img
    }
    
}


