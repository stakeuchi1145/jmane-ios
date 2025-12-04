//
//  ContentView.swift
//  jmane-ios
//
//  Created by Shin Takeuchi on 2025/12/03.
//

import SwiftUI
import Combine

// 📝 フォーカス可能なフィールドを表す
enum FocusableField: String, Hashable {
    case email
    case password
}

struct LoginView: View {
    @ObservedObject private var viewModel: LoginViewModel = LoginViewModel.shared
    
    @State private var isVisiblePassword: Bool = true
    @State private var isError: Bool = false
    @State private var showErrorMessage: String = ""
    @State private var isLoading: Bool = false
    @FocusState private var focusedField: FocusableField?
    @State private var isAlert: Bool = false
    @State private var showAlertMessage: String = ""

    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                Image("icon")
                    .resizable()
                    .frame(width: 300, height: 300)
                    .padding(.top, 4)

                VStack {
                    VStack {
                        Text("メールアドレス")
                            .font(.system(size: 18))
                            .fontWeight(.bold)
                            .foregroundColor(Color(hex:"1A1A1A"))
                            .frame(maxWidth: .infinity, alignment: Alignment.leading)

                        TextField("入力してください。", text: $viewModel.email)
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                            .frame(maxWidth: .infinity, maxHeight: 40)
                            .font(.system(size: 20))
                            .padding(8)
                            .focused($focusedField, equals: .email)
                            .submitLabel(.next)
                            .onSubmit {
                                focusedField = .password
                            }
                            .overlay {
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(.gray, lineWidth: 1)
                            }
                            .contentShape(.rect)
                            .ignoresSafeArea(.keyboard, edges: .bottom)
                    }
                    .padding()

                    VStack {
                        Text("パスワード")
                            .font(.system(size: 18))
                            .fontWeight(.bold)
                            .foregroundColor(Color(hex:"1A1A1A"))
                            .frame(maxWidth: .infinity, alignment: Alignment.leading)

                        ZStack {
                            ZStack {
                                if isVisiblePassword {
                                    SecureField("入力してください。", text: $viewModel.password)
                                } else {
                                    TextField("入力してください。", text: $viewModel.password)
                                }
                            }
                            .autocapitalization(.none)
                            .frame(maxWidth: .infinity, maxHeight: 40)
                            .font(.system(size: 20))
                            .padding(8)
                            .focused($focusedField, equals: .password)
                            .submitLabel(.done)
                            .onSubmit {
                                focusedField = nil
                            }
                            .overlay {
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(.gray, lineWidth: 1)
                            }
                            .contentShape(.rect)
                            .ignoresSafeArea(.keyboard, edges: .bottom)

                            Button(action: {
                                isVisiblePassword = !isVisiblePassword
                            }) {
                                Image(systemName: isVisiblePassword ? "eye" : "eye.slash")
                                    .foregroundColor(.black)
                                    .padding(.trailing)
                            }
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding()

                    Button(action: { login() }) {
                        HStack {
                            Text("Log in")
                                .font(.system(size: 24))
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding()

                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(.circular)
                                    .tint(Color.white)
                                    .cornerRadius(8)
                                    .scaleEffect(1.2)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .background(isLoading ? .gray : Color(hex:"0E2A52"))
                    .cornerRadius(50)
                    .disabled(isLoading)
                    .overlay {
                        RoundedRectangle(cornerRadius: 50)
                            .stroke(.gray, lineWidth: 1)
                    }
                    .padding()

                    if isError {
                        Text("\(showErrorMessage)")
                            .font(.system(size: 18))
                            .foregroundColor(Color(hex:"B0473C"))
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                    }
                }
                .frame(maxWidth: .infinity)
                .background(.white)
                .padding(.horizontal, 4)
                .compositingGroup()
                .shadow(color: .gray.opacity(0.1), radius: 0, x: 2, y: 4)

                Spacer()

                Text("v1.0.0")
                    .font(.system(size: 18))
                    .foregroundColor(.gray)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding()
        .background(Color(hex:"F7F8FA"))
        .ignoresSafeArea()
        .onTapGesture {
            focusedField = nil
        }
        .alert("", isPresented: $isAlert) {
        } message: {
            Text("\(showAlertMessage)")
        }
    }
    
    func login() {
        Task {
            isError = false

            if !viewModel.validEmail() || !viewModel.validPassword() {
                isError = true
                showErrorMessage = "メールアドレスまたはパスワードが正しくありません。"
                return
            }
            
            if await viewModel.login() {
                isAlert = true
                showAlertMessage = "ログインに成功しました。"
            } else {
                isError = true
                showErrorMessage = "ログインに失敗しました。"
            }
        }
    }
}

#Preview {
    LoginView()
}
