import SwiftUI

struct WheelOfLifeView: View {
    @StateObject private var viewModel = ToolsViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var showSaveAlert = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                // Wheel Visualization
                WheelCanvas(wheel: viewModel.wheelOfLife)
                    .frame(width: 280, height: 280)
                    .padding(.top)
                
                // Sliders
                VStack(spacing: 20) {
                    WheelSlider(title: "Salud", value: Binding(
                        get: { Double(viewModel.wheelOfLife.health) },
                        set: { viewModel.wheelOfLife.health = Int($0) }
                    ))
                    
                    WheelSlider(title: "Relaciones", value: Binding(
                        get: { Double(viewModel.wheelOfLife.relationships) },
                        set: { viewModel.wheelOfLife.relationships = Int($0) }
                    ))
                    
                    WheelSlider(title: "Finanzas", value: Binding(
                        get: { Double(viewModel.wheelOfLife.finances) },
                        set: { viewModel.wheelOfLife.finances = Int($0) }
                    ))
                    
                    WheelSlider(title: "Carrera", value: Binding(
                        get: { Double(viewModel.wheelOfLife.career) },
                        set: { viewModel.wheelOfLife.career = Int($0) }
                    ))
                    
                    WheelSlider(title: "Desarrollo Personal", value: Binding(
                        get: { Double(viewModel.wheelOfLife.personalDev) },
                        set: { viewModel.wheelOfLife.personalDev = Int($0) }
                    ))
                    
                    WheelSlider(title: "Espiritualidad", value: Binding(
                        get: { Double(viewModel.wheelOfLife.spirituality) },
                        set: { viewModel.wheelOfLife.spirituality = Int($0) }
                    ))
                }
                .padding(.horizontal)
                
                // Save Button
                PrimaryButton(
                    title: "Guardar",
                    action: {
                        Task {
                            await viewModel.saveWheelOfLife()
                            showSaveAlert = true
                        }
                    },
                    isLoading: viewModel.isSaving
                )
                .padding(.horizontal)
                
                Spacer(minLength: 40)
            }
        }
        .background(Color.appBackground)
        .navigationTitle("Rueda de la Vida")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadWheelOfLife()
        }
        .alert("Guardado", isPresented: $showSaveAlert) {
            Button("OK") { }
        } message: {
            Text("Tu rueda de la vida ha sido guardada")
        }
    }
}

struct WheelSlider: View {
    let title: String
    @Binding var value: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.appBody)
                    .foregroundColor(.appTextPrimary)
                Spacer()
                Text("\(Int(value))/10")
                    .font(.appCaption)
                    .fontWeight(.semibold)
                    .foregroundColor(.appPrimary)
            }
            
            HStack(spacing: 8) {
                Slider(value: $value, in: 1...10, step: 1)
                    .tint(.appPrimary)
                
                Text(emojiForValue(value))
                    .font(.title3)
            }
        }
        .padding()
        .background(Color.appSurface)
        .cornerRadius(12)
    }
    
    private func emojiForValue(_ value: Double) -> String {
        switch value {
        case 1...3: return "😟"
        case 4...6: return "😐"
        case 7...8: return "🙂"
        case 9...10: return "🌟"
        default: return "😐"
        }
    }
}

struct WheelCanvas: View {
    let wheel: WheelOfLife
    
    var body: some View {
        Canvas { context, size in
            let center = CGPoint(x: size.width / 2, y: size.height / 2)
            let radius = min(size.width, size.height) / 2 - 20
            
            // Draw background circle
            let backgroundPath = Path { path in
                path.addEllipse(in: CGRect(
                    x: center.x - radius,
                    y: center.y - radius,
                    width: radius * 2,
                    height: radius * 2
                ))
            }
            context.fill(backgroundPath, with: .color(.gray.opacity(0.1)))
            
            // Draw spoke lines
            let categories = ["Salud", "Relaciones", "Finanzas", "Carrera", "Desarrollo", "Espiritualidad"]
            let values = [wheel.health, wheel.relationships, wheel.finances, wheel.career, wheel.personalDev, wheel.spirituality]
            
            for i in 0..<6 {
                let angle = Angle.degrees(Double(i) * 60 - 90)
                let spokeEnd = CGPoint(
                    x: center.x + radius * cos(angle.radians),
                    y: center.y + radius * sin(angle.radians)
                )
                var linePath = Path()
                linePath.move(to: center)
                linePath.addLine(to: spokeEnd)
                context.stroke(linePath, with: .color(.gray.opacity(0.3)), lineWidth: 1)
                
                // Draw value point
                let normalizedValue = Double(values[i]) / 10.0
                let valuePoint = CGPoint(
                    x: center.x + radius * normalizedValue * cos(angle.radians),
                    y: center.y + radius * normalizedValue * sin(angle.radians)
                )
                
                let pointPath = Path { path in
                    path.addEllipse(in: CGRect(
                        x: valuePoint.x - 6,
                        y: valuePoint.y - 6,
                        width: 12,
                        height: 12
                    ))
                }
                context.fill(pointPath, with: .color(.appPrimary))
            }
            
            // Draw connecting shape
            var shapePath = Path()
            for i in 0..<6 {
                let angle = Angle.degrees(Double(i) * 60 - 90)
                let normalizedValue = Double(values[i]) / 10.0
                let point = CGPoint(
                    x: center.x + radius * normalizedValue * cos(angle.radians),
                    y: center.y + radius * normalizedValue * sin(angle.radians)
                )
                
                if i == 0 {
                    shapePath.move(to: point)
                } else {
                    shapePath.addLine(to: point)
                }
            }
            shapePath.closeSubpath()
            context.fill(shapePath, with: .color(.appPrimary.opacity(0.3)))
            context.stroke(shapePath, with: .color(.appPrimary), lineWidth: 2)
        }
    }
}

#Preview {
    NavigationStack {
        WheelOfLifeView()
    }
}
