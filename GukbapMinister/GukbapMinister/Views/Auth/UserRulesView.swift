//
//  UserRulesView.swift
//  GukbapMinister
//
//  Created by ishio on 2023/01/30.
//

import SwiftUI

struct UserRulesView: View {
    @Environment(\.dismiss) var returnSignUpView
    
    var body: some View {
        NavigationStack {
            ScrollView{
                VStack {
                    Group{
                        HStack {
                            Text("국밥부장관 개인정보처리방침")
                                .font(.title)
                                .fontWeight(.bold)
                            Spacer()
                        }//HStack
                        .padding(.bottom, 10)
                        HStack{
                            Text("<국밥부장관>('github.com/APPSCHOOL1-REPO/finalproject-goodvibe', 이하 국밥부장관) 이(가)취급하는 모든 개인정보는 개인정보보호법 등 관련 법령상의 개인정보보호 규정을 준수하여 이용자의 개인정보 보호 및 권익을 보호하고 개인정보와 관련한 이용자의 고충을 원활하게 처리할 수 있도록 다음과 같은 처리방침을 두고 있습니다.")
                        }//HStack
                        VStack{
                            HStack {
                                Text("1.개인정보의 처리 목적")
                                    .font(.title3)
                                Spacer()
                            }
                            HStack{
                                Text("① <국밥부장관>은(는) 다음의 목적을 위하여 개인정보를 처리하고 있으며, 다음의 목적 이외의 용도로는 이용하지 않습니다. 고객 가입의사 확인, 고객에 대한 서비스 제공에 따른 본인 식별·인증, 회원자격 유지·관리, 물품 또는 서비스 공급에 따른 금액 결제, 물품 또는 서비스의 공급·배송, 마케팅 및 광고에의 활용")
                            }
                        }//VStack
                        VStack{
                            HStack {
                                Text("2.개인정보의 처리 및 보유 기간")
                                    .font(.title3)
                                Spacer()
                            }
                            HStack{
                                Text("① <국밥부장관>은(는) 정보주체로부터 개인정보를 수집할 때 동의 받은 개인정보 보유·이용기간 또는 법령에 따른 개인정보 보유·이용기간 내에서 개인정보를 처리·보유합니다.② 구체적인 개인정보 처리 및 보유 기간은 다음과 같습니다.")
                            }
                            HStack {
                                Text("고객 가입 및 관리 : 서비스 이용계약 또는 회원가입 해지시까지, 다만 채권·채무관계 잔존시에는 해당 채권·채무관계 정산시까지, 전자상거래에서의 계약·청약철회, 대금결제, 재화 등 공급기록 : 5년")
                            }
                        }//VStack
                        VStack{
                            HStack {
                                Text("3.정보주체와 법정대리인의 권리·의무 및 그 행사방법")
                                    .font(.title3)
                                Spacer()
                            }
                            HStack{
                                Text("정보주체는 <국밥부장관>에 대해 언제든지 다음 각 호의 개인정보 보호 관련 권리를 행사할 수 있습니다.")
                            }
                            HStack {
                                Text("1. 개인정보 열람요구 2. 오류 등이 있을 경우 정정요구 3. 삭제요구 4. 처리정지 요구")
                            }
                        }//VStack
                        VStack{
                            HStack {
                                Text("4.처리하는 개인정보 항목")
                                    .font(.title3)
                                Spacer()
                            }
                            HStack{
                                Text("개인정보 처리업무: 홈페이지 회원가입 및 관리, 민원사무 처리, 재화 또는 서비스 제공, 마케팅 및 광고에의 활용, 필수항목: 로그인ID, 비밀번호, 서비스 이용 기록, 접속 로그, 쿠키, 접속 IP 정보, 결제기록, 선택항목: 이메일, 성별, 이름")
                            }
                        }//VStack
                        VStack{
                            HStack {
                                Text("5.개인정보의 파기")
                                    .font(.title3)
                                Spacer()
                            }
                            HStack{
                                Text("파기절차")
                                Spacer()
                            }
                            HStack {
                                Text("이용자가 입력한 정보는 목적 달성 후 별도의 DB에 옮겨져(종이의 경우 별도의 서류) 내부 방침 및 기타 관련 법령에 따라 일정기간 저장된 후 혹은 즉시 파기됩니다. 이 때, DB로 옮겨진 개인정보는 법률에 의한 경우가 아니고서는 다른 목적으로 이용되지 않습니다.")
                            }
                            HStack{
                                Text("파기기한")
                                Spacer()
                            }
                            HStack {
                                Text("이용자의 개인정보는 개인정보의 보유기간이 경과된 경우에는 보유기간의 종료일로부터 30일 이내에, 개인정보의 처리 목적 달성, 해당 서비스의 폐지, 사업의 종료 등 그 개인정보가 불필요하게 되었을 때에는 개인정보의 처리가 불필요한 것으로 인정되는 날로부터 30일 이내에 그 개인정보를 파기합니다.")
                            }
                        }//VStack
                        VStack{
                            HStack {
                                Text("6.개인정보 자동 수집 장치의 설치·운영 및 그 거부에 관한 사항")
                                    .font(.title3)
                                Spacer()
                            }
                            HStack{
                                Text("① <국밥부장관>은 개별적인 맞춤서비스를 제공하기 위해 이용정보를 저장하고 수시로 불러오는 ‘쿠키(cookie)’를 사용합니다. ② 쿠키는 웹사이트를 운영하는데 이용되는 서버(http)가 이용자의 스마트폰에게 보내는 소량의 정보이며 이용자들의 스마트폰 내의 저장소에 저장되기도 합니다.")
                            }
                        }//VStack
                        VStack{
                            HStack {
                                Text("7.개인정보 보호책임자")
                                    .font(.title3)
                                Spacer()
                            }
                            HStack{
                                Text("이름: 이석준, 소속: 운영팀, 사이트: github.com/APPSCHOOL1-REPO/finalproject-goodvibe")
                                Spacer()
                            }
                        }//VStack
                        VStack{
                            HStack {
                                Text("8.개인정보의 안정성 확보 조치")
                                    .font(.title3)
                                Spacer()
                            }
                            HStack{
                                Text("이용자의 비밀번호는 암호화 되어 저장 및 관리되고 있어, 본인만이 알 수 있으며 중요한 데이터는 파일 및 전송 데이터를 암호화 하거나 파일 잠금 기능을 사용하는 등의 별도 보안기능을 사용하고 있습니다.")
                            }
                        }//VStack
                    }//Group 1
                    Group{
                        VStack{
                            HStack {
                                Text("9.개인정보처리방침의 변경")
                                    .font(.title3)
                                Spacer()
                            }
                            HStack{
                                Text("이 개인정보처리방침은 시행일로부터 적용되며, 법령 및 방침에 따른 변경내용의 추가, 삭제 및 정정이 있는 경우에는 변경사항의 시행 7일 전부터 공지사항을 통하여 고지할 것입니다.")
                            }
                            HStack {
                                Text("공고일자 : 2023년 02월 10일, 시행일자 : 2023년 02월 17일")
                                Spacer()
                            }
                        }//VStack
                    }//Groupd 2
                } //가장 바깥 VStack
                .padding()
                .font(.footnote)
                .toolbar{
                    ToolbarItem(placement: .cancellationAction) {
                        Button {
                            returnSignUpView()
                        } label: {
                            Image(systemName: "xmark")
                                .foregroundColor(.black)
                        }
                    }
                }//toolbar
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(.yellow, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
            }
        }//NavigationStack
    }//var body
}

struct UserRulesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            UserRulesView()
        }
    }
}
