//
//  HyperglycemiaView.swift
//
//  Created by 0911
//

import SwiftUI
import Charts

//血糖紀錄
struct HyperglycemiaRecord: Identifiable
{
    var id = UUID()
    var hyperglycemia: Double
    var date: Date
    
    init(hyperglycemia: Double)
    {
        self.hyperglycemia = hyperglycemia
        self.date = Date()
    }
}

//包含ID和高血糖相關紀錄數組
struct HyperglycemiaTemperatureSensor: Identifiable
{
    var id: String
    var records: [HyperglycemiaRecord]
}

//存取TemperatureSensor數據
var HyperglycemiaallSensors: [HyperglycemiaTemperatureSensor] = [
    .init(id: "血糖值", records: [])
]

// MARK: 日期func
private func formattedDate(_ date: Date) -> String
{
    let formatter = DateFormatter()
    formatter.dateFormat = "MM-dd"
    return formatter.string(from: date)
}

struct HyperglycemiaView: View
{
    let upperLimit: Double = 300.0
    @State private var hyperglycemia: String = ""
    @State private var chartData: [HyperglycemiaRecord] = []
    @State private var isShowingList: Bool = false
    @State private var scrollToBottom: Bool = false
    @State private var showAlert: Bool = false
    
    var body: some View
    {
        NavigationView
        {
            VStack(spacing: 30)
            {
                GeometryReader
                {
                    geometry in
                    ScrollView(.horizontal, showsIndicators: false)
                    {
                        ScrollViewReader
                        {
                            scrollViewProxy in
                            Chart(HyperglycemiaallSensors)
                            {
                                sensor in
                                ForEach(chartData)
                                {
                                    record in
                                    LineMark(
                                        x: .value("Hour", formattedDate(record.date)),
                                        y: .value("Value", record.hyperglycemia)
                                    )
                                    .lineStyle(.init(lineWidth: 5))
                                    
                                    PointMark(
                                        x: .value("Hour", formattedDate(record.date)),
                                        y: .value("Value", record.hyperglycemia)
                                    )
                                    .annotation(position: .top)
                                    {
                                        Text("\(record.hyperglycemia, specifier: "%.2f")")
                                            .font(.system(size: 12))
                                            .foregroundColor(Color("textcolor"))
                                    }
                                }
                                .foregroundStyle(by: .value("Location", sensor.id))
                                .symbol(by: .value("Sensor Location", sensor.id))
                                .symbolSize(100)
                            }
                            .chartForegroundStyleScale([
                                "血糖值": .orange
                            ])
                            .frame(width: 350, height: 270)
                            .onAppear
                            {
                                if scrollToBottom
                                {
                                    scrollViewProxy.scrollTo(chartData.count - 1)
                                    scrollToBottom = false
                                }
                            }
                        }
                    }
                    .offset(x:20,y: 70)
                }
                VStack
                {
                    Text("血糖值輸入")
                        .font(.system(size: 20, weight: .semibold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 20)
                        .foregroundColor(Color("textcolor"))
                    
                    VStack(spacing: -5)
                    {
                        TextField("請輸入血糖值", text: $hyperglycemia)
                            .padding()
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                            .frame(width: 330)
                            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillChangeFrameNotification))
                        {
                            _ in
                        }
                        .onChange(of: hyperglycemia)
                        {
                            newValue in
                            if let newValue = Double(newValue), newValue > upperLimit
                            {
                                //當輸入的值超過上限時，會顯示警告
                                showAlert = true
                                //將輸入值截斷為上限值
                                hyperglycemia = String(upperLimit)
                            }
                        }
                        
                        Button(action:
                                {
                            if let hyperglycemiaValue = Double(hyperglycemia)
                            {
                                if let existingRecordIndex = chartData.firstIndex(where:
                                                                                    { Calendar.current.isDate($0.date, inSameDayAs: Date()) }) {
                                    //找到當天的記錄
                                    chartData[existingRecordIndex].hyperglycemia = hyperglycemiaValue
                                }
                                else
                                {
                                    //創建新的當天記錄
                                    let newRecord = HyperglycemiaRecord(hyperglycemia: hyperglycemiaValue)
                                    chartData.append(newRecord)
                                }
                                
                                hyperglycemia = ""
                                //將標誌設為true，以便滾動到底部
                                scrollToBottom = true
                            }
                        }) {
                            Text("紀錄血糖")
                                .foregroundColor(Color("textcolor"))
                                .padding(10)
                                .frame(width: 300, height: 50)
                                .background(Color(hue: 0.031, saturation: 0.803, brightness: 0.983))
                                .cornerRadius(100)
                                .font(.title3)
                        }
                        .padding()
                    }
                }
                .offset(y: -70)
            }
            .navigationTitle("血糖紀錄")
            .toolbar
            {
                ToolbarItem(placement: .navigationBarTrailing)
                {
                    Button(action:
                            {
                        isShowingList.toggle()
                    }) {
                        Image(systemName: "list.dash")
                            .font(.title)
                            .foregroundColor(Color(hue: 0.031, saturation: 0.803, brightness: 0.983))
                    }
                }
            }
            .sheet(isPresented: $isShowingList)
            {
                HyperglycemiaRecordsListView(records: $chartData)
            }
            //超過上限警告
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("警告"),
                    message: Text("輸入的血糖值最高為300，請重新輸入。"),
                    dismissButton: .default(Text("確定"))
                )
            }
        }
    }
}

//列表記錄
struct HyperglycemiaRecordsListView: View
{
    @Binding var records: [HyperglycemiaRecord]
    
    var body: some View
    {
        NavigationView
        {
            List
            {
                ForEach(records)
                {
                    record in
                    NavigationLink(destination: EditHyperglycemiaRecordView(record: $records[records.firstIndex(where: { $0.id == record.id })!])) {
                        Text("\(formattedDate(record.date)): \(record.hyperglycemia, specifier: "%.2f")")
                    }
                }
                .onDelete(perform: deleteRecord)
            }
            .navigationTitle("血糖紀錄列表")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing)
                {
                    EditButton()
                }
            }
        }
    }
    //列表刪除功能
    private func deleteRecord(at offsets: IndexSet)
    {
        records.remove(atOffsets: offsets)
    }
}

//編輯血糖紀錄視圖
struct EditHyperglycemiaRecordView: View
{
    @Binding var record: HyperglycemiaRecord
    @State private var editedHyperglycemia: String = ""
    @State private var originalHypertension: Double = 0.0
    @State private var showAlert: Bool = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View
    {
        VStack
        {
            TextField("血糖值", text: $editedHyperglycemia)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .onAppear
            {
                editedHyperglycemia = String(record.hyperglycemia)
            }
            
            Button("保存")
            {
                if let editedValue = Double(editedHyperglycemia)
                {
                    //檢查是否超過上限
                    if editedValue <= 300
                    {
                        record.hyperglycemia = editedValue
                        presentationMode.wrappedValue.dismiss()
                    }
                    else
                    {
                        //超過上限時顯示警告
                        showAlert = true
                    }
                }
            }
            .padding()
        }
        .navigationTitle("編輯血糖值")
        //超過上限時顯示警告
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("警告"),
                message: Text("輸入的血糖值最高為300，請重新輸入。"),
                dismissButton: .default(Text("確定"))
            )
        }
    }
}

struct HyperglycemiaView_Previews: PreviewProvider
{
    static var previews: some View
    {
        HyperglycemiaView()
    }
}
