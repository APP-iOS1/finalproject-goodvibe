import SwiftUI
import MapKit



struct MapView: View {
    @EnvironmentObject private var vm : LocationViewModel
    
    
  // 국밥집 검색창에 들어갈 단어
  @State var searchGukBap : String = ""
  // 필터 버튼을 눌렀을 때 동작하는 모달
  @State private var showModal = false
  // 마커를 클릭했을 때 동작하는 모달
  @State private var marked : Bool = false
  @State private var marked2 : Bool = false
  
  @State private var showingAddMarker = false
    

  
  var body: some View {
    NavigationStack {
      ZStack {
        VStack {
          HStack{
            VStack {
              HStack {
                Image(systemName: "magnifyingglass")
                  .foregroundColor(.secondary)
                  .padding(.leading, 15)
                TextField("국밥집 검색",text: $searchGukBap)
              }
              .frame(width: 280, height: 50)
              .background(Capsule().fill(Color.white))
              .overlay {
                Capsule()
                  .stroke(.yellow)
              }
            }
            
            Spacer()
            
            Button{
              // TODO - 검색 확인을 눌렀을 때 검색 실행
              
            } label: {
              Text("확인")
                .foregroundColor(.white)
            }
            .frame(width: 65, height: 50)
            .background(.yellow)
            .cornerRadius(25)
          }
          .padding(.horizontal, 18)
          
          HStack{
            Button{
              self.showModal = true
            } label: {
              Text(Image(systemName: "slider.horizontal.3")).foregroundColor(.gray) + Text("필터")
                .foregroundColor(.gray)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(Capsule().fill(Color.white))
            .overlay {
              Capsule()
                .stroke(.yellow)
            }
            .sheet(isPresented: self.$showModal) {
              MapCategoryModalView()
                .presentationDetents([.height(335)])
            }
            
            Spacer()
            
          }
          .padding(.horizontal, 18)
          
            
            Map(coordinateRegion: $vm.mapRegion,
                annotationItems: vm.locations,
                annotationContent: { location in
                MapAnnotation(coordinate: location.coordinate) {
                    //print("Place a string : \(location)")
                    
                    Image("Ddukbaegi.fill")
                      .resizable()
                      .aspectRatio(contentMode: .fit)
                      .frame(width: 20)
                      .foregroundColor(.red)
                        .onTapGesture {
                            //vm.showNextLocation(location: location)
                            marked.toggle()
                            vm.sheetLocation = location
                        }

                }
            })
            
          // 위치를 이동하는 버튼 - 비활성화
          //                Button {
          //                    locationManager.requestLocation()
          //                    //coordination = (35.1379222, 129.05562775)
          //                    if let location = locationManager.location {
          //                        //Text("Your location: \(location.latitude), \(location.longitude)")
          //                        coordination = (location.latitude, location.longitude)
          //                    }
          //                } label: {
          //                    Text("내 위치 이동")
          //                }
          //                .frame(height: 44)
          //                .padding()
          //
          //
          //                Button(action: {coordination = (35.1379222, 129.05562775)}) {
          //                    Text("부산으로 위치 이동")
          //                }
          //
          //                Button(action: {coordination = (37.503693, 127.053033)}) {
          //                    Text("서울 아무 지역으로 위치 이동")
          //                }
          Spacer()
        }
        .zIndex(1)

        
      }
    }
    .sheet(item: $vm.sheetLocation, onDismiss : nil) { location in
        StoreModalView(storeLocation: location)
            .presentationDetents([.height(200)])
    }
  }
}

struct MapView_Previews: PreviewProvider {
  static var previews: some View {
    MapView()
  }
}
