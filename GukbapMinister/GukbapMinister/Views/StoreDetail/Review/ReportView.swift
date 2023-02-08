
//  ReportView.swift
//  GukbapMinister
//
//  Created by 이원형 on 2023/02/06.


import SwiftUI

struct ReportView: View {
    @Binding var isshowingReportSheet : Bool
    @Binding var selectedReportButton : String
    @Binding var reportEnter : Bool
   
    @State var reportText = ""

    var Content = [
        "음란성, 욕설등 부적절한 내용",
        "부적절한 홍보 또는 광고",
        "주문과 관련없는 사진 게시",
        "개인정보 유출 위험",
        "리뷰 작성 취지에 맞지 않는 애용(복사글 등)",
        "저작권 도용 의심(사진 등)",
        "기타(아래 내용 작성)",
    ]
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack(alignment: .leading){
                    Spacer()
                    HStack{
                        Text("리뷰를 신고하는")
                        
                    }
                    .font(.system(size:18))
                    .fontWeight(.semibold)
                    HStack{
                        Text("이유를 알려주세요!")
                        
                    }
                    .font(.system(size:18))
                    .fontWeight(.semibold)
                    
                    HStack{
                        Text("타당한 근거 없이 신고된 내용은 관리자 확인후 반영되지 않을 수 있습니다.")
                        
                    }
                    .font(.system(size:11))
                    .foregroundColor(.secondary)
                    .padding(.top,5)
                    .padding(.bottom,10)
                    
                    VStack(alignment: .leading, spacing: 30){
                        ForEach(Array(Content.enumerated()), id: \.offset) { count, index in
                            //
                            //                ForEach(Content, id:\.self){ index in
                            Button(action:{
                                self.selectedReportButton = index
                            }){
                                HStack{
                                    Text(index).font(.system(size:16))
                                    Spacer()
                                    ZStack{
                                        Circle().fill(self.selectedReportButton == index ? Color("AccentColor") : Color.black.opacity(0.2)).frame(width: 18,height: 18)
                                        
                                        if self.selectedReportButton == index {
                                            Circle().stroke(Color("AccentColor"), lineWidth: 2)
                                                .frame(width: 25,height: 25)
                                        }
                                        
                                    }
                                }
                                .foregroundColor(.black)
                            }
                        }
                        TextField("신고사유를 작성해주세요", text: $reportText, axis: .vertical)
                            .font(.system(size:15))
                            .lineLimit(4...)
                            .textFieldStyle(.roundedBorder)
                            .opacity(1)
                            .animation(.easeInOut, value:reportText )
                            .padding(10)
                        
                        
                    }
                    
                    Spacer()
                    
                    Button(action:{
                        self.reportEnter.toggle()
                    }){
                        Text("신고하기")
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: Screen.maxWidth)
                            .bold()
                    }
                    
                    
                    .background(
                        self.selectedReportButton != "" ?
                        
                        Color("AccentColor") : Color("lightGray"))
                    
                    //                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .clipShape(Capsule())
                    .disabled(self.selectedReportButton != "" ? false : true)
                    .padding(EdgeInsets(top: 5, leading: 20, bottom: 0, trailing: 20))
                    
                }}
            .navigationTitle("리뷰 신고하기")
            .navigationBarTitleDisplayMode(.inline)
            
            .animation(.default,value:selectedReportButton)
            .padding()

            .navigationBarBackButtonHidden(true)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button(action: {
                                    isshowingReportSheet.toggle()
                                }) {
                                    Image(systemName: "xmark")
                                        .foregroundColor(Color.black)
            
                                }
                            }
            }
        }
      
        
    }
    
    
    
}






//struct ReportView_Previews: PreviewProvider {
//    @State static var selectedReportButton = ""
//    @State static var show = false
//    static var previews: some View {
//        ReportView( selectedReportButton: self.$selectedReportButton,show: self.$show)
//    }
//}
