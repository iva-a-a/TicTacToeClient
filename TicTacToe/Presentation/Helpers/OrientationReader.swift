//
//  OrientationReader.swift
//  TicTacToe

import SwiftUI

struct OrientationReader<Content: View>: View {
    @State private var isLandscape: Bool = UIDevice.current.orientation.isLandscape
    
    let content: (_ isLandscape: Bool) -> Content
    
    var body: some View {
        GeometryReader { geometry in
            let landscape = geometry.size.width > geometry.size.height
            content(landscape)
                .frame(width: geometry.size.width, height: geometry.size.height)
                .onAppear { isLandscape = landscape }
                .onChange(of: geometry.size) {
                    isLandscape = geometry.size.width > geometry.size.height
                }
        }
    }
}
