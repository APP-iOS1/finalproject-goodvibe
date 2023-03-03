

import SwiftUI
import Kingfisher

struct OrderedListView: View {
    @Environment(\.colorScheme) var scheme
    @ObservedObject var exploreViewModel : ExploreViewModel
    var mode: ExploreOrderingMode
    var stores: [Store] {
        return mode == .hits ? exploreViewModel.storesOrderedByHits : exploreViewModel.storesOrderedByStar
    }

    var body: some View {
        NavigationStack{
            ZStack{
                // 배경 색
                Color.gray.opacity(0.2)
                
                ScrollView{
                        
                        VStack{
                            Rectangle()
                                .frame(width: UIScreen.main.bounds.width, height: 10)
                                .foregroundColor(.gray.opacity(0.2))
                            
                            ForEach(stores, id: \.self){ store in
                                ListCell(exploreViewModel: exploreViewModel, store: store)
                                    .frame(width: UIScreen.main.bounds.width-40, height: 90)
                                    .padding()
                                    .padding(.vertical, 10)
                                
                                Divider()

                            }
                        }
                        .background(scheme == .light  ? .white : .black)
                        
                    
                } // ScrollView
                .toolbarBackground(scheme == .light ? Color.white : Color.black, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .navigationTitle(mode == .hits ? "국밥집 조회수 랭킹" : "깍두기 점수가 높은 국밥집")
                .navigationBarTitleDisplayMode(.inline)
            } // ZStack
        } // NavigationStack

        
    }
}

// cell
struct ListCell : View {
    @Environment(\.colorScheme) var scheme
    @ObservedObject var exploreViewModel : ExploreViewModel
    var store : Store
    
    @State var isLoading = true
    
    var rowOne: [GridItem] = Array(repeating: .init(.fixed(50)), count: 1)
    
    
    var body: some View {
        
            VStack {
                NavigationLink {
                    DetailView(store : store)
                } label: {
                    HStack{
                        HStack(alignment: .top){
                            KFImage(exploreViewModel.storeImageURLs[store.storeName]?.first)
                                .placeholder {
                                    Gukbaps(rawValue: store.foodType.first ?? "순대국밥")?.placeholder
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 90, height: 90)
                                }
                                .resizable()
                                .scaledToFill()
                                .frame(width: 90, height: 90)
                                .cornerRadius(25)
                                .overlay(RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color("MainColor"), lineWidth: 0.2))
                            
                            
                            VStack(alignment: .leading, spacing: 1){
                                HStack{
                                    Text(store.storeName)
                                        .foregroundColor(scheme == .light ? .black : .white)
                                        .font(.body)
                                        .bold()
                                        .padding(4)
                                    
                                    Spacer()
                                }
                                
                                HStack(alignment: .center){
                                    Text("깍두기 점수")
                                        .foregroundColor(scheme == .light ? .black : .white)
                                        .bold()
                                        .font(.caption2)
                                    
                                    HStack(alignment: .center, spacing: 0){
                                        Image("Ggakdugi")
                                            .resizable()
                                            .frame(width: 15, height: 15)
                                            .padding(.trailing, 5)
                                        
                                        
                                        Text("\(String(format: "%.1f", store.countingStar))")
                                            .foregroundColor(scheme == .light ? .black : .white)
                                            .font(.caption)
                                            .bold()
                                    }
                                    
                                    Spacer()
                                }
                                .frame(height: 20)
                                .padding(.leading, 5)
                                
                                
                                HStack{
                                    Text(store.storeAddress)
                                        .foregroundColor(scheme == .light ? .black : .white)
                                        .font(.callout)
                                        .lineLimit(1)
                                        .padding(.top, 3)
                                    Spacer()
                                }
                                .padding(.leading, 4)
                                
                                
                                HStack{
                                    LazyHGrid(rows: rowOne) {
                                        ForEach(store.foodType, id: \.self) { foodType in
                                            Text("\(foodType)")
                                                .foregroundColor(scheme == .light ? .black : .white)
                                                .font(.caption)
                                                .padding(9)
                                                .background(scheme == .light ? Capsule().fill(Color.gray.opacity(0.15)) : Capsule().fill(Color.gray.opacity(0.3)))
                                        }
                                    }
                                }
                                
                                
                            }
                            
                        }
                        .foregroundColor(.black)
                        .frame(height: 120)
                        .padding(.leading, 0)
                    }
                }
            }
            .redacted(reason: isLoading ? .placeholder : [])
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.isLoading = false
                }
            }
    }
}


//struct DetailListView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailListView()
//    }
//}
