//
//  DetailView.swift
//  GukbapMinister
//
//  Created by Martin on 2023/01/17.
//

import SwiftUI

struct DetailView: View {
    let colors: [Color] = [.yellow, .green, .red]
    
    @State private var text: String = ""
    
    var body: some View {
        GeometryReader { geo in
            let width: CGFloat = geo.size.width
            
            
            
            ScrollView {
                VStack(alignment: .leading){
                    
                    VStack(alignment: .leading){
                        Text("농민백암순대")
                            .font(.title.bold())
                            .padding(.bottom, 8)
                        Text("서울 강남구 역삼로3길 20-4")
                    }
                    .padding(15)
                    
                    TabView {
                        ForEach(Array(colors.enumerated()), id: \.offset) { index, color in
                            
                            VStack {
                                Text("사진\(index + 1)")
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: width * 0.8)
                            .background(color)
                        }
                    }
                    .frame(height:width * 0.8)
                    .tabViewStyle(.page(indexDisplayMode: .always))
                    .padding(.bottom)
                    
                    //Store.description
                    Text("수요미식회에서 인정한 선릉역 찐 맛집!")
                        .padding(.horizontal, 15)
                        .padding(.bottom, 30)
                    
                    Divider()
                    
                    VStack(alignment: .leading) {
                        Text("메뉴")
                            .font(.title2.bold())
                            .padding(.bottom)
                        
                        HStack{
                            Text("국밥")
                            Spacer()
                            Text("9,000원")
                        }
                        .padding(.bottom, 5)
                        
                        HStack{
                            Text("술국")
                            Spacer()
                            Text("18,000원")
                        }
                        .padding(.bottom, 5)
                        
                        HStack{
                            Text("수육")
                            Spacer()
                            Text("32,000원")
                        }
                        .padding(.bottom, 5)
                        
                        HStack{
                            Text("토종순대")
                            Spacer()
                            Text("12,000원")
                        }
                        .padding(.bottom, 5)
                    }
                    .padding(15)
                    
                    Divider()
                    
                    NaverMapView(coordination: (37.503693, 127.053033))
                        .frame(height: 260)
                        .padding(.vertical, 15)
                    
                    
                        VStack{
                            Text("테디베어님의 후기를 남겨주세요")
                                .fontWeight(.bold)
                                .padding(.vertical)
                            HStack {
                                ForEach(0..<5) { _ in
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.yellow)
                                }
                            }
                        }
                        .padding(.vertical, 15)
                        
                        
                    Group {
                        //사진없는 댓글
                        VStack(alignment: .leading) {
                            HStack {
                                Text("써니")
                                    .font(.headline)
                                    .padding(.bottom, 10)
                                Spacer()
                                Text("2023.01.17")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                
                            }
                            //별점
                            HStack(spacing: 0){
                                ForEach(0..<5) { _ in
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.yellow)
                                        .font(.caption)
                                        .padding(.trailing, 2)
                                }
                            }
                            .padding(.bottom, 15)
                            
                            Text("여기 외 않와? 꼭 가세요")
                                .font(.footnote)
                        }
                        
                        //사진있는 댓글
                        VStack(alignment: .leading) {
                            HStack {
                                Text("써니")
                                    .font(.headline)
                                    .padding(.bottom, 10)
                                Spacer()
                                Text("2023.01.17")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                
                            }
                            
                            //별점
                            HStack(spacing: 0){
                                ForEach(0..<5) { _ in
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.yellow)
                                        .font(.caption)
                                        .padding(.trailing, 2)
                                }
                            }
                            .padding(.bottom, 15)
                            
                            Text("여기 외 않와? 꼭 가세요")
                                .font(.footnote)
                            
                            ScrollView(.horizontal) {
                                LazyHStack {
                                    ForEach(0..<5) { index in
                                        Text("\(index)")
                                            .frame(width: 100, height: 100)
                                            .background(.yellow)
                                    }
                                }
                            }
                            .frame(height:100)
                            
                        }
                        
                        //사진없는 댓글
                        VStack(alignment: .leading) {
                            HStack {
                                Text("써니")
                                    .font(.headline)
                                    .padding(.bottom, 10)
                                Spacer()
                                Text("2023.01.17")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                
                            }
                            //별점
                            HStack(spacing: 0){
                                ForEach(0..<5) { _ in
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.yellow)
                                        .font(.caption)
                                        .padding(.trailing, 2)
                                }
                            }
                            .padding(.bottom, 15)
                            
                            Text("여기 외 않와? 꼭 가세요")
                                .font(.footnote)
                        }
                    }
                    
                    
                }
                .padding(.bottom, 200)
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView()
    }
}
