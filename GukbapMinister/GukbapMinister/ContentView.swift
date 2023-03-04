//
//  ContentView.swift
//  GukbapMinister
//
//  Created by Martin on 2023/01/16.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: UserViewModel
    

    
    @Binding var selectedViewIndex: Int
    
   var body: some View {
    
           switch selectedViewIndex{
           case 0:
               SplashView()
               
           case 1:
               SplashView2()

               
           case 2:
              SplashView3()
                  
               
           default :
               EmptyView()
           }
       

    }
}


//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView().environmentObject(UserViewModel())
//
//    }
//}




