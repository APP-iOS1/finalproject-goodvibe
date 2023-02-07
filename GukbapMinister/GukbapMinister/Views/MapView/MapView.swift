import SwiftUI
import MapKit
import CoreLocation
import CoreLocationUI

struct MapView: View {

    @Environment(\.colorScheme) var scheme
    // Command + F -> replace: changes searched word in the file
    @EnvironmentObject var storesViewModel: StoresViewModel
    @EnvironmentObject var mapViewModel: MapViewModel
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
                    .ignoresSafeArea(edges: [.top, .horizontal])
                    
                    VStack {
                        SearchBarButton()
                        mapFilter
                        Spacer()
                    }
                    
                    StoreReportButton()
                        .offset(x: width * 0.5 - 35 - 12)
                    
                    Text("\(mapViewModel.isShowingSelectedStore ? "true" : "false" )")
                 
                    VStack {
                        if mapViewModel.isShowingSelectedStore {
                            Button {
                                mapViewModel.isShowingSelectedStore.toggle()
                            } label: {
                                Spacer()
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                            }
                            .background(.green)
                        } else {
                            Spacer()
                                .background(.red)
                        }

                        StoreModalView(store: mapViewModel.selectedStore ?? .test)
                        .padding(25)
                        .offset(y: mapViewModel.isShowingSelectedStore ? 0 : 400)
                        .animation(.easeInOut, value: mapViewModel.isShowingSelectedStore)
                    }
                    
                }
            }

        }
        
      }

}

//struct MapView_Previews: PreviewProvider {
//
//    static var previews: some View {
//        MapView(storesViewModel: StoresViewModel())
//        // Preview will crash without implementing environmentObject here
//            .environmentObject(MapViewModel(storeLocations: [.test]))
//    }
//
//}
