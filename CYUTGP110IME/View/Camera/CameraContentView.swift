//
//  CameraContentView.swift
//  Camera
//
//  Created by Patryk Maciąg on 24/06/2023.
//

import SwiftUI

struct CameraContentView: View
{
    //控制相機的操作和狀態的屬性。
    @ObservedObject var cameraManagerViewModel: CameraManagerViewModel
    //跟蹤指示器是否可見
    @State private var isIndicatorVisible = false
    @State private var test: Bool = false
    //代表一個 CGPoint，表示某個點的位置
    @State private var indicatorPoint: CGPoint = .zero
    {
        //觀察indicatorPoint的值是否發生變化
        didSet
        {
            //輸出indicatorPoint的當前坐標值
            print(indicatorPoint.x)
            print(indicatorPoint.y)
            isIndicatorVisible = true
            DispatchQueue.main.asyncAfter(deadline: .now()+0.3, execute:
                                            {
                isIndicatorVisible = false
            })
        }
    }
    
    var body: some View
    {
        switch cameraManagerViewModel.appState
        {
        case .photoPreviewMode, .moviePreviewMode:
            ZStack
            {
                if let url = cameraManagerViewModel.capturedMovieURL, cameraManagerViewModel.appState == .moviePreviewMode
                {
                    CustomVideoPlayer(movie: url)
                        .cornerRadius(30)
                }
                else if let data = cameraManagerViewModel.capturedPhotoData, let uiImage = UIImage(data: data), cameraManagerViewModel.appState == .photoPreviewMode
                {
                    Image(uiImage: uiImage)
                        .resizable(resizingMode: .stretch)
                        .cornerRadius(30)
                } else
                {
                    EmptyView() //Something went horribly wrong
                }
            }
            .overlay(content:
                        {
                VStack{
                    Spacer()
                    HStack{
                        Button(action:
                                {
                            cameraManagerViewModel.save()
                            cameraManagerViewModel.discard()
                        },
                               label:
                                {
                            HStack
                            {
                                Text("Save")
                                Image(systemName: "arrow.down")
                                    .fontWeight(.semibold)
                            }
                            .font(.caption)
                            .foregroundColor(.black)
                            .padding()
                            .background
                            {
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(.white)
                            }
                        })
                        Spacer()
                        Button(action:
                                {
                            cameraManagerViewModel.discard()
                        },
                               label:
                                {
                            HStack
                            {
                                Text("Discard")
                                Image(systemName: "arrow.uturn.backward")
                                    .fontWeight(.semibold)
                            }
                            .font(.caption)
                            .foregroundColor(.black)
                            .padding()
                            .background
                            {
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(.white)
                            }
                        })
                    }
                    .padding()
                }
            })
        case .captureMode:
            ZStack{
                GeometryReader
                {
                    g in
                    CameraPreview()
                        .cornerRadius(30)
                        .gesture(
                            MagnificationGesture()
                                .onChanged{ scale in
                                    if scale >= 1.0 { cameraManagerViewModel.zoomIn() }
                                    if scale < 1.0 { cameraManagerViewModel.zoomOut() }
                                }
                        )
                        .onTapGesture(count: 2)
                    {
                            cameraManagerViewModel.flipCamera()
                        }
                        .onTapGesture
                    { l
                        in
                            let point = CGPoint(x: l.x / g.size.width, y: l.y / g.size.height)
                            indicatorPoint = point
                            cameraManagerViewModel.focusAndExpose(at: point)
                        }
                        .overlay(content:
                                    {
                            CameraOveraly(vm: cameraManagerViewModel)
                        })
                }
                
                //Tap indicator
                //TODO: - It does not work?! Always shows at the same point
                Circle()
                    .position(indicatorPoint)
                    .frame(width: 40, height: 40)
                    .opacity(isIndicatorVisible ? 1 : 0)
            }
        }
    }
}

struct CameraContentView_Previews: PreviewProvider
{
    static var previews: some View
    {
        CameraContentView(cameraManagerViewModel: CameraManagerViewModel())
    }
}
