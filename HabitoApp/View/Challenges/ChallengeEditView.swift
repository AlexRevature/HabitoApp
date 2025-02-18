//
//  ChallengeEditView.swift
//  HabitoApp
//
//  Created by Alex Cabrera on 2/6/25.
//

import SwiftUI

struct ChallengeEditView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(AccountViewModel.self) var accountViewModel  // Added to access currentUser
    
    // Form fields.
    @State private var title: String = ""
    @State private var message: String = ""
    @State private var total: String = "1"
    @State private var unit: String = "a"
    
    // Image handling.
    @State private var imageName: String = "a"
    @State private var selectedImage: UIImage? = nil
    @State private var isShowingImagePicker: Bool = false
    
    // Date fields for the challenge.
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()

    
    // Closure to call when a new challenge is saved.
    var onSave: (() -> Void)?
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Challenge Details")) {
                    TextField("Title", text: $title)
                    TextField("Message", text: $message)
                }
                
                Section(header: Text("Date Range")) {
                    DatePicker("Start Date", selection: $startDate, displayedComponents: [.date])
                    DatePicker("End Date", selection: $endDate, displayedComponents: [.date])
                }
                
                Section {
                    Button("Save Challenge") {
                        saveChallenge()
                    }
                }
            }
            .navigationTitle("New Challenge")
            .sheet(isPresented: $isShowingImagePicker) {
                ImagePicker(selectedImage: $selectedImage)
            }
        }
    }
    
    func saveChallenge() {
        guard !title.isEmpty,
              !message.isEmpty,
              let totalValue = Int(total),
              !unit.isEmpty,
              !imageName.isEmpty,
              let userId = accountViewModel.currentUser?.id else {
            return
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let formattedStartDate = formatter.string(from: startDate)
        let formattedEndDate = formatter.string(from: endDate)
        
        ChallengeModel.shared.addChallenge(
            title: title,
            message: message,
            imageName: imageName,
            backImageName: "challengeBack",
            trackImageName: "trophy.fill",
            count: 0,
            total: totalValue,
            unit: unit,
            startDate: formattedStartDate,
            endDate: formattedEndDate,
            userId: userId
        )
        
        onSave?()
        presentationMode.wrappedValue.dismiss()
    }

}

// MARK: - ImagePicker Implementation

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedImage: UIImage?
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.selectedImage = uiImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}

// MARK: - View Extension for Placeholder

extension View {
    /// Overlays a placeholder view when a condition is met.
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
}
