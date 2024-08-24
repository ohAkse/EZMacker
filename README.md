1. 최적의 와이파이 찾기 개선

<img width="1440" alt="before_best_id" src="https://github.com/user-attachments/assets/26f446f8-0aca-4833-bf64-fe08e14f8424">
<개선전: 주기적인 UI Haning 발생>

<img width="1358" alt="after_best_id" src="https://github.com/user-attachments/assets/d094d19d-7a1f-47de-8934-ba6478f273af">
<개선후: Haning 발생 X>

원인: Combine으로 타이머 사용시 메인스레드에서 돌아간다는 점을 간과

대책: DispatchQueue(백그라운드) 만들어서 타이머를 래핑하여  사용
