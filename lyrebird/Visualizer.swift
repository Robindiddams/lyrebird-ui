//
//  Visualizer.swift
//  lyrebird
//
//  Created by Robin Diddams on 2/8/19.
//  Copyright © 2019 Robin Diddams. All rights reserved.
//

import UIKit

class Visualizer: UIView{
    
    // Bar width
    var barWidth: CGFloat = 6.0
    // Indicate that waveform should draw active/inactive state
    var active = false {
        didSet {
            if self.active {
                self.color = UIColor.purple.cgColor
            }
            else {
                self.color = UIColor.white.cgColor
            }
        }
    }
    // Color for bars
    var color = UIColor.white.cgColor
    // Given waveforms
    var waveforms: [Int] = Array(repeating: 0, count: 100)
    // State manager
    var isRecording : Bool = false
    
    // MARK: - Init
    override init (frame : CGRect) {
        super.init(frame : frame)
        self.setup()
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        self.setup()
    }
    
    func setup() {
//        self.layer.borderColor = UIColor.white.cgColor
//        self.layer.borderWidth = 3.0
//        self.layer.cornerRadius = 10.0
        self.backgroundColor = UIColor.clear
    }
    
    // MARK: - Draw bars
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        context.clear(rect)
        context.setFillColor(red: 0, green: 0, blue: 0, alpha: 0)
        context.fill(rect)
        context.setLineWidth(2)
        context.setStrokeColor(self.color)
        let w = rect.size.width
        let h = rect.size.height
        let t = Int(w / self.barWidth)
        let s = max(0, self.waveforms.count - t)
        let m = h / 2
        let r = self.barWidth / 2
        let x = h - r
        var bar: CGFloat = 0
        for i in s ..< self.waveforms.count {
            var v = h * CGFloat(self.waveforms[i]) / 50.0
            if v > x {
                v = x
            } else if v < 3 {
                v = 3
            }
            let oneX = bar * self.barWidth
            let oneY = v
            context.move(to: CGPoint(x: oneX, y: h))
            context.addLine(to: CGPoint(x: oneX, y: h - oneY * 2))
            
            context.strokePath()
            bar += 1
        }
    }
    
}
