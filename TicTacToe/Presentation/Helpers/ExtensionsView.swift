//
//  ExtensionsView.swift
//  TicTacToe

import SwiftUI

extension View {
    
    func errorAlert(message: Binding<String?>) -> some View {
        let isPresented = Binding<Bool>(
            get: { message.wrappedValue != nil },
            set: { if !$0 { message.wrappedValue = nil } }
        )

        return self.alert(isPresented: isPresented) {
            Alert(
                title: Text("Ошибка"),
                message: Text(message.wrappedValue ?? ""),
                dismissButton: .default(Text("OK")) {
                    message.wrappedValue = nil
                }
            )
        }
    }
}

extension View {
    func formFieldStyle() -> some View {
        self
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(8)
    }

    func formTextField(_ placeholder: String, text: Binding<String>) -> some View {
        TextField(placeholder, text: text)
            .formFieldStyle()
    }
}

extension View {
    func formPasswordField(title: String, text: Binding<String>, isHidden: Binding<Bool>) -> some View {
        HStack {
            Group {
                if isHidden.wrappedValue {
                    SecureField(title, text: text)
                } else {
                    TextField(title, text: text)
                }
            }
            .formFieldStyle()

            Button { isHidden.wrappedValue.toggle() } label: {
                Image(systemName: isHidden.wrappedValue ? "eye.slash" : "eye")
                    .foregroundColor(.gray)
            }
        }
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
}

extension ViewState {
    var color: Color {
        switch self {
        case .yourTurn: return .yellow
        case .waitingForPlayers: return .orange
        default: return .gray
        }
    }
}
