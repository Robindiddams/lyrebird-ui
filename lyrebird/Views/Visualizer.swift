//
//  Visualizer.swift
//  lyrebird
//
//  Created by Robin Diddams on 2/8/19.
//  Copyright © 2019 Robin Diddams. All rights reserved.
//

/*
 Some code adapted from github.com/HassanElDesouky/VoiceMemosClone, here's their license
 MIT License
 
 Copyright (c) 2019 Hassan El Desouky
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import UIKit

class Visualizer: UIView{
    
    // Bar width
    var barWidth: CGFloat = 6.0
    // Indicate that waveform should draw active/inactive state
    var active = false {
        didSet {
            if self.active {
                self.color = UIColor.lightGray.cgColor
            }
            else {
                self.color = UIColor.lightGray.cgColor
            }
        }
    }
    // Color for bars
    var color = UIColor.lightGray.cgColor
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
