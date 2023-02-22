# 국밥부장관
![iOS](https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=ios&logoColor=white)
![Swift](https://img.shields.io/badge/SwiftUI-0052CC?style=for-the-badge&logo=swift&logoColor=white)
![Swift](https://img.shields.io/badge/swift-F54A2A?style=for-the-badge&logo=swift&logoColor=white)
![Xcode](https://img.shields.io/badge/Xcode-007ACC?style=for-the-badge&logo=Xcode&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-039BE5?style=for-the-badge&logo=Firebase&logoColor=white)
![KakaoTalk](https://img.shields.io/badge/kakaotalk-ffcd00.svg?style=for-the-badge&logo=kakaotalk&logoColor=000000)

## **앱 소개**
<p align="center"><img src="https://cdn.discordapp.com/attachments/1063382836410847243/1077854855143624774/Ddukbaegi.boiling.gif" width=30%></p>

```
"국밥부장관"은 지역 국밥 맛집처럼 숨은 맛집을 찾아다니는 사람들을 위한 앱이다.
왜냐하면 동네 국밥 맛집들은 아는 사람들만 가는 숨은 맛집이 많기 때문에 그 정보를 알기가 힘들기 때문이다.
```

### **서비스 지역**

```
서울, 부산
```

## **참여자**

<div align="center">
  <table style="font-weight : bold">
      <tr align="center">
          <td colspan="7"> 뜨끈한 앱, 따뜻한 팀 워크 </td>
      </tr>
      <tr>
          <td align="center">
              <a href="https://github.com/KiTaeUk">                 
                  <img alt="기태욱" src="https://avatars.githubusercontent.com/u/79833715?v=4" width="80" />            
              </a>
          </td>
          <td align="center">
              <a href="https://github.com/teddy5518">                 
                  <img alt="박성민" src="https://avatars.githubusercontent.com/u/108975398?v=4" width="80" />            
              </a>
          </td>
          <td align="center">
              <a href="https://github.com/JSPark0099">                 
                  <img alt="박정선" src="https://avatars.githubusercontent.com/u/91583287?v=4" width="80" />            
              </a>
          </td>
          <td align="center">
              <a href="https://github.com/MartinLeeSJ">                 
                  <img alt="이석준" src="https://avatars.githubusercontent.com/u/76909552?v=4" width="80" />            
              </a>
          </td>
          <td align="center">
              <a href="https://github.com/Lee-Youngwoo">                 
                  <img alt="이영우" src="https://avatars.githubusercontent.com/u/114223605?v=4" width="80" />            
              </a>
          </td>
          <td align="center">
              <a href="https://github.com/whl0526">                 
                  <img alt="이원형" src="https://avatars.githubusercontent.com/u/67450169?v=4" width="80" />            
              </a>
          </td>
          <td align="center">
              <a href="https://github.com/angry-dev">                 
                  <img alt="전혜성" src="https://avatars.githubusercontent.com/u/98198645?v=4" width="80" />            
              </a>
          </td>
      </tr>
      <tr>
          <td align="center">기태욱</td>
          <td align="center">박성민</td>
          <td align="center">박정선</td>
          <td align="center">이석준</td>
          <td align="center">이영우</td>
          <td align="center">이원형</td>
          <td align="center">전혜성</td>
  </table>
</div>
<br>

## How to build

### 설치 / 실행 방법

* 아래 파일은 필수 파일임으로 파일을 요청해주세요.
```
- Config.xcconfig           // KaKaoSDK
```

<br>
<details>
<summary>1. 개별적으로 Firebase 세팅을 진행해주세요.</summary>
<div markdown="1">

필요한 Target만 세팅해주세요.

```
* 번들 ID: com.GoobVibe.GukbapMinister
```
</div>
</details>

<details>
<summary>2. Firebase에서 Firestore Database, Storage를 설정해주세요.</summary>
<div markdown="1">

```
* 보안 규칙을 `테스트 모드에서 시작`으로 설정해주세요
```
</div>
</details>

## 주요기능과 스크린샷

## 개발 환경
<details>
<summary>펼처서 보기</summary>
<div markdown="1">

- iOS 16.0 이상
- xcode 13.0
- iPhone 전기종 
- 가로모드 미지원

</div>
</details>

## 활용한 기술
<details>
<summary>펼처서 보기</summary>
<div markdown="1">

- Firebase(Auth, Store, Storage)
- KakaoSDK(Auth)
- Kingfisher

</div>
</details>

## 라이센스
GukbapMinister is available under the MIT license. See the [LICENSE](https://github.com/APPSCHOOL1-REPO/finalproject-goodvibe/blob/main/LICENSE) file for more info.
