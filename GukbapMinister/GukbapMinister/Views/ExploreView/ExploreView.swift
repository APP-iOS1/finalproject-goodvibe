//
//  ExploreView.swift
//  GukbapMinister
//
//  Created by Martin on 2023/01/16.
//

import SwiftUI

struct ExploreView: View {
    @Environment(\.colorScheme) var scheme
    @StateObject var exploreViewModel = ExploreViewModel(stores: [])
    
    @EnvironmentObject var storesViewModel: StoresViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    
    @State var isLoading = true
    
    var body: some View {
        NavigationStack{
            SearchBarButton()
                .padding(.bottom, 5)
                .background(scheme == .light ? .white : .black)
            
            ZStack{
                Color.gray.opacity(scheme == .light ? 0.2 : 0)
                
                VStack{
                    ScrollView{
                        VStack(spacing: 0){
                            ExploreBanner()
                            ExploreCategoryIconsView()
                                .frame(width: UIScreen.main.bounds.width)
                        }
                        .foregroundColor(.black)
                        .fontWeight(.semibold)
                        
                        VStack{
                            // 조회수 순 정렬 뷰
                            ExploreOrderedHScroll(exploreViewModel: exploreViewModel, mode: .hits)
                            // 깍두기 점수 순 정렬 뷰
                            ExploreOrderedHScroll(exploreViewModel: exploreViewModel, mode: .star)
                        }//VStack
                    } //ScrollView
                } //VStack
            } // ZStack
            
        } //NavigationStack
        .redacted(reason: isLoading ? .placeholder : [])
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.isLoading = false
            }
        }
    } // var body
}

