//
//  ChallengeEditView.swift
//  HabitoApp
//
//  Created by Alex Cabrera on 2/6/25.
//

import SwiftUI

struct ChallengeEditView: View {
    @Environment(\.presentationMode) var presentationMode
    
    // Form fields.
    @State private var title: String = ""
    @State private var message: String = ""
    @State private var total: String = ""
    @State private var unit: String = ""
    
    // Image handling.
    @State private var imageName: String = ""
    @State private var selectedImage: UIImage? = nil
    @State private var isShowingImagePicker: Bool = false
    
    // Date field for the challenge.
    @State private var challengeDate: Date = Date()
    
    // Closure to call when a new challenge is saved.
    var onSave: (() -> Void)?
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Challenge Details")) {
                    TextField("Title", text: $title)
                    TextField("Message", text: $message)
                    TextField("Total (e.g., 10000)", text: $total)
                        .keyboardType(.numberPad)
                    TextField("Unit (e.g., steps)", text: $unit)
                }
                
                Section(header: Text("Date")) {
                    DatePicker("Select Date", selection: $challengeDate, displayedComponents: [.date])
                        .datePickerStyle(GraphicalDatePickerStyle())
                }
                
                Section(header: Text("Image")) {
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                    } else {
                        Text("No Image Selected")
                            .foregroundColor(.gray)
                    }
                    
                    Button("Choose Image") {
                        isShowingImagePicker = true
                    }
                    
                    TextField("Image Name", text: $imageName)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .placeholder(when: imageName.isEmpty) {
                            Text("Enter a unique image name")
                                .foregroundColor(.gray)
                        }
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
              !imageName.isEmpty else {
            return
        }
        
        // Format the selected date as "MM-dd" to store only month and day.
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd"
        let formattedDate = formatter.string(from: challengeDate)
        
        // Optionally, save the selectedImage to disk using `imageName` here.
        // For this example, we assume that the image will be added to the asset bundle later.
        
        ChallengeModel.shared.addChallenge(
            title: title,
            message: message,
            imageName: imageName,          // User-specified image name.
            backImageName: "challengeBack", // Default background image name.
            trackImageName: "trophy.fill",  // Default track image name.
            count: 0,
            total: totalValue,
            unit: unit,
            date: formattedDate           // Pass the formatted date.
        )
        
        // Trigger the onSave callback to refresh the main view.
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
