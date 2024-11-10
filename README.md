

## 1️⃣프로젝트 소개

### 🍎 개발 배경 
본 프로그램은 MacOS에 익숙하지 않은 사용자들을 위한 올인원 유틸리티 프로그램입니다. Windows 환경에서 MacOS로 전환한 개인적인 경험을 바탕으로, 시스템의 기본적인 기능들(배터리 상태, Wifi 접속, 파일 관리 등)을 더욱 직관적이고 접근하기 쉽게 재구성하였습니다.
MacOS가 제공하는 강력한 기능들이 있음에도 불구하고, Windows 사용자의 관점에서 이러한 기능들을 찾고 활용하는 데 어려움을 겪었습니다. 이러한 진입 장벽을 낮추고, 필수적인 시스템 기능들을 더욱 쉽고 효율적으로 사용할 수 있도록 본 프로그램을 개발하게 되었습니다.</br>

### 🛠 주요 기능
- 🔋 배터리 상태 및 충전 상태 확인</br>
- 📶 Wi-Fi 연결 및 실시간 신호세기 확인</br>
- 🚀 파일/폴더 바로가기 기능</br>
- 🔍 파일 검색 및 정렬 기능</br>
- 🎨 이미지 편집/그리기 기능</br>
  

### ✨ 프로그램의 장점
- 👥 사용자 친화적 인터페이스 </br>
- ⚡ 자주 사용하는 기능에 빠른 접근 </br>
- 🔧 MacOS 기능의 확장 및 개선 </br>


## 2️⃣ 개발 환경
### 📚 사용 라이브러리
<div style="display: flex;">
    <img src="https://img.shields.io/badge/XCode(15.2)-F05138?style=for-the-badge&logo=Swift&logoColor=white">
    <img src="https://img.shields.io/badge/MacOS(14.0)-FFCA28?style=for-the-badge&logo=Firebase&logoColor=white">
    <img src="https://img.shields.io/badge/SwiftLint-39477F?style=for-the-badge&logo=Realm&logoColor=white">
    <img src="https://img.shields.io/badge/SwiftUI-147EFB?style=for-the-badge&logo=Xcode&logoColor=white">
    <img src="https://img.shields.io/badge/OpenCV(4.10.0__11)-5C3EE8?style=for-the-badge&logo=opencv&logoColor=white">
    <img src="https://img.shields.io/badge/Appkit-147EFB?style=for-the-badge&logo=Xcode&logoColor=white">
</div>
  <br>

### 🚀 시작하기
- OpenCV 설치</br>
>brew install opencv</br>

- OpenCV 버전 확인 </br>
>brew list opencv --versions</br>

- 설치 된 Opencv 버전이 다를 경우 설정방법
1) App 프로젝트 네비게이션 > Build Setting > Header Search Paths/Library Search Paths에 설정 된 경로중 버전 폴더 이름을 설치된 해당 버전으로 경로 변경
2) 라이브러리 파일 재설정: 경로: App > Build Phase > 아래 파일 3가지를 다시 등록</br>
**libopencv_imgcodes.a**</br>
**libopencv_imgproc.a**</br>
**libopencv_core.a**</br>

⚠️ 위 파일들은 opencv 버전 폴더의 lib 폴더애서 찾을 수 있습니다.</br>

- 시스템 요구사항
>MacBook Sonoma OS(14) 이상

## 3️⃣개발일정
<p align="center">
  <img src="https://github.com/user-attachments/assets/1577f884-7ec6-4cda-9b30-e25862cf641e" alt="개발일정">
    <br>
  <em>향후 일정은 미정</em>
</p>
  <br>
    <br>
<h2 align="left">
    
4️⃣App Architecture</h2>

<p align="center">
  <img src="https://github.com/user-attachments/assets/e7b02c11-1ca9-4951-8d61-d7a64f5d77c5" alt="앱 아키텍쳐">
      <br>
  <em>개발 아키텍쳐 다이어그램</em>
</p>

- MVVM 구조를 활용하여 뷰와 비즈니스 로직을 분리하였으며, Combine을 주로 사용하여 개발
- View <-> ViewModel은 각각 1:1일 구조를 가지며, 각 서비스 객체들에 대한 의존성 주입은 Service Locator Register & Resolve 형태로 주입

### 🔍프로젝트 구조 소개
<p align="center">
  <img src="https://github.com/user-attachments/assets/5c909814-3365-4dd2-a34e-4c5b6f8258ff" alt="프로젝트 구조">
      <br>
  <em>프로젝트 구조 </em>
</p>

본 프로젝트는 코드 관리 및 확장성을 위해 4가지 형태의 정적 라이브러리를 포함시켜 개발하였으며  각 모듈은 아래와 같은 기능을 담당
- EZMackerImageLib: 이미지 처리와 관련하여 Opencv를 이용한 이미지 변환 래퍼 모듈
- EZMackerThreadLib: GCD, signpost와 관련된 기능을 담당하는 모듈
- EZMackerServiceLib: 화면별 기능을 담당하는 서비스 모듈
- EZMackerUtilLib: 커맨드 실행, 로깅, 단축키 설정 등 유틸성 관련 모듈
- EZMacker: 앱의 시작점으로 UI(SwiftUI/Appkit/Locator)를 담당

### 🔬특이사항
- 소멸자(Deinit) 로그를 통해 메모리 누수와 관련된 작업을 확인하며 개발
- FatalError(Debug)를 이용한 실수 방지
- Instrumnet를 활용한 앱 안정화 및 퍼포먼스 확인

## 5️⃣시연영상

<p align="center">
  <img src="https://github.com/user-attachments/assets/8c8993cc-fef5-42f4-b2a0-db51ad8e3969" alt="battery_demo">
  <br>
  <em>Battery 화면: 배터리 상태, 어댑터 정보/충전 상태 등 실시간 확인 가능 </em>
</p>
</br>
</br>
</br>
</br>

<p align="center">
  <img src="https://github.com/user-attachments/assets/2d47922d-58f1-4c39-9e9d-3631d7675270" alt="wifi_demo">
  <br>
  <em>Wifi 화면: 연결된 WIFI를 기준으로 신호세기/정보 등 실시간 확인 기능</em>
</p>
</br>
</br>

**그밖의 화면 및 기능은 [이곳](https://drive.google.com/file/d/1lCNHdlW9InlLWNy8x8OTqi9DkUq5b1zx/view?usp=sharing)에서 확인 가능합니다.**


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





