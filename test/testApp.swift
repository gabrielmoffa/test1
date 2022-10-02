//
//  testApp.swift
//  test
//
//  Created by Gabriel Moffa on 23/09/22.
//

import SwiftUI
import Combine
import SoundAnalysis

@main
struct testApp: App {
    
    private var subject: PassthroughSubject<SNClassificationResult, Error>?

    @StateObject var soundResultsObserver = SoundResultsObserver()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(soundResultsObserver)
        }
    }
}
