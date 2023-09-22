//
//  Mydata.swift
//  Graduation_Project
//
//  Created by Mac on 2023/8/23.
//

import SwiftUI

struct MydataView: View
{
    @Binding var information: Information
    @Environment(\.dismiss) private var dismiss
    @State private var showAlert = false//警示提示視窗
    @State private var alertMessage = " "//提示訊息
    @State private var success: Bool=false
    @State private var temporary: [String]=["", "", "", "", "",""]
    
    private func checkInformation() -> Bool
    {
        for i in self.temporary
        {
            if(i.isEmpty)
            {
                return false
            }
        }
        return true
    }
    
    private func setListView(index: Int) -> some View
    {
        if(index==0 || (index>=5 && index<=4))
        {
            return AnyView(TextField("", text: Binding<String>(
                get: { self.temporary[index] as? String ?? "" },
                set: { self.temporary[index] = $0 }
            )))
        }
        else if(index==1)
        {
            return AnyView(
                Picker("", selection: Binding<String>(
                    get: { self.temporary[index] as? String ?? "" },
                    set: { self.temporary[index] = $0 }
                ))
                {
                    Text("男性").tag("男性")
                    Text("女性").tag("女性")
                    Text("隱私").tag("隱私")
                }
                    .pickerStyle(.wheel)
                    .frame(width: 330, height: 43)
            )
        }
        else if(index==2 || index == 3 || index == 4)
        {
            return AnyView(
                HStack
                {
                    TextField("", text: Binding<String>(
                        get: { self.temporary[index] as? String ?? ""
                            
                        },
                        set: { self.temporary[index] = $0 }
                    ))
                })
        }
        else if(index == 5)
        {
            return AnyView(
                HStack
                {
                    Text(String(format: "%.2f", CalculateBMI(weight: information.weight, height: information.height)))
                })
        }
        else
        {
            return AnyView(Text("ERROR"))
        }
    }
    //MARK: Section欄位
    private func setSection(index: Int) -> String
    {
        switch(index)
        {
        case 0:
            return "名字"
        case 1:
            return "性別"
        case 2:
            return "年齡"
        case 3:
            return "身高"
        case 4:
            return "體重"
        case 5:
            return "BMI"
        default:
            return ""
        }
    }
    //MARK: 更新資訊
    private func updateInformation() async {
        if let name = self.temporary[0] as? String {
            self.information.name = name
        }
        if let gender = self.temporary[1] as? String {
            self.information.gender = gender
        }
        if let ageString = self.temporary[2] as? String, let age = Int(ageString) {
            self.information.age = age
        }
        if let heightString = self.temporary[3] as? String, let height = Double(heightString) {
            self.information.height = Double(height)
        }
        if let weightString = self.temporary[4] as? String, let weight = Double(weightString) {
            self.information.weight = Double(weight)
        }
        if let BMIString = self.temporary[5] as? String, let BMI = Double(BMIString) {
            self.information.BMI = Double(BMI)
        }
    }
    
    var body: some View
    {
        ZStack
        {
            List
            {
                ForEach(0..<temporary.count, id: \.self)
                {
                    index in Section(setSection(index: index))
                    {
                        setListView(index: index)
                    }
                    .headerProminence(.increased)
                }
                Button("確認")
                {
                    Task
                    {
                        if(self.checkInformation())
                        {
                            await self.updateInformation()
                            self.success = true
                            self.alertMessage = "修改成功"
                        }
                        else
                        {
                            self.alertMessage = "請填寫所有欄位"
                            
                            //show alert: invalid...
                            //請填寫所有欄位
                        }
                        
                        self.showAlert=true
                    }
                }
                
                .frame(maxWidth: .infinity)
            }
            .font(.title3)
            .alert(isPresented: self.$showAlert)
            {
                Alert(
                    title: Text(alertMessage),
                    dismissButton: self.alertMessage=="請填寫所有欄位" ? .default(Text("確認")):.cancel(Text("確認"))
                    {
                        self.dismiss()
                    }
                )
            }
        }
        .navigationTitle("編輯個人資料")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear
        {
            temporary[0] = information.name
            temporary[1] = information.gender
            temporary[2] = "\(information.age)"
            temporary[3] = "\(information.height)"
            temporary[4] = "\(information.weight)"
            temporary[5] = "\(information.BMI)"
            
        }
    }
}
//struct MydataView_Previews: PreviewProvider
//{
//    static var previews: some View
//    {
//        NavigationStack
//        {
//            MydataView(
//                information: .constant(
//                    Information(
//                        name: "Justin",
//                        gender: "男性",
//                        age: 21,
//                        height: 170,
//                        weight: 53,
//                        BMI: 19.5)))
//        }
//    }
//}
