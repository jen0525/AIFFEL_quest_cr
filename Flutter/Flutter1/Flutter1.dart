import 'dart:async';

const int workTime = 5;
const int shortBreak = 2;
const int longBreak = 10;
int cycle = 1; //처음 사이클 1로 설정
int timeLeft = workTime; //timeLeft(진행되는 시간)을 workTime으로
bool isWorkTime = true; //work면 true

void startTimer() {
  Timer.periodic(Duration(seconds: 1), (timer) {
    if (timeLeft > 0) { // timeLeft가 0보다 크면 즉 시간이 계속 작동되면,
      timeLeft--; // 시간 1초씩 감소
      print("Cycle: $cycle | ${isWorkTime ? 'Work' : 'Break'} " // 사이클 출력 및 처음엔 True라 work로 시작
          "Time: ${timeLeft ~/ 60}:${(timeLeft % 60).toString().padLeft(2, '0')}"); //초 표기
    } else { //timeLeft 0 될시, nextSession()
      timer.cancel();
      nextSession();
    }
  });
}

void nextSession() {
  if (!isWorkTime) { // WorkTime이 false일 때 사이클 1증가
    cycle++;
    if (cycle == 5) { //사이클 4일 때 종료
      print("All cycles completed. Pomodoro session ended.");
      return; // 종료
    }
  }
  timeLeft = isWorkTime ? shortBreak : workTime; // WorkTime이 True이면 shortBreak, False면 workTime
  isWorkTime = !isWorkTime; //True -> False로 전환하여 작업 및 휴식 상태 전환
  print("Switching to ${isWorkTime ? 'Work' : 'Break'} Time | Cycle: $cycle");
  startTimer();
}

void main() {
  print("Starting Pomodoro Timer");
  startTimer();
}

//회고(이윤환): 너무 어려워서 인터넷 도움을 많이 받았다. 먼저 여러 다트 코드들을 접하면서 익숙해지는 것이 필요할 것 같다.
//회고(허재은): 도움을 받아도 해결하지 못한 오류가 있어서 추가적으로 공부를 더 해야할 거 같다. 그래도 뭐가 잘못됐는지 팀원분과 얘기하면서 많이 배울 수 있는거 같다. ^^
