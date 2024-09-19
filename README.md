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
    <img src="https://img.shields.io/badge/MacOS(14.0)-FFCA28?style=for-the-badge&logo=Firebase&logoColor=white">
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

### 프로젝트 구조 소개
- MVVM 구조를 활용하여 뷰와 비즈니스 로직을 분리하였으며, Combine을 주로 사용하여 개발
- ThreadLib/ServiceLib/UtilLib 총 3가지의 주요 기능 라이브러리를 포함시켜 역할을 분리하여 개발을 진행
- 재사용 가능한 UI 컴포넌트와 모듈화된 기능을 설계 및 작성

### 특이사항
- 소멸자(Deinit) 로그를 통해 메모리 누수와 관련된 작업을 확인하며 개발
- FatalError(Debug)를 이용한 실수 방지
- Instrumnet를 활용한 앱 안정화 및 퍼포먼스 확인

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
## Case 1. 최적의 와이파이 찾기 및 CPU 과사용시 종료하기 개선

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


## Case 2. 배터리 완충시간 및 종료시간 로직 개선

원인: Merge/CombineLatest/Zip의 개념을 혼용하여 스트림 처리가 다소 미흡하게 처리 됨을 확인

대책: 공통로직으로 사용되는 완충시간 및 종료시간의 스트림은 실시간으로 처리 되어야 하기에 CombineLatest로 변경


## 7️⃣ 개선작업

## Case 1: Instrument 로깅 기능 추가
### 도입 이유
1. Instrument Profile 기본기능에 대한 한계
   - 특정 기능/함수에 대한 시작/종료점을 명확히 알수가 없음
   - 콘솔 로깅을 통해 진행 할 수 있으나, 가시적인 로깅에 대한 불편함을 겪음
2. GCD Queue Logging의 필요성
   - Queue간(Serial/Concurrent/Global)의 작업 전환과 병렬 실행 상황을 더 명확히 이해하고 분석할 수 있는 도구가 필요
   - 실시간으로 앱 성능을 모니터링할 때 각 큐의 작업 실행을 명확히 구분할 수 있는 마킹 기능이 필요

### 해결 방안
  - GCD/Custom Queue에 대한 os_signpost를 기능을 추가

### 결과:
1. 효율적인 이벤트 추적 구현
   - 앱의 주요 기능 실행 시작과 종료 시점을 코드 내에서 간단히 마킹 가능
   - 콘솔 출력 없이 Instrument 도구를 통해 각 작업의 소요 시간을 밀리초 단위로 확인 가능
   - 시각적인 타임라인을 통해 이벤트 흐름을 직관적으로 파악 가능
2. 실시간 성능 분석 가능
   - 개발 및 테스트 과정에서 실시간으로 앱 성능을 모니터링 가능

### 기대효과:
1. 개발 생산성 향상 
   - Profile Logging을 통해 디버깅 시간 감소

<p align="center">
  <img width="1000" alt="signpost" src="https://github.com/user-attachments/assets/adde7028-53ae-4ef4-b2c0-dda6b2319ca4">
  <br>
  <em>Signpost Logging</em>
</p>

<br>
<br>

<p align="center">
  <img width="1000" alt="concurrency" src="https://github.com/user-attachments/assets/e7d56829-9dfa-485a-89e3-c29db2986b48">
  <br>
  <em>Concurrency Monitoring</em>
</p>

## Case 2. ViewModel DI 구조 개선
### 변경 이유:
1. 뷰모델 확장성에 대한 고민: 
   - 서비스 객체 증가로 관리 복잡성 증가
   - 코드 관리와 유지보수가 어려워지는 추세
   - Compile Warning > Compile Error로 진행 중(SwiftLint)

### 해결 방안
   - Locator + Factory Method 패턴을 결합하여 추상화 진행

### 결과
1. 개선 방향 
   - ViewModel 의존성 주입 구조가 단순화 
   - 코드의 확장성과 유지보수성이 향상
   - Unit Test를 위한 구조화 기반 마련
  
### 기대효과:
1. Mocking Unit Test
   - 테스트 용이성 증가로 개발 효율성 향상 예상


## 변경전
<p align="center">
  <img width="700" alt="di-before" src="https://github.com/user-attachments/assets/bbdf4689-d59e-4112-9cc8-52874bada602">
  <br>
  <em>코드 복잡성 증가, 가독성 저하 </em>
</p>
  <br>
<br>


## 변경후

<p align="center">
  <img width="700" alt="di-after" src="https://github.com/user-attachments/assets/6bd30bea-ddc1-43d5-af9c-1a1e388a2ac0">
  <br>
  <em>화면에 해당하는 서비스 객체 로케이터에 등록 </em>
</p>



<p align="center">
  <img width="700" alt="di-after" src="https://github.com/user-attachments/assets/5f219e59-7b49-4a4e-9cd4-9b9c5c92e3b5">
  <br>
  <em>
    로케이터에 등록 된 팩토리 의존성 주입
  </em>
</p>

이후 각 화면에 해당하는 서비스 객체들을 Resolve함으로써 코드 관리가 용이해짐





