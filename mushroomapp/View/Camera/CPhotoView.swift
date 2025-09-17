//
//  CPhotoView.swift
//  mushroomapp
//
//  Created by Tien Dung Vu on 12/9/25.
//

import Foundation
import SwiftUI

struct CPhotoView: View {
    var body: some View {
        Image(systemName: "photo.stack")
            .font(.callout)
            .fontWeight(.medium)
            .foregroundStyle(.accent)
            .frame(minWidth: 50)
            .padding(.vertical, 6)
            .padding(.horizontal, 18)
            .background(Color.white)
            .clipShape(Capsule())
            .shadow(radius: 2)
        
    }
}
