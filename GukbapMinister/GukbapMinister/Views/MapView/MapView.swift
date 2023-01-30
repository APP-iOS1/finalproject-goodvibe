import SwiftUI
import MapKit
import CoreLocation
import CoreLocationUI

struct MapView: View {
    // Command + F -> replace: changes searched word in the file
    @EnvironmentObject private var locationViewModel : LocationViewModel
    @StateObject var locationManager = LocationManager()
    // 필터 버튼을 눌렀을 때 동작하는 모달
    @State var showModal = false
    @State private var marked : Bool = false
    @State private var showingAddMarker = false
    
    // 국밥집 검색창에 들어갈 단어
    @State var searchGukBap : String = ""
    
    // 마커를 클릭했을 때 동작하는 모달
    @State var isPresentedSearchView: Bool = false
    
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
                    
                    Map(coordinateRegion: $locationManager.region,
                        showsUserLocation: true,
                        annotationItems: locationViewModel.locations,
                        annotationContent: { location in
                        MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)) {
                            //print("Place a string : \(location)")
                            
                            LocationMapAnnotationView()
                                .onTapGesture {
                                    //locationViewModel.showNextLocation(location: location)
                                    marked.toggle()
                                    locationViewModel.sheetLocation = location
                                }
                        }
                    })
                    .ignoresSafeArea(edges: .top)
                }
            }
            .sheet(isPresented: $marked, content: {
                StoreModalView(storeLocation: locationViewModel.sheetLocation!)
                    .presentationDetents([.height(200)])
            })
        }
    }
    
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
        // Preview will crash without implementing environmentObject here
            .environmentObject(LocationViewModel())
    }
}
