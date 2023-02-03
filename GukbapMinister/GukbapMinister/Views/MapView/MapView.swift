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
    
    @State var selectedDetent: PresentationDetent = .medium
    private let availableDetents: [PresentationDetent] = [.medium, .large]
    

    
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
                        
                        filterButton
                        
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
                                StoreModalView()
                                Button {
                                    mapViewModel.isShowingSelectedStore.toggle()
                                } label: {
                                    Text("Hi")
                                }

                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 150)
                            .background(Color.white)
                            .padding(30)
                            .offset(y: mapViewModel.isShowingSelectedStore ? 0 : 400)
                            .animation(.easeInOut, value: mapViewModel.isShowingSelectedStore)
//                            .transition(.asymmetric(
//                                insertion: .move(edge: .top),
//                                removal: .move(edge: .bottom))
//                            )
                        }
                        
                    
                }
            }
        }
        //        .sheet(isPresented: $mapViewModel.isShowingSelectedStore, content: {
        //            StoreModalView(selectedDetent: $selectedDetent)
        //                .presentationDetents([.height(200), .large], selection: $selectedDetent)
        //                .presentationDragIndicator(.hidden)
        //
        //        })

        
    }





}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
        // Preview will crash without implementing environmentObject here
            .environmentObject(MapViewModel())
    }
}

// For presenting in a picker
extension PresentationDetent: CustomStringConvertible {
    public var description: String {
        switch self {
        case .medium:
            return "Medium"
        case .large:
            return "Large"
        default:
            return "n/a"
        }
    }
}

