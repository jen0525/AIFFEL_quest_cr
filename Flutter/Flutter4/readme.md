# ♥️딥러닝 학습 도우미 챗봇 설계하기♥️

## 앱 정보
 - 앱 이름: DeapLearning ChatBot
 - 취지: 딥러닝 학습 도우미 챗봇은 인공지능(A))와 자연어 기술을 활용하여 사용자의 딥러닝 학습을 지원하는 인터랙티브 챗봇입니다. 
 - 계획: 케러스 창시자에게 배우는 딥러닝 책의 pdf를 가지고 있었기에 이를 기반으로 응답하는 ( 딥러닝 도메인 지식에 특화된) RAG 챗봇을 만들어 Flutter UI를 구현 하는 것. 
 - 타겟: 딥러닝 학습자 
 - 예상 흐름: 사용자가 질문을 입력하면 → <dify>RAG 시스템이 책(도메인 자료)에서 관련 정보 검색 → GPT가 요약 및 답변 생성 → 사용자에게 표시

## 앱 구조도 = Chatgpt와 동일하게 만드는 것을 목적으로 함. 
<img width="470" alt="image" src="https://github.com/user-attachments/assets/8cdd1b4d-f2bd-4b74-8870-f4186ae85569" />

## 앱 와이어프레임 (사용 툴 : 굿노트)
<img width="470" alt="image" src="https://github.com/user-attachments/assets/767ba61e-4449-488e-bb30-96f94a52821a" />

## 프로토타이핑 (사용 툴 : Marvel, Figma) 
<img width="873" alt="image" src="https://github.com/user-attachments/assets/cd1e7483-cb55-4c75-b0a3-57ddf9f021e4" />
https://marvelapp.com/prototype/fj8gcd1/screen/96814110

## 구성 
lib/
<img width="239" alt="image" src="https://github.com/user-attachments/assets/7ed851c2-689d-4675-97c3-d6c3f5a85fc9" />


## 페이지 구현: 
splash_screen.dart: 앱을 켰을때 가장 먼저 등장하는 화면으로 로고와 챗봇의 이름을 가장 먼저 보여줌. 
intro_page.dart, 챗봇에 대한 설명이 적혀진 페이지
chat_screen.dart 동적인 대화 인터페이스 

## 변경사항 : dify로 열심히 딥러닝에 특화된 챗봇을 만들었지만... (API가 연동이 되지 않는 이슈로) -> ⭐️ Gemini를 연동시킴 ⭐️
<img width="1417" alt="image" src="https://github.com/user-attachments/assets/b420c49f-d405-46d5-a024-52fce3de5e7c" />
(열심히 만들었지만 연동이 안되는 챗봇의 workflow🥲)

## 실행 동영상 
![fluttershortversion-ezgif com-video-to-gif-converter](https://github.com/user-attachments/assets/8a551baf-b3ac-4bed-85cc-11054609c19b)

## 회고: Dify를 연동 못시킨게 아쉽다. 그래도 재밌었다. 이전 대화내용을 저장하고 목록을 생성하는 등의 더 다양한 기능을 추가해보고 싶다. 




