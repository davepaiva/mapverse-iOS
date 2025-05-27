import SwiftUI

struct AuthCodeInputView: View{
    @ObservedObject var viewmodel: AuthViewModel
    
    var body: some View{
        NavigationView(){
            VStack(spacing: 20){
                Text("Enter Authorization Code")
                    .font(.headline)
                Text("Please enter the authorzation code that was shown in Open Street Maps")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                TextField("Authorization Code", text: $viewmodel.authCode)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                Button(action: {
                    Task{
                        await viewmodel.handleExchangeCodeForAuthToken()
                    }
                }) {
                    Text("Sumbit")
                        .symbolEffect(.bounce, value: viewmodel.isAuthenticating)
                }
                .modifier(ButtonViewModifier(isLoading: viewmodel.isAuthenticating))
            }
        }
        .padding()
        .navigationBarTitle("Authorization Code", displayMode: .inline)
        .navigationBarItems(trailing: Button("Cancel"){
            viewmodel.cancelAuthentication()
        })
    }
}


#Preview {
    AuthCodeInputView(viewmodel: AuthViewModel())
}
