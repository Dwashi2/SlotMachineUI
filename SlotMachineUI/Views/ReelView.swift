//
//  ReelView.swift
//  SlotMachineUI
//
//  Created by Daniel Washington Ignacio on 11/01/24.
//

import SwiftUI

struct ReelView: View {
    var body: some View {
        Image("gfx-reel")
            .resizable()
            .modifier(ImageModifier())
    }
}

#Preview {
    ReelView()
}
