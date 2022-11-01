//
//  SongImageView.swift
//  Music Box (iOS)
//
//  Created by James Lockhart on 2022-10-31.
//

import SwiftUI

struct SongImageView: View {
    let color: Color
    
    var body: some View {
        HStack {
            Spacer()
            Image(uiImage: UIImage(named: "OnePiece")!)
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .foregroundColor(color.opacity(0.5))
        }
    }
}
