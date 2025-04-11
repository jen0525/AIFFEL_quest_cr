# 뉴스 요약 어플리케이션 이슈 보고서

## 문제 상황

현재 개발 중인 실시간 뉴스 요약 어플리케이션에서 심각한 문제가 발생했습니다. 실시간으로 뉴스를 불러와 AI 모델을 통해 요약하는 기능을 구현했으나, 실제 작동 결과 요약 내용이 제대로 이루어지지 않는 현상이 확인되었습니다.

## 발견된 이슈

<img width="341" alt="image" src="https://github.com/user-attachments/assets/fd0336b4-b18f-442c-a4e0-198091d878b4" />
<img width="333" alt="image" src="https://github.com/user-attachments/assets/77f4554b-3fe8-453c-a5f9-31a8ca31b23e" />


위 스크린샷과 같이 뉴스 내용이 정상적으로 요약되지 않고, 동일한 단어("trolleyuzbek", "dragging", "courtfbi" 등)가 무의미하게 반복되는 현상이 발생했습니다. 뉴스 제목("Why AI Is Becoming the 'Pacemaker' of Company Finances")은 정상적으로 표시되지만, 본문 내용은 전혀 의미없는 텍스트로 채워졌습니다.
