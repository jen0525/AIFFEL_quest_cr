# AIFFEL Campus Online Code Peer Review Templete
- 코더 : 코더의 이름을 작성하세요.
- 리뷰어 : 리뷰어의 이름을 작성하세요.


# PRT(Peer Review Template)
- [o]  **1. 주어진 문제를 해결하는 완성된 코드가 제출되었나요?**
    - 1,2번 문제 모두 문제를 해결하는 완성 코드가 제출되어 있습니다. 
        - **문제 1. 최댓값과 최솟값 찾기**
        -  ![image](https://github.com/user-attachments/assets/4baa8152-4b8d-4db6-91c9-c6e6fcd64a54)


        - **문제 2. 함수의 호출 횟수를 세는 데코레이터**
        - ![image](https://github.com/user-attachments/assets/8db2673e-98b2-4633-89b2-20ac7d454a86)
          
    
- [△]  **2. 전체 코드에서 가장 핵심적이거나 가장 복잡하고 이해하기 어려운 부분에 작성된 
주석 또는 doc string을 보고 해당 코드가 잘 이해되었나요?**
    - 문제 1. 최댓값과 최솟값 찾기
    - : 주석은 별도로 달지 않고, 아래 오류문을 첨부하여 해당 교정과정을 상세히 기술함
    - ![image](https://github.com/user-attachments/assets/a27c9a2f-4d4c-4b96-a4af-f9d16409c8e3)

    - 문제 2. 함수의 호출 횟수를 세는 데코레이터
    - : 주석이 잘 달려져 있으나, 아래에 일괄적으로 작성되어 있어 바로 알기가 어려움 
    - ![image](https://github.com/user-attachments/assets/67a80478-9112-4efd-849d-03850f1b1c81)

        
- [o]  **3. 에러가 난 부분을 디버깅하여 문제를 해결한 기록을 남겼거나
새로운 시도 또는 추가 실험을 수행해봤나요?**
    - 문제 1. 최댓값과 최솟값 찾기
    - : 오류문의 원인과 결과를 상세히 기술함
    - ![image](https://github.com/user-attachments/assets/a27c9a2f-4d4c-4b96-a4af-f9d16409c8e3)

    - 문제 2. 함수의 호출 횟수를 세는 데코레이터
    - : 카운터 호출 누락 등 오류문에 대한 내용을 기재하고, 교졍 결과가 기술되어 있음 
    - ![image](https://github.com/user-attachments/assets/67a80478-9112-4efd-849d-03850f1b1c81)

        
- [o]  **4. 회고를 잘 작성했나요?**
    - ![image](https://github.com/user-attachments/assets/973eb476-083f-4c54-8361-47b1af5cb4fd)
    - 어떤부분에서 그루의 협조로 문제의 해결과정을 달성했는지 기술되어 있다.  

        
- [△]  **5. 코드가 간결하고 효율적인가요?**
    - 문제 1. 최댓값과 최솟값 찾기
    - : 전반적으로 효율적이나, 1번코드에서 nonlocal의 중복선언이 있음. 
    - ![image](https://github.com/user-attachments/assets/a27c9a2f-4d4c-4b96-a4af-f9d16409c8e3)

    - 문제 2. 함수의 호출 횟수를 세는 데코레이터
    - 문제의 답변에 충실했으나, 보다 정확한 인자 처리 방식이 필요. 
    - ![image](https://github.com/user-attachments/assets/356d0b2c-e2b5-4693-b0ef-cdb4b121ca12)



# 회고(참고 링크 및 코드 개선)
```
1번 코드 
    def update_min_max(num):
        # 외부함수의 변수인 min_value, max_value 참조
        nonlocal min_value
        nonlocal max_value

해당부분에서는 nonlocal 을 한번만 사용하고
        nonlocal min_value, max_value 로 사용하여도 충분함. 굳이 중복 선언할 필요가 없음

2번 문제
    def counter(fn):
      count=0
    
      def counter_say():
        nonlocal count
        count+=1
        fn()
        print(fn.__name__,'실행횟수:',count)
      return counter_say

에서
    def counter_say()를
    def counter_say(*args, **kwargs) 로 하는 것이 보다 정확한 방법이 될 수 있음.
    
    아래의 실행문에서 이미 ()로 인자가 없는 경우임을 예시로 들어 counter_say()로 해도 무방하나 
    만약 다른 인자가 들어 있다면 오류가 발생하므로,
    보다 정확하게 실행하기 위해서는 어떤 인자든지 받을 수 있도록 위치기반인자, 키워드 기반 인자를 사용해 주는 것이 좋음. 

```
