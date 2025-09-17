//
//  CameraView.swift
//  mushroomapp
//
//  Created by Tien Dung Vu on 12/9/25.
//

import Foundation
import SwiftUI
import UIKit

struct CameraView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: CameraViewModel = .init()
    @State private var isShowingImagePicker: Bool = false

    @EnvironmentObject private var appState: AppState

    var body: some View {
        ZStack {
            TCCameraView { img in
                appState.capturedImage = img
            }
            .ignoresSafeArea()

            // Done
            VStack {
                Text("Keep the mushroom inside the frame for better accuracy.")
                    .font(.footnote)
                    .foregroundStyle(.white)
                    .padding()
                    .multilineTextAlignment(.center)

                Spacer()
                HStack {
                    Button {
                        // Image Picker
                        Task {
                            let isAuthorized = await PhotoPermissionHelper.checkPhotoLibraryPermission()
                            if isAuthorized {
                                isShowingImagePicker = true
                            } else {
                                // Alert not Authorized
                                PhotoPermissionHelper.alertGoSettings()
                            }
                        }
                    } label: {
                        CPhotoView()
                    }

                    Spacer()
                }
            }
            .padding()
        }
        .presentImagePickerSheet(
            isPresented: $isShowingImagePicker,
            image: $appState.capturedImage
        )
        .onChange(of: appState.capturedImage) { _, newValue in
            if let _ = newValue {
                dismiss()
            }
        }
    }
}

// MARK: ViewModel

class CameraViewModel: ObservableObject {
    @Published var image: UIImage?
    @Published var isPresentPreview: Bool = false
    @Published var images: UIImage?

    init() {
        print("CameraVM init")
    }

    deinit {
        print("CameraVM Deinit")
    }
}

private struct ImagePreviewSheetModifier: ViewModifier {
    @Binding var isPresented: Bool
    let images: [UIImage]

    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $isPresented) {
                if let img = images.first {
                    Image(uiImage: img)
                        .resizable()
                        .scaledToFit()
                        .background(Color.red)
                        .padding()
                } else {
                    Text("No image")
                }
            }
    }
}
