# QnArt : 초등학생 대상, 대화와 그림 창작 기반 - 미술 작품 감상 서비스

![Frame 1](https://github.com/user-attachments/assets/e1113e6f-f32e-497d-a8f5-620144925e95)

## 🎨Introduction

QnArt는 주입식 설명 위주의 수동적인 미술작품 감상, 어려운 드로잉 창작 위주의 수업으로 미술에 흥미를 잃은 초등학생에게 즐겁고 주체적인 미술작품 감상 경험을 제공하는 애플리케이션입니다.<br>

#### 💬 AI 도슨트와 대화하며 작품 감상

명화 작품 데이터를 가진 AI 도슨트와 채팅 또는 음성으로 대화하며 작품을 감상합니다. AI 도슨트는 미술 교육 이론에 기반하여 사용자에게 작품에 관한 질문을 던지고, 사용자는 질문에 답하며 작품을 깊게 감상합니다.

#### 🖌️ 이미지 생성 AI로 그림 창작

대화 감상이 끝나면, 감상에서 떠올린 자신의 경험이나 상상을 말로 표현합니다. 이미지 생성 AI로 다양한 방식으로 그림을 창작합니다.

## 🖥️About This Repository

이 리포지토리에는 QnArt 앱의 Flutter 기반 프론트엔드 소스 코드를 포함합니다. 앱은 다음과 같은 기능을 제공하는 사용자 친화적인 인터페이스를 제공합니다:

- 사용자 인증 (로그인 및 회원가입)
- 오늘의 명화 카드: 랜덤 명화 작품 감상
- 미술관 찾기: 실제 미술관 전시 작품 감상
- 마이페이지: 사용자별 데이터 조회 및 관리

#### 디렉토리 구조

- **`lib/`**: 주요 애플리케이션 코드 포함.
  - **`consts/`**: 상수 데이터
  - **`screens/`**: 로그인, 회원가입, 홈 화면 등 모든 UI 화면
  - **`widgets/`**: 재사용 가능한 커스텀 위젯
  - **`utils/`**: 유틸리티 함수
- **`asset/`**: 사용된 이미지 및 폰트

## 🔨How to build

1. 저장소 클론

   ```bash
   git clone https://github.com/Wild-Gaori/frontend.git
   cd frontend
   ```

2. 종속성 설치<br>
   Flutter가 설치되어 있는지 확인한 후 다음 명령어를 실행합니다:

   ```bash
   flutter pub get
   ```

3. 앱 빌드<br>
   이 앱은 안드로이드 OS 환경에서 지원됩니다.
   네이버 TTS API 사용을 위한 환경 변수 설정이 필요합니다. 네이버 Cloud CONSOLE에서 유효한 Client ID와 Client Secret을 발급받은 후 ClientId와 ClientSecret2로 key를 지정한 뒤 빌드를 수행하세요.<br>
   [NAVER API 공식 문서](https://api.ncloud-docs.com/docs/common-ncpapi)<br>
   [Flutter 환경 변수 설정 방법](https://day4fternoon.tistory.com/127)
   ```bash
   flutter build apk
   ```

## 🤖How to install

1. 빌드 시 생성된 APK 파일을 `build/app/outputs/flutter-apk/`에서 확인합니다.
2. APK를 디바이스로 전송하고 설치합니다.

## 📜How to test

설치된 APK를 실행하고, 앱이 정상적으로 실행되었다면 아래 샘플 데이터로 테스트를 진행합니다.

### About Sample Data

아래 샘플 데이터를 이용해 앱을 테스트할 수 있습니다:

- **테스트 계정**: ID: test3 / PW: 1111

### Backend and Database

앱은 다음과 같은 백엔드 서비스를 통합합니다:

- **API 엔드포인트**: 사용자 인증 및 작품 데이터를 제공하는 Django 백엔드.
  - 백엔드 리포지토리: [QnArt-backend](https://github.com/Wild-Gaori/backend)
- **데이터베이스**: mySQL Database를 사용합니다. 데이터는 동적으로 백엔드에서 가져옵니다.

## 🌐Used Open Source

이 프로젝트는 다음과 같은 오픈소스 라이브러리를 사용합니다:

- **speech_to_text**: 음성 인식(STT) 구현용
- **http**: API 요청용
- **shared_preferences**: 사용자 인증 정보를 로컬 디바이스에 저장
- **image**: 투명화 처리 등 이미지 처리 및 관리용

전체 종속성 목록은 `pubspec.yaml`을 참조하세요.
