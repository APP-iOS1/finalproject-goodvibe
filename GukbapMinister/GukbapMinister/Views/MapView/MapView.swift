import SwiftUI
import MapKit
import CoreLocation
import CoreLocationUI

struct MapView: View {
  // Command + F -> replace: changes searched word in the file
  @EnvironmentObject private var mapViewModel: MapViewModel
  @StateObject var locationManager = LocationManager()
  // 필터 버튼을 눌렀을 때 동작하는
  @State var isShowingFilterModal: Bool = false
  
  var body: some View {
    // 지오메트리 리더가 뷰 안에 선언 되어있기 때문에 뷰 만큼의 너비와 높이를 가져옴
    GeometryReader { geo in
      let height = geo.size.height
      let width = geo.size.width
      
      NavigationStack {
        ZStack {
          MapUIView(
            region: $locationManager.region,
            storeAnnotations: $mapViewModel.storeLocationAnnotations,
            selectedStoreAnnotation:
              $mapViewModel.selectedStoreAnnotation,
            isSelected: $mapViewModel.isShowingSelectedStore
          )
          .ignoresSafeArea(edges: .top)
          
          VStack {
            SearchBarButton()
            
            mapFilter
            
            locationButton(width: width, height: height)
            
            Spacer()
          }
          
          VStack {
            if mapViewModel.isShowingSelectedStore {
              Button {
                mapViewModel.isShowingSelectedStore.toggle()
              } label: {
                Spacer()
                  .frame(maxWidth: .infinity, maxHeight: .infinity)
              }
            } else {
              Spacer()
            }
            
            HStack{
              StoreModalView(store: mapViewModel.selectedStore ?? .test
              )
              Button {
                mapViewModel.isShowingSelectedStore.toggle()
              } label: {
                Text("")
              }
              
            }
            .padding(.top, 10)
            .frame(maxWidth: .infinity)
            .frame(height: 150)
            .background(RoundedRectangle(cornerRadius: 25).fill(Color.white))
            .overlay {
              RoundedRectangle(cornerRadius: 25)
                .stroke(Color.mainColor)
            }
            .padding(25)
            .offset(y: mapViewModel.isShowingSelectedStore ? 0 : 400)
            .animation(.easeInOut, value: mapViewModel.isShowingSelectedStore)
          }
        }
      }
    }
  }
  
}

struct MapView_Previews: PreviewProvider {
  static var previews: some View {
    MapView()
    // Preview will crash without implementing environmentObject here
      .environmentObject(MapViewModel())
  }
}



// TODO: 깍두기 지수 바텀 패딩, 주소 깍두기 지수 leading, 깍두기 지수 소수점 버리기 -> 첫번쨰 소수젓 이하 버리기, 갈색 frame 선 일자 혹은 흰색으로 조정, 깍두기 지수라는 말 지우기, 모달이랑 최대한 비슷하게 만들기
