import SwiftUI
import MapKit
import CoreLocation
import CoreLocationUI




final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    
    @Published var location: CLLocationCoordinate2D?
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 42.0422448, longitude: -102.0079053),
        span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
    )
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func requestLocation() {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        DispatchQueue.main.async {
            self.location = location.coordinate
            self.region = MKCoordinateRegion(
                center: location.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
            )
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //Handle any errors here...
        print (error)



    }
}



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
    
    @StateObject var locationManager = LocationManager()
    

    
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
                                    .onTapGesture {
                                        self.isPresentedSearchView.toggle()
                                        UIView.setAnimationsEnabled(false)
                                    }
                                    .fullScreenCover(isPresented: $isPresentedSearchView) {
                                        SearchView()
                                    }
                                    .onAppear {
                                        UIView.setAnimationsEnabled(true)
                                    }

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

                        .padding(.horizontal, 18)
                        .offset(y: -30)
                        
                        
                        Spacer()
                        
                        LocationButton {
                            locationManager.requestLocation()
                        }
                        .labelStyle(.iconOnly)
                        .cornerRadius(30)
                        .font(.title3)
                        .frame(width: 100, height: 100)
                        .symbolVariant(.fill)
                        .foregroundColor(.white)
                        .offset(x: 100, y: 450)
                        

                        
                        Spacer()
                        
                    }

                    Spacer()
                }
                .zIndex(1)
                

                Map(coordinateRegion: $locationManager.region,
                    showsUserLocation: true,
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
                }).ignoresSafeArea(edges: .top)

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
