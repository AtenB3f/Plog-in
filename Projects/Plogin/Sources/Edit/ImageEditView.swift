//
//  ImageEditView.swift
//  Plogin
//
//  Created by AtenB on 6/6/25.
//  Copyright © 2025 Plli. All rights reserved.
//

import SwiftUI

struct ImageEditView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AssetViewModel
    
    var body: some View {
        NavigationView {
            GeometryReader { proxy in
                VStack {
                    Button {
                        dismiss()
                        print(viewModel.viewPath)
                    } label: {
                        Text("뒤로가기")
                    }
                }
            }
        }
    }
}
