//
//  ViewController.swift
//  MetalParticles
//
//  Created by Simon Gladman on 17/01/2015.
//  Copyright (c) 2015 Simon Gladman. All rights reserved.
//
//  Reengineered based on technique from http://memkite.com/blog/2014/12/30/example-of-sharing-memory-between-gpu-and-cpu-with-swift-and-metal-for-ios8/
//
//  Thanks to https://twitter.com/atveit for tips - espewcially using float4x4!!!
//  Thanks to https://twitter.com/warrenm for examples, especially implemnting matrix 4x4 in Swift
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.

//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>

import UIKit

class ViewController: UIViewController, ParticleLabDelegate
{
    let particleLab = ParticleLab()
    
    var gravityWellAngle: Float = 0
    
    var frequency = Float(0.0);
    var amplitude = Float(0.0);
    
    let analyzer: AKAudioAnalyzer
    let microphone: Microphone
    
    override init() {
        microphone = Microphone()
        analyzer = AKAudioAnalyzer(audioSource: microphone.auxilliaryOutput)
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        microphone = Microphone()
        analyzer = AKAudioAnalyzer(audioSource: microphone.auxilliaryOutput)
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        AKOrchestra.addInstrument(microphone)
        AKOrchestra.addInstrument(analyzer)
        microphone.start()
        analyzer.start()
        
        view.backgroundColor = UIColor.blackColor()
        
        view.layer.addSublayer(particleLab)
 
        particleLab.showGravityWellPositions = false
        
        particleLab.particleLabDelegate = self

    }
    
    let floatPi = Float(M_PI)
    
    func particleLabDidUpdate()
    {
        gravityWellAngle = gravityWellAngle + 0.01
        amplitude = analyzer.trackedAmplitude.value
        frequency = analyzer.trackedFrequency.value
        
        particleLab.setGravityWellProperties(gravityWell: .One,
            normalisedPositionX: 0.25 + amplitude,
            normalisedPositionY: 0.25 + amplitude, mass: frequency / 44, spin: frequency / 44)
        /*
        particleLab.setGravityWellProperties(gravityWell: .Four,
        normalisedPositionX: 0.5 + 0.1 * sin(gravityWellAngle + floatPi * 1.5),
        normalisedPositionY: 0.5 + 0.1 * cos(gravityWellAngle + floatPi * 1.5), mass: 11, spin: 13)
        
        particleLab.setGravityWellProperties(gravityWell: .Two,
        normalisedPositionX: 0.5 + (0.35 + sin(gravityWellAngle * 1.7)) * cos(gravityWellAngle / 1.3),
        normalisedPositionY: 0.5 + (0.35 + sin(gravityWellAngle * 1.7)) * sin(gravityWellAngle / 1.3), mass: 26, spin: -16)
        
        particleLab.setGravityWellProperties(gravityWell: .Three,
        normalisedPositionX: 0.5 + (0.35 + sin(gravityWellAngle * 1.7)) * cos(gravityWellAngle / 1.3 + floatPi),
        normalisedPositionY: 0.5 + (0.35 + sin(gravityWellAngle * 1.7)) * sin(gravityWellAngle / 1.3 + floatPi), mass: 26, spin: -16)
        */
    }
    
    override func viewDidLayoutSubviews()
    {
        if view.frame.height > view.frame.width
        {
            let imageSide = view.frame.width
            
            particleLab.frame = CGRect(x: 0, y: view.frame.height / 2.0 - imageSide / 2, width: imageSide, height: imageSide).rectByInsetting(dx: -1, dy: 01)
        }
        else
        {
            let imageSide = view.frame.height
            
            particleLab.frame = CGRect(x: view.frame.width / 2.0 - imageSide / 2 , y: 0, width: imageSide, height: imageSide).rectByInsetting(dx: -1, dy: -1)
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}







