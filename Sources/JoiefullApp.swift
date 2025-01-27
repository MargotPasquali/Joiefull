//
//  JoiefullApp.swift
//  Joiefull
//
//  Created by Margot Pasquali on 16/12/2024.
//

import SwiftUI
import JoiefullModels

@main
struct JoiefullApp: App {
    
    @State private var showSplashScreen = true
    
    var body: some Scene {
        WindowGroup {
            if showSplashScreen {
                SplashScreenView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                self.showSplashScreen = false
                            }
                        }
                    }
            } else {
                ListView()
            }
        }
    }
}

