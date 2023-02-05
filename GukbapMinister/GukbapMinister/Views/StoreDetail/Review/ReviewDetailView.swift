//
//  ReviewDetailView.swift
//  GukbapMinister
//
//  Created by 이원형 on 2023/01/20.
//

import SwiftUI

struct ReviewDetailView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @StateObject var reviewViewModel: ReviewViewModel
    let selectedtedReview: Review
    //
    //    init(){
    //        UIScrollView.appearance().bounces = false
    //    }
    var body: some View {
        ZStack{
            Color.black
                .ignoresSafeArea()
            VStack{
                
                
                if let images = selectedtedReview.images{
                 
                    
                    
                    HStack{
                        Text(selectedtedReview.createdDate)
                            .fontWeight(.light)
                            .foregroundColor(.white)
                        
                    }
                    .padding(.top,5)
                    TabView() {
                        ForEach(images, id: \.self) { imageKey in
                            if let image = reviewViewModel.reviewImage[imageKey] {
                                
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                            }
                        }//ForEach
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode:.never))
                    .frame(width: UIScreen.main.bounds.width)
                    .padding(.top,-80)
                }
                VStack{
                    
                    Text(selectedtedReview.reviewText)
                        .font(.title3)
                    
                }
                .foregroundColor(.white)
                Spacer()
            }
        }
        //.navigationTitle(Text("/\(selectedtedReview.images!.count)"))
        .navigationBarTitle("Try it!", displayMode: .inline)
                    .background(NavigationConfigurator { nc in
                        nc.navigationBar.barTintColor = .blue
                        nc.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white]
                    })
        
        .navigationBarTitleDisplayMode(.inline)
        
        .toolbar(.hidden, for:.tabBar)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "arrow.backward")
                            .tint(.white)
                    }
                }
            }
    }
       
}
struct NavigationConfigurator: UIViewControllerRepresentable {
    var configure: (UINavigationController) -> Void = { _ in }

    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> UIViewController {
        UIViewController()
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationConfigurator>) {
        if let nc = uiViewController.navigationController {
            self.configure(nc)
        }
    }

}
//struct ReviewDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReviewDetailView()
//    }
//}
