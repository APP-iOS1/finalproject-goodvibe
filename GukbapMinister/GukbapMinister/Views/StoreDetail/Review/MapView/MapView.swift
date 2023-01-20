//
//  MapView.swift
//  GukbapMinister
//
//  Created by Martin on 2023/01/16.
//

//import SwiftUI
//import MapKit
//
//import CoreLocation
//import CoreLocationUI
//
//struct MapView: View {
//    // 초기 좌표값 서울시청
//    @State var coordination: (Double, Double) = (37.503693, 127.053033)
//
//    // 국밥집 검색창에 들어갈 단어
//    @State var searchGukBap : String = ""
//
//    // 필터 버튼을 눌렀을 때 동작하는 모달
//    @State private var showModal = false
//
//    // 마커를 클릭했을 때 동작하는 모달
//    @State private var marked : Bool = false
//    @State private var marked2 : Bool = false
//
//
//    //@StateObject var locationManager = LocationManager()
//
//    var body: some View {
//        NavigationStack {
//            ZStack {
//
//                VStack {
//                    HStack{
//                        VStack {
//                            HStack {
//                                Image(systemName: "magnifyingglass")
//                                    .foregroundColor(.secondary)
//                                    .padding(.leading, 15)
//                                TextField("국밥집 검색",text: $searchGukBap)
//                            }
//                            .frame(width: 280, height: 50)
//                            .background(Capsule().fill(Color.white))
//                            .overlay {
//                                Capsule()
//                                    .stroke(.yellow)
//                            }
//                        }
//
//                        Spacer()
//
//                        Button{
//                            // TODO - 검색 확인을 눌렀을 때 검색 실행
//
//                        } label: {
//                            Text("확인")
//                                .foregroundColor(.white)
//                        }
//                        .frame(width: 65, height: 50)
//                        .background(.yellow)
//                        .cornerRadius(25)
//                    }
//                    .padding(.horizontal, 18)
//
//                    HStack{
//                        Button{
//                            self.showModal = true
//                        } label: {
//                            Text(Image(systemName: "slider.horizontal.3")).foregroundColor(.gray) + Text("필터")
//                                .foregroundColor(.gray)
//                        }
//                        .padding(.horizontal, 10)
//                        .padding(.vertical, 5)
//                        .background(Capsule().fill(Color.white))
//                        .overlay {
//                            Capsule()
//                                .stroke(.yellow)
//                        }
//                        .sheet(isPresented: self.$showModal) {
//                            MapCategoryModalView()
//                                .presentationDetents([.height(335)])
//                        }
//
//
//                        Spacer()
//
//                    }
//                    .padding(.horizontal, 18)
//
//                    // 위치를 이동하는 버튼 - 비활성화
//                    //                Button {
//                    //                    locationManager.requestLocation()
//                    //                    //coordination = (35.1379222, 129.05562775)
//                    //                    if let location = locationManager.location {
//                    //                        //Text("Your location: \(location.latitude), \(location.longitude)")
//                    //                        coordination = (location.latitude, location.longitude)
//                    //                    }
//                    //                } label: {
//                    //                    Text("내 위치 이동")
//                    //                }
//                    //                .frame(height: 44)
//                    //                .padding()
//                    //
//                    //
//                    //                Button(action: {coordination = (35.1379222, 129.05562775)}) {
//                    //                    Text("부산으로 위치 이동")
//                    //                }
//                    //
//                    //                Button(action: {coordination = (37.503693, 127.053033)}) {
//                    //                    Text("서울 아무 지역으로 위치 이동")
//                    //                }
//                    Spacer()
//                }
//                .zIndex(1)
//
//
//                // TODO - 전체화면 꽉 채우기
//                // 요소 하나만 수정하면 구현될 예상
//                NaverMapView(coordination: coordination, marked: $marked, marked2: $marked2)
//                    .edgesIgnoringSafeArea([.top, .horizontal])
//                    .sheet(isPresented: self.$marked) {
//                        NavigationStack {
//                            StoreModalView()
//                        }
//                        .presentationDetents([.height(200), .large])
//                    }
//                    .sheet(isPresented: self.$marked2) {
//                        StoreModalView2()
//                            .presentationDetents([.height(200)])
//                    }
//
//
//            }
//        }
//    }
//}


