//
//  SettingsView.swift
//  SwipeHanja
//
//  Created by Anto-Yang on 5/4/24.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.presentationMode) var presentationMode

    ///학습 시작시에 항상 랜덤 섞기를 할지 여부
    @State var randomMix: Bool
    ///진도 초기화를 실행할 클로저
    var resetProgressClosure: (()->Void)?
    
    init(resetProgressClosure: @escaping () -> Void) {
        self.randomMix = AppSetting.randomMix
        self.resetProgressClosure = resetProgressClosure
        
    }
    var body: some View {
        
        VStack {
            HStack(alignment: .center) {
                Spacer()
                Text("설정")
                    .font(.headline)
                    .padding()
                Spacer()
            }
            .overlay(alignment:.topLeading ) {
                closeButton
            }
            
            List {
                Section {
                    
                    Toggle("학습 시작시에 항상 랜덤섞기", isOn: $randomMix)
                        .onChange(of: randomMix) { newValue in
                            AppSetting.randomMix = newValue
                        }
                    
                    Button(action: {
                        resetProgressClosure?()
                    }, label: {
                        Text("학습 진도 초기화")
                    })

                }
                
                
                Section {
                    Button(action: {
                        EmailHelper.shared
                            .sendEmail(subject: "[Swipe 한자] 문의 & 피드백",
                                       body:
                                   """
                                   Version: \(AppStatus.fullVersion)
                                   Device: \(AppStatus.getModelName())
                                   OS: \(AppStatus.getOsVersion())
                                   
                                   """,
                                       to: "anto.wg.yang@gmail.com"  )
                    }, label: {
                        Text("Help & Feedback")
                    })
                }
                
                Section {
                    HStack(alignment: .center) {
                        Text("Version")
                        Spacer()
                        Text(AppStatus.fullVersion)
                        
                    }
                }
                
            }
        }
        //        .navigationTitle("설정")
    }
    
    private var closeButton: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Image(systemName: "xmark")
                .font(.headline)
        }
        .buttonStyle(.bordered)
        .clipShape(Circle())
        .tint(.purple)
        .padding()
    }
}

#Preview {
    SettingsView(resetProgressClosure: {})
}
