//
//  PolicyView.swift
//  GukbapMinister
//
//  Created by 김요한 on 2023/02/13.
//

import SwiftUI

struct PolicyView: View {
    @Environment(\.dismiss) var dismiss
    
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    Section(content: {
                        NavigationLink {
                            ServiceTermsView()
                        } label: {
                            Text("서비스 이용약관")
                        }
                    })
                    
                    Section(content: {
                        NavigationLink {
                            PrivacyPolicyView()
                        } label: {
                            Text("개인정보 처리 방침")
                        }
                    })
                    
                    Section(content: {
                        NavigationLink {
                            LocationBasedServicePolicyView()
                        } label: {
                            Text("위치기반 서비스 이용약관")
                        }
                    })
                    
                    Section(content: {
                        NavigationLink {
                            CommunityGuideLineView()
                        } label: {
                            Text("커뮤니티 가이드라인")
                        }
                    })
                    
                    Section(content: {
                        NavigationLink {
                            OpenSourceView()
                        } label: {
                            Text("오픈소스")
                        }
                    })
                    
                    Text("버전 정보 1.0.0")
                    
                }
                
                Button {
                    dismiss()
                } label: {
                    Text("뒤로")
                }
                
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("앱 정보")
        }
        
        
    }
}

struct PolicyView_Previews: PreviewProvider {
    static var previews: some View {
        PolicyView()
    }
}
