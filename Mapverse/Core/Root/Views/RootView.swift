//
//  RootView.swift
//  Mapverse
//
//  Created by Dave Paiva on 23/05/25.
//

import SwiftUI

struct RootView: View {
    @StateObject var viewModel = RootViewModel()
    
    var body: some View {
        Group{
            if viewModel.userAccessToken?.isEmpty ?? true  {
                LoginView()
            }else{
                MapContainerView()
            }
        }
    }
}

#Preview {
    RootView()
}
