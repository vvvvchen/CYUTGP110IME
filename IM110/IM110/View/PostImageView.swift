//
//  PostImageView.swift
//  IM110
//
//  Created by 曾品瑞 on 2023/9/11.
//

import SwiftUI
import PhotosUI

struct PostImageView: View {
    @Binding var item: PhotosPickerItem?
    @Binding var data: Data?
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10).fill(.ultraThinMaterial)
            
            PhotosPicker(selection: self.$item, matching: .images) {
                if let data=self.data,
                   let image=UIImage(data: data) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.gray)
                }
            }
            .cornerRadius(10)
            .onChange(of: self.item) {value in
                Task {
                    if let data=try? await value?.loadTransferable(type: Data.self) {
                        self.data=data
                    }
                }
            }
        }
    }
}
