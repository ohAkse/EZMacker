## 1️⃣프로젝트 소개

### 🍎 개발 배경 
본 프로그램은 MacOS에 익숙하지 않은 사용자들을 위한 유틸리티 프로그램으로써, 사용자가 쉽게 접하는 기능(배터리 상태, Wifi 접속, 앱 바로가기, 파일 검색 등)을 쉽게 사용할 수 있도록 제작된 유틸리티 프로그램입니다.
주로 Window OS 환경에 익숙했기에 시스템 기능 중 기본기능인 배터리 확인, 와이파이 연결, 파일 찾기, 파일 검색 등과 같은 기능이 MacOS 환경에 있음에도 불구하고 익숙하지 않았고 특정 부분에 있어 기능을 사용하는데 불편함을 느꼈습니다.
따라서, 개인적으로 현재 사용중인 맥북의 기능을 쉽게 활용하고 추가로 기능을 확장하여, 일상생활에서도 더욱 편하고 쉽게 해당 기능들을 이용할 수 있게 하기 위해 프로그램을 개발하였습니다.</br>

### 🛠 주요 기능
- 🔋 배터리 상태 및 충전 상태 확인</br>
- 📶 Wi-Fi 연결 및 실시간 신호세기 확인</br>
- 🚀 무제한 앱 바로가기(도킹) 및 정렬 기능</br>
- 🔍 파일 검색 및 정렬 기능</br>

### ✨ 프로그램의 장점
- 👥 사용자 친화적 인터페이스 </br>
- ⚡ 자주 사용하는 기능에 빠른 접근 </br>
- 🔧 MacOS 기능의 확장 및 개선 </br>


### 🚀 시작하기
- MacBook Sonoma OS(14)버전 이상이면 바로 실행 가능합니다.
- ❗️ **_Mac Mini의 경우 Battery 정보를 받아올 수 없어 기능 개선 예정_** 입니다. > (MacMini시 배터리 화면 안보이게 수정 완료(테스트 필요)


## 2️⃣ 개발 환경
<div style="display: flex;">
    <img src="https://img.shields.io/badge/XCode(15.2)-F05138?style=for-the-badge&logo=Swift&logoColor=white">
    <img src="https://img.shields.io/badge/MacOS(14.2)-FFCA28?style=for-the-badge&logo=Firebase&logoColor=white">
    <img src="https://img.shields.io/badge/SwiftLint-39477F?style=for-the-badge&logo=Realm&logoColor=white">
    <img src="https://img.shields.io/badge/SwiftUI-147EFB?style=for-the-badge&logo=Xcode&logoColor=white">
  <img src="https://img.shields.io/badge/Appkit-147EFB?style=for-the-badge&logo=Xcode&logoColor=white">
</div>

  <br>
    <br>

## 3️⃣개발일정
<p align="center">
  <img src="https://github.com/user-attachments/assets/d9b06b23-44a5-4070-a917-36a4476c0486" alt="개발일정">
    <br>
  <em>9월 향후 일정은 미정</em>
</p>

  <br>
    <br>

<h2 align="left">4️⃣App Architecture</h2>

<p align="center">
  <img src="https://github.com/user-attachments/assets/834b5a19-a841-47ff-a2d2-4a92c99dccb0" alt="App Architecture">
      <br>
  <em>개발 아키텍쳐 다이어그램</em>
</p>

### 프로젝트 구조
아키텍쳐 패턴: MVVM
비즈니스 로직 처리 패턴: Combine을 활용한 비동기 처리 패턴

### 특이사항
소멸자(Deinit) 로그를 통해 메모리 누수와 관련된 작업을 확인하며 개발

## 5️⃣시연영상

<p align="center">
  <img src="https://github.com/user-attachments/assets/d93c9efb-f6e2-4f9a-8d7f-09444b9b4b04" alt="battery_demo">
  <br>
  <em>Battery 화면: 어댑터 충전 여부에 따라 배터리 상태를 확인 가능</em>
</p>
</br>
</br>
</br>
</br>
<p align="center">
  <img src="https://github.com/user-attachments/assets/1dcbe964-a189-4536-9bcb-440afb8d7131" alt="wifi_demo">
  <br>
  <em>Wifi 화면: 1)연결된 WIFI 정보 및 실시간 신호세기 확인 가능,  2)최적의 Wifi 확인 가능</em>
</p>
</br>
</br>

**그밖의 화면 및 기능은 [이곳](https://drive.google.com/file/d/18tFsGLOPasfhhg_pffNj8b8sx1UEfmAp/view)에서 확인 가능합니다.**



## 6️⃣Trouble Shooting
### - Instrument Profiling을 통한 문제 해결

case 1. 최적의 와이파이 찾기 개선

<p align="center">
  <img width="1440" alt="before_best_id" src="https://github.com/user-attachments/assets/26f446f8-0aca-4833-bf64-fe08e14f8424">
  <br>
  <em>개선전: 주기적인 UI Haning 발생</em>
</p>

<br>
<br>

<p align="center">
  <img width="1358" alt="after_best_id" src="https://github.com/user-attachments/assets/d094d19d-7a1f-47de-8934-ba6478f273af">
  <br>
  <em>개선후: UI Haning 발생 X</em>
</p>

원인: Combine으로 타이머 사용시 메인스레드에서 돌아간다는 점을 간과

대책: DispatchQueue(백그라운드)를 사용하여 Timer Publisher를 Wrapping하여 개선

case 2. CPU 과사용시 종료하기 기능 개선

원인: Process 사용량 관련 로직이 메인스레드에서 실행 됨

대책: Process 사용량은 UI와 직접적인 관련이 없기에 백그라운드 스레드에서 실행하게 변경


### - Refactoring을 통한 성능 최적화 

case 1. 배터리 완충시간 및 종료시간 로직 개선

원인: Merge/CombineLatest/Zip의 개념을 혼용하여 스트림 처리가 다소 미흡하게 처리 됨을 확인

대책: 공통로직으로 사용되는 완충시간 및 종료시간의 스트림은 실시간으로 처리 되어야 하기에 CombineLatest로 변경


## 7️⃣ 개선작업

case 1. ViewModel DI 구조 개선

이유: 방대해진 Service 객체들에 대한 관리가 조금씩 힘들어지고 있다고 느껴져서 Locator + Factory Method Pattern으로 변경(추가에정)

case 2. Instrument SignPost 기능을 통한 앱 로깅 추가

이유: GCD를 이용하여 work에 대한 Performance 및 Logging에 대한 추적을 용이하기 위한 기능을 추가함(사진 추가예정)







