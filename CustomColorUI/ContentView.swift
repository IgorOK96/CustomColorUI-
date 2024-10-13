//
//  ContentView.swift
//  CustomColorUI
//
//  Created by user246073 on 10/13/24.
//

import SwiftUI

struct ContentView: View {
    @State private var redValue = Double.random(in: 1...255)
        @State private var greenValue = Double.random(in: 1...255)
        @State private var blueValue = Double.random(in: 1...255)

        var body: some View {
            ZStack {
                Color.cyan
                    .ignoresSafeArea()
                VStack {
                    ColorsView(redValue: redValue, greenValue: greenValue, blueValue: blueValue)
                        .padding(.bottom, 20)
                    VStack(spacing: 20) {
                        ColorSliderView(value: $redValue, color: .red)
                        ColorSliderView(value: $greenValue, color: .green)
                        ColorSliderView(value: $blueValue, color: .blue)
                    }
                    .padding(.top, 20)
                    Spacer()
                }
                .padding()
            }
        }
    }
#Preview {
    ContentView()
}

struct ColorsView: View {
    var redValue: Double
    var greenValue: Double
    var blueValue: Double
    
    var body: some View {
        Rectangle()
            .fill(Color(red: redValue/255, green: greenValue/255, blue: blueValue/255)) // Устанавливаем цвет фона
            .frame(width: 350, height: 200)
            .cornerRadius(20) // Закругляем углы
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.black, lineWidth: 8)
            )
            .offset(y: 10)
    }
}


struct ColorSliderView: View {
    @Binding var value: Double
    var color: Color
    
    @State private var textFieldValue: String = ""
    @FocusState private var isTextFieldFocused: Bool // Локальное управление фокусом
    
    var body: some View {
        HStack {
            Text("\(Int(value))")
                .foregroundStyle(color)
                .frame(width: 30, alignment: .leading)
            
            Slider(value: $value, in: 0...255, step: 1)
                .tint(color)
                .onChange(of: value) { oldValue, newValue in
                    // Плавная анимация при изменении значения слайдера
                    withAnimation {
                        textFieldValue = String(Int(newValue))
                    }
                }
            
            TextField("", text: $textFieldValue)
                .focused($isTextFieldFocused)
                .keyboardType(.numberPad)
                .onAppear {
                    textFieldValue = String(Int(value))
                }
                .onChange(of: isTextFieldFocused) { oldValue, newValue in
                    if oldValue && !newValue {
                        applyValueFromTextField()
                    }
                }
                .frame(width: 50)
                .textFieldStyle(.roundedBorder)
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("Done") {
                            isTextFieldFocused = false
                        }
                    }
                }
        }
    }
    
    private func applyValueFromTextField() {
        let clampedValue = min(max(Int(textFieldValue) ?? 0, 0), 255) // Ограничиваем значение от 0 до 255
        
        withAnimation {
            value = Double(clampedValue)
        }
        
        textFieldValue = String(clampedValue)
    }
}
