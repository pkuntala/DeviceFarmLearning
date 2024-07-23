//
//  ADAModel.swift
//  Superheroes
//
//  Created by Murukuri Tejasvi Sri Kanaka Lakshmi  on 16/12/21.
//

import Foundation
import AVFoundation

class AppInternalStates{
    private static var ss:AVSpeechSynthesizer=AVSpeechSynthesizer()
    static var internals:AppInternalsStatesMO?
    static var networkAvailability:Bool = true
    
    static func changeAccessibilitySpeechState(){
        if let boolState = internals?.accessibilitySpeech{
            internals!.accessibilitySpeech = boolState ? false : true
        }
    }
    static func getAccessibilitySpeechState()->Bool{
        return internals!.accessibilitySpeech
    }
    static func pronounce(text:String){
        guard let accessibilityEnabled = internals?.accessibilitySpeech else{return}
        if accessibilityEnabled{
            let temp:AVSpeechUtterance=AVSpeechUtterance(string: text)
            ss.speak(temp)
        }
    }
}
