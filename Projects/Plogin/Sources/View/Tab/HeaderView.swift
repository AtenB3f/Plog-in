//
//  HeaderView.swift
//  IPBox
//
//  Created by AtenB on 4/15/25.
//  Copyright © 2025 eone. All rights reserved.
//

import SwiftUI
import Design

struct HeaderView: View {
    @EnvironmentObject var manager: AppManager
    let vpnManager = VPNManager.shared
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            Image("App_Full_Logo")
                .resizable()
                .aspectRatio(61.5/22, contentMode: .fit)
                .frame(height: 22)

            Spacer()

            Button {
                manager.pushPopup(.logout {
                    Task.detached {
                        await MainActor.run {
                            self.manager.pushPopup(.indicator)
                        }
                        await self.vpnManager.stopAndRemoveVPNAll()
                        await MainActor.run {
                            self.manager.logout()
                            self.manager.pushPopup()
                        }
                    }
                })
            } label: {
                HStack(spacing: 0) {
                    Text(manager.username)
                        .logoutButtonText(true)
                        .foreground(.Gray.gray60)

                    Text(" 님")
                        .logoutButtonText()
                        .foreground(.Gray.gray60)
                        .padding(.trailing, 6)

                    Image("Logout")
                        .resizable()
                        .frame(width: 12, height: 12)
                }
                .padding(.horizontal)
                .padding(.vertical, 5)
                .background(Color.Brand.primaryBase)
                .cornerRadius(30)
            }
            .basicButtonStyle(.basic)
        }
        .padding(.vertical)
        .padding(.horizontal, 20)
        .background(Color.white)
    }
}

//#Preview {
//    HeaderView(id: "eonecommon")
//}
