//
//  ContentView.swift
//  Joiefull
//
//  Created by Margot Pasquali on 16/12/2024.
//

import SwiftUI

struct SplashScreenView: View {
    var body: some View {
        ZStack {
            Color("Custom Orange")
                .ignoresSafeArea()
            
            Image("Logo")
                .resizable()
                .frame(width: 199, height: 50)
                .offset(y: -23)
        }
    }
}

#Preview {
    SplashScreenView()
}
