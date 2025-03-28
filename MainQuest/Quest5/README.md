# 📰AI 뉴스 앱 (AI News App)📰

<img width="347" alt="image" src="https://github.com/user-attachments/assets/5de4bc58-a9f5-44b8-809e-3749c39f50c2" />

## AI 뉴스 앱은...<br> 
*Google News, YouTube, Reddit 등 다양한 소스를 통해 최신 AI 관련 뉴스를 확인하고, YouTube 영상을 간편하게 시청할 수 있는 Flutter 기반의 애플리케이션입니다. 이 앱은 사용자가 설정한 검색어에 맞는 뉴스, 소식 및 동영상을 YouTube API를 통해 가져오고, 이를 UI에 표시하여 사용자가 원하는 정보를 빠르게 찾을 수 있도록 돕습니다. 이를 통해 사용자는 매일 지식을 업데이트 할 수 있습니다. *

# 주요 기능 <br> 
* YouTube 영상: 사용자가 입력한 검색어에 맞는 최신 YouTube 영상을 불러와 리스트 형태로 제공합니다.
* Reddit 뉴스: 특정한 주제를 선정해 Reddit에서 불러와 표시합니다. -> 클릭시 본문 이동
* Goggle 뉴스: AI와 관련된 최신 뉴스를 BERT 모델로 요약해와 가지고 옵니다. -> 클릭시 본문 이동
* 설정 기능: 사용자가 원하는 검색어를 설정할 수 있으며, 이 설정은 앱 내에서 저장됩니다. (사용자가 원하는 내용이 노출되도록 커스텀이 가능합니다.)


시도1. 영문 기사와 Reddit을 번역해 가지고 오고 싶었지만, 만들다 보니 화면이 자주 업데이트 되어 돈을 많이 써 번역 기능은 제외. 
시도2. 원래는 Youtube가 아니라 TTS를 적용해 듣는 뉴스를 만들고 싶었지만 시간 부족 이슈로 유튜브로 대체

아쉬운 점. 마지막에 가서 Youtube API를 다써서 너무 슬프게도 동영상이 노출이 되지 않는다. 여러 종류의 API를 알게 되어서 좋은 시간이었다.
개선점: 뉴스나 유튜브를 가지고 오는데 로딩 시간이 좀 걸리는 점을 개선하면 좋을 거 같다. 


<img width="775" alt="image" src="https://github.com/user-attachments/assets/0397d758-c374-4208-a1e1-05904cfef170" />
