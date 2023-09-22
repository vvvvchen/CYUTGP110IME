//
//  Favorite.swift
//
//  Created on 2023/8/18.
//

import SwiftUI

struct FavoriteView : View
{
    //TabView選擇的頁面
    @Binding var ContenSelect: Int

    var body: some View
    {
        ZStack
        {
            //MARK: 最愛列表
            List
            {
                ForEach(0..<10)
                {_ in
                    VStack(alignment: .leading)
                    {
                        HStack
                        {
                            //頭像
                            Circle()
                                .fill(Color(.systemGray3))
                                .frame(width: 50)

                            Text("收藏料理")
                                .font(.title3)
                                .foregroundColor(.black)
                        }

                        Text("料理作法")
                            .font(.title2)
                            .foregroundColor(.black)
                            .padding(10)
                            .frame(maxWidth: .infinity)
                            .background(Color(.systemGray3))
                            .cornerRadius(30)
                    }
                }
            }
            .listStyle(.plain)
        }
    }
}

struct FavoriteView_Previews: PreviewProvider
{
    static var previews: some View
    {
        ContentView()
    }
}
