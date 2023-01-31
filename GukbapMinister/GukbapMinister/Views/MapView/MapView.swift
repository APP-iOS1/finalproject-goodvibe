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
    @State private var isShowingSelectedStore: Bool = false
    
    // 국밥집 검색창에 들어갈 단어
    @State var searchString: String = ""
    
    // 검색 텍스트필드 클릭했을 때 동작하는 모달
    @State var isShowingSearchView: Bool = false
    
    var body: some View {
        // 지오메트리 리더가 뷰 안에 선언 되어있기 때문에 뷰 만큼의 너비와 높이를 가져옴
        GeometryReader { geo in
            let height = geo.size.height
            let width = geo.size.width
            
            NavigationStack {
                ZStack {
                    VStack {
                        search
                            .padding(.horizontal, 18)
                        
                        filterButton
                        
                        locationButton(width: width, height: height)
                        
                        Spacer()
                    }
                    .zIndex(1)
                    
                    MapUIView(storeAnnotations: $mapViewModel.storeLocationAnnotations, region: $locationManager.region, isSelected: $isShowingSelectedStore)
                    .ignoresSafeArea(edges: .top)
                }
            }
            .sheet(isPresented: $isShowingSelectedStore, content: {
               // StoreModalView(storeLocation: mapViewModel.selectedStore)
                  //  .presentationDetents([.height(200)])
            })
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