// 본인 위치 불러오는 클래스
// 현재 작동을 안함
//class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
//    let manager = CLLocationManager()
//
//    @Published var location: CLLocationCoordinate2D?
//
//    override init() {
//        super.init()
//        manager.delegate = self
//    }
//
//    func requestLocation() {
//        manager.requestLocation()
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        location = locations.first?.coordinate
//    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Swift.Error) {
//        print("error:: \(error)")
//    }
//}

import SwiftUI
import MapKit

struct StoreLocation: Identifiable {
  let id = UUID()
  let name: String
  let coordinate: CLLocationCoordinate2D
}

extension CLLocationCoordinate2D: Identifiable {
  public var id: String {
    "\(latitude)-\(longitude)"
  }
}

struct MapView: View {
  // 국밥집 검색창에 들어갈 단어
  @State var searchGukBap : String = ""
  // 필터 버튼을 눌렀을 때 동작하는 모달
  @State private var showModal = false
  // 마커를 클릭했을 때 동작하는 모달
  @State private var marked : Bool = false
  @State private var marked2 : Bool = false
  
  @State private var showingAddMarker = false
  @State private var region = MKCoordinateRegion(
    center: CLLocationCoordinate2D(latitude: 37.503693,
                                   longitude: 127.053033),
    span: MKCoordinateSpan(latitudeDelta: 0.006, longitudeDelta: 0.006))
  
  let annotations = [
    StoreLocation(name: "Seoul", coordinate: CLLocationCoordinate2D(latitude: 37.503693, longitude: 127.053033)),
    StoreLocation(name: "Seoul2", coordinate: CLLocationCoordinate2D(latitude: 37.506276, longitude: 127.048977))
  ]
  
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
              MapCategoryModalView(showModal: $showModal)
                .presentationDetents([.height(335)])
            }
            
            Spacer()
            
          }
          .padding(.horizontal, 18)
          
          Map(coordinateRegion: $region, annotationItems: annotations) { item in
            //                MapMarker(coordinate: $0.coordinate, tint: .purple)
            // Custom mapmarker 사용을 위하여 MapMarker를 MapAnnotation으로 대체
            MapAnnotation(coordinate: item.coordinate, content: {
              Image("mapMarker")
                  .resizable()
                  .aspectRatio(contentMode: .fit)
                  .frame(width: 35)
            })
          }
          .gesture(DragGesture())
          .onLongPressGesture {
            // 길게 누르는 제스쳐를 했을 때 모달 시트가 보이도록 toggle
            showingAddMarker.toggle()
          }
//          .sheet(isPresented: $showingAddMarker, content: {
//            DetailView()
//              .presentationDetents([.fraction(0.5), .fraction(1)])
//          })
//          .ignoresSafeArea()
            
            
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
        
        
        // TODO - 전체화면 꽉 채우기
        // 요소 하나만 수정하면 구현될 예상
        //            NaverMapView(coordination: coordination, marked: $marked, marked2: $marked2)
        //                .edgesIgnoringSafeArea([.top, .horizontal])
        //                .sheet(isPresented: self.$marked) {
        //                    NavigationStack {
        //                        StoreModalView()
        //                    }
        //                    .presentationDetents([.height(200), .large])
        //                }
        //                .sheet(isPresented: self.$marked2) {
        //                    StoreModalView2()
        //                        .presentationDetents([.height(200)])
        //                }
        
        
      }
    }
  }
}

struct MapView_Previews: PreviewProvider {
  static var previews: some View {
    MapView()
  }
}
