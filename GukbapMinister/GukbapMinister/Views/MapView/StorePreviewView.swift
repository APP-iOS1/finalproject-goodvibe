//
//  StorePreviewView.swift
//  GukbapMinister
//
//  Created by TEDDY on 2/1/23.
//

import SwiftUI

struct StorePreviewView: View {
  
  var storeLocation : Store
  @EnvironmentObject var vm: StoreViewModel
  
  var body: some View {
    // Command + click -> Show SwiftUI Inspector
    HStack(alignment: .bottom, spacing: 0) {
      VStack(alignment: .leading, spacing: 16) {
        imageSection
        titleSection
      }
      
      VStack(spacing: 8) {
        learnMoreButton
        nextButton
      }
    }
    .padding(20)
    .background(
      RoundedRectangle(cornerRadius: 10)
        .fill(.ultraThinMaterial)
        .offset(y: 65))
    .cornerRadius(10)
  }
}

//struct StorePreviewView_Previews: PreviewProvider {
//  static var previews: some View {
//    ZStack {
//      Color.green.ignoresSafeArea()
//
//            StorePreviewView(location: LocationsDataService.locations.first!)
//        .padding()
//    }
//        .environmentObject(StoreViewModel())
//  }
//}

extension StorePreviewView {
  
  private var imageSection: some View {
    ZStack {
      //      if let imageName = store.imageNames.first {
      //        Image(imageName)
      //          .resizable()
      //          .scaledToFill()
      //          .frame(width: 100, height: 100)
      //          .cornerRadius(10)
      AsyncImage(url: URL(string: storeLocation.storeImages[0])) { image in
        image
          .resizable()
        //.scaledToFit()
      } placeholder: {
        Color.gray.opacity(0.1)
      }
     
    }
  }
//      .padding(6)
//      .background(Color.white)
//   Matches cornerRadius of image
//      .cornerRadius(10)
}

private var titleSection: some View {
  VStack(alignment: .leading, spacing: 4) {
    //      Text(storeLocation.storeName)
    Text("test")
      .font(.title2)
      .fontWeight(.bold)
    Text("test")
      .font(.subheadline)
    //      Text(store.cityName)
    //        .font(.subheadline)
  }
  .frame(maxWidth: .infinity, alignment: .leading)
}

private var learnMoreButton: some View {
  Button {
    
  } label: {
    Text("Learn more")
      .font(.headline)
      .frame(width: 125, height: 35)
  }
  .buttonStyle(.borderedProminent)
}

private var nextButton: some View {
  Button {
    //      vm.nextButtonPressed()
  } label: {
    Text("Next")
      .font(.headline)
      .frame(width: 125, height: 35)
  }
  .buttonStyle(.bordered)
}

//}

