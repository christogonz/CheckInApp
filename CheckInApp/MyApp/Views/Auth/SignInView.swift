//
//  LoginView.swift
//  CheckInApp
//
//  Created by Christopher Gonzalez on 2025-04-14.
//

import SwiftUI

struct SignInView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var isRegistering = false

    var body: some View {
        VStack(spacing: 20) {
            Text(isRegistering ? "Sign Up" : "Sign In")
                .font(.largeTitle)
                .fontWeight(.bold)

            if isRegistering {
                TextField("First Name", text: $firstName)
                    .padding()
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 10))

                TextField("Last Name", text: $lastName)
                    .padding()
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }

            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .textContentType(.emailAddress)
                .autocapitalization(.none)
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 10))

            SecureField("Password", text: $password)
                .textContentType(.password)
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 10))

            if let errorMessage = authVM.errorMessage, !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.footnote)
            }

            Button(action: {
                if isRegistering {
                    authVM.register(email: email, password: password, firstName: firstName, lastName: lastName)
                } else {
                    authVM.signIn(email: email, password: password)
                }
            }) {
                Text(isRegistering ? "Register" : "Sign In")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .foregroundStyle(.black)
                    .fontWeight(.semibold)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }

            Button(action: {
                withAnimation {
                    isRegistering.toggle()
                }
            }) {
                if isRegistering {
                    HStack {
                        Text("Already have an account?")
                            .font(.footnote)
                            .foregroundStyle(Color.text)
                        Text("Sign In")
                            .font(.footnote)
                            .foregroundStyle(Color.accentColor)
                    }
                } else {
                    HStack {
                        Text("Don't have an account?")
                            .font(.footnote)
                            .foregroundStyle(Color.text)
                        Text("Sign Up")
                            .font(.footnote)
                            .foregroundStyle(Color.accentColor)
                    }
                }
            }
            .padding(.top, 5)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background)
    }
}

#Preview {
    SignInView()
        .environmentObject(AuthViewModel())
}
