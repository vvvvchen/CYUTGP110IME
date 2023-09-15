//
//  PostTextView.swift
//  IM110
//
//  Created by 曾品瑞 on 2023/9/11.
//

import SwiftUI
import PhotosUI

extension UIApplication {
    func dismissKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct PostTextView: View {
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject private var user: User
    
    @State private var showPicture: Bool=false
    @State private var result: (Bool, String)=(false, "")
    @State private var forum: (String, String, String, Bool)=("", "", "", false)
    @State private var item: PhotosPickerItem?
    @State private var data: Data?
    
    private func postForum() async {
        if(self.forum.1.isEmpty || self.forum.2.isEmpty) {
            self.result.1="Please ensure title and text isn't empty."
            self.result.0.toggle()
        } else {
            let id: String=UUID().uuidString
            
            if let data=self.data,
               let image=UIImage(data: data) {
                StoRage().uploadPicture(path: "forum", name: id, image: image)
            }
            FireStore()
                .setData(id: id, title: self.forum.1, text: self.forum.2, secure: self.forum.3, author: self.user.name) {(_, error) in
                if let error=error {
                    self.result.1=error.localizedDescription
                    self.result.0.toggle()
                } else {
                    self.result.1="Post success!"
                    self.result.0.toggle()
                }
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 5) {
                TextField("Title", text: self.$forum.1)
                    .bold()
                    .font(.largeTitle)
                
                Rectangle().frame(height: 1)
            }
            
            VStack(spacing: 5) {
                HStack {
                    Text("Text")
                        .bold()
                        .font(.title)
                    
                    Spacer()
                    
                    Button("Add picture") {
                        UIApplication.shared.dismissKeyboard()
                        self.showPicture.toggle()
                    }
                    .font(.title2)
                }
                
                TextEditor(text: self.$forum.2)
                    .font(.title3)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(.white, lineWidth: 3))
                    .cornerRadius(10)
            }
        }
        .padding()
        .sheet(isPresented: self.$showPicture) {
            PostImageView(item: self.$item, data: self.$data)
                .presentationBackground(.black.gradient)
                .presentationDetents([.medium])
        }
        .alert(self.result.1, isPresented: self.$result.0) {
            Button("Dismiss", role: .cancel) {
                if(self.result.1.contains("success")) {
                    withAnimation(.easeInOut) {
                        self.forum=("", "", "", false)
                    }
                    self.dismiss()
                }
            }
        }
        .navigationTitle("Post")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Button {
                    withAnimation(.easeInOut) {
                        self.forum.3 = !self.forum.3
                    }
                } label: {
                    Image(systemName: self.forum.3 ? "lock.fill":"lock.open.fill")
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    Task {
                        await self.postForum()
                    }
                }
                .bold()
            }
            
            ToolbarItem(placement: .keyboard) {
                Button("Done") {
                    UIApplication.shared.dismissKeyboard()
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
    }
}
