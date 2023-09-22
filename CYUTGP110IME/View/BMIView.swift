//
//  SwiftUIView.swift
//  Graduation_Project
//
//  Created by Ｍac on 2023/9/8.
//

//import SwiftUI
//import Charts

func CalculateBMI(weight: Double, height: Double) -> Double
{
    let heightInMeters = height / 100
    let weightInKilograms = weight
    let bmi = weightInKilograms / (heightInMeters * heightInMeters)
    return bmi
}

//struct BMIView: View
//{
//    @Binding var information: Information
//    var body: some View
//    {
//        Chart(CalculateBMI(weight: information.weight, height: information.height))
//        {
//            CalculateBMI in
//            LineMark(
//                x: .value("x", CalculateBMI.x),
//                y: .value("Y", CalculateBMI.y)
//            )
//        }
//    }
//}
//
//struct SwiftUIView_Previews: PreviewProvider
//{
//    static var previews: some View
//    {
//        BMIView(information:)
//    }
//}
