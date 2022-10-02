//
//  ContentView.swift
//  test
//
//  Created by Gabriel Moffa on 23/09/22.
//

import SwiftUI
import AVFAudio
import SoundAnalysis
import Combine
import Foundation

struct ContentView: View {
    
    @ObservedObject var soundResultsObserver: SoundResultsObserver
    
    init() {
            soundResultsObserver = SoundResultsObserver()
           soundManager = SoundResultsObserver()
            //soundManager.resultObservation(with: soundResultsObserver)
        }
    private var soundManager: SoundResultsObserver

    
    func analyzeAudio(buffer: AVAudioBuffer, at time: AVAudioTime) {
        analysisQueue.async {
            self.streamAnalyzer.analyze(buffer,
                                        atAudioFramePosition: time.sampleTime)
        }
    }
    
     let audioEngine: AVAudioEngine = AVAudioEngine() // Mark 1
     let inputBus: AVAudioNodeBus = AVAudioNodeBus(0) // Mark 2
     @State var inputFormat: AVAudioFormat!
     @State var streamAnalyzer: SNAudioStreamAnalyzer!
     let resultsObserver = SoundResultsObserver() // Mark 3
     let analysisQueue = DispatchQueue(label: "com.example.AnalysisQueue")
    
    func test() -> String {
    var x: String = ""
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                // remove existing table before adding new one
            print("X")
            x = soundManager.currentSound
        }
        
        return x
    }
    
    
    func cou()->Int{
        
        var x: Int = soundResultsObserver.counter
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                // remove existing table before adding new one
            soundResultsObserver.counter = soundResultsObserver.counter + 1
        }
        
        return soundResultsObserver.counter
    }
    
    
    
    
    var body: some View {
        
        ZStack{
            
            
            Text("\(soundResultsObserver.currentSound)")
            
            Text(test())
            
                

            
        }.onAppear{
            inputFormat = audioEngine.inputNode.inputFormat(forBus: inputBus)
            
            
            
            do {
                    try audioEngine.start() // Mark 2
                    
                    audioEngine.inputNode.installTap(onBus: inputBus,
                                                     bufferSize: 8192,
                                                     format: inputFormat, block: analyzeAudio(buffer:at:)) // Mark 3
                    
                    streamAnalyzer = SNAudioStreamAnalyzer(format: inputFormat) // Mark 4
                    
                    let request = try SNClassifySoundRequest(classifierIdentifier: SNClassifierIdentifier.version1) // Mark 5
                print ("TestTest", request)
                
                    
                    
                    try streamAnalyzer.add(request,
                                           withObserver: resultsObserver) // Mark 6
                    
                    
                } catch {
                    print("Unable to start AVAudioEngine: \(error.localizedDescription)")
                }
                
            }
            
            
        }
        
    }


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
