//
//  SoundResultsObserver.swift
//  test
//
//  Created by Gabriel Moffa on 23/09/22.
//

import Foundation
import SoundAnalysis
import Combine

class SoundResultsObserver: NSObject, SNResultsObserving, ObservableObject{
    
    @Published var counter = 0
    
    @Published var currentSound: String = ""

    
    func request(_ request: SNRequest, didProduce result: SNResult) { // Mark 1
                
        guard let result = result as? SNClassificationResult else { return } // Mark 2
        
        guard let classification = result.classification(forIdentifier: "breathing") else { return } // Mark 3
        
        let timeInSeconds = result.timeRange.start.seconds // Mark 4
        
        let formattedTime = {String(format: "%.2f", timeInSeconds)}
        print("Analysis result for audio at time: \(formattedTime)")
        
        //counter = counter + 1
        DispatchQueue.main.async {
                            self.currentSound = classification.identifier
                        }

        if result.classification(forIdentifier: "sigh")!.confidence > 0.1 {
            counter = counter + 1
        }
        print ("counter: ", counter)
        
        let confidence = classification.confidence * 100.0
        let percentString = String(format: "%.2f%%", confidence)
    
        //HOW TO SEND THIS INFORMATION TO A VIEW?
        print("\(classification.identifier): \(percentString) confidence.\n") // Mark 5
        
        //print("\(currentSound)")

        
    }
    
    
    
    func request(_ request: SNRequest, didFailWithError error: Error) {
        print("The the analysis failed: \(error.localizedDescription)")
    }
    
    func requestDidComplete(_ request: SNRequest) {
        print("The request completed successfully!")
    }
}
