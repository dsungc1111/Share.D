
# 🎁 Share.D  
- Share.D는 선물을 고민하는 사용자들에게 다양한 카테고리별 추천을 제공하고, 선물 선택에 대해 다른 사용자들과 의견을 교환할 수 있는 커뮤니티 기능을 갖춘 앱입니다.
-  선물 결제까지 지원하여 사용자의 선물 선택 과정에서 발생하는 불편함을 최소화합니다


<br> <br> 
   ![poster](./ShareDPic.png)

<br> <br> 
# 🙋‍♀️ 프로젝트 주요 기능 
- 회원가입, 로그인
- 추천 선물 카테고리
- 선물 상세화면 및 질문 작성
- 커뮤니티 기능 (사람들과 경험 공유 가능)
- 게시글에 좋아요, 댓글 기능
- 내가 좋아요한 선물 및 구매한 선물 목록 확인 기능 
- 선물 결제 기능

<br> <br> 

# 🧑🏻‍💻 프로젝트 개발환경
- 1인 개발(iOS)
- 개발기간 : 2024.08.14 ~ 2024.09.01 (약 2주)
- iOS 최소 버전: iOS 15.0+   


<br> <br> 

   
# 🛠 프로젝트 기술스택
- 아키텍처 및 디자인 패턴: MVVM(Model-View-ViewModel), Singleton﹒Repository﹒Router Pattern
- 반응형 프로그래밍: RxSwift(Input, Output 패턴)
- 네트워크 통신 및 API: Alamofire, iamport-iOS
- UI 및 이미지 처리: UIKit, PhotosUI, Kingfisher, SnapKit



<br> <br> 

# 👉  상세 기능 구현 설명

###   - **네트워크 로직 관리**
- URLRequestConvertible로 라우터 패턴을 구성하기 위해 Alamofire 사용
- 각 API 엔드포인트의 URL, 헤더 및 매개변수를 중앙 집중식으로 관리할 수 있어 확장성 및 유지관리성이 향상
- 제네릭 타입 활용하여 다양한 Decodable 모델에 대응
- Single을 활용해 API 요청 비동기 처리, 성공/실패에 대한 단일 응답 보장
 
<br>

###  - **네트워크 에러 상태코드 처리**
- BaseViewModel에서 공통적인 네트워크 응답 코드를 처리하고, 각 ViewModel은 필요에 따라 이 메서드를 재정의하여 API별로 맞춤형 메시지를 제공
```swift
class BaseViewModel {
    
    func judgeStatusCode(statusCode: Int, title: String) -> String {
        
        switch statusCode {
        case 403:
            return  "접근권한이 없습니다."
        case 418:
            return "로그인 만료되었습니다. 로그인화면으로 이동합니다."
        case 419:
            return  "액세스 토큰 만료"
        case 420 :
            return "개발자 접근 Key를 확인하세요"
        default:
            return "다시 시도해주세요."
        }
    }
}

```


<br>

###  - **토큰 관리**
 - Access 토큰과 Refresh 토큰을 UserDefaults에 저장.  
 - Alamofire의 `RequestInterceptor`를 사용해 토큰 만료 시 자동으로 재발급하고, 사용자의 작업이 자동으로 재실행되도록 처리

<br>

###  - **결제**
- 아이엠포트 라이브러리를 활용하여 인증 결제 진행
- 결제가 성공적으로 처리된 후, 서버와 통신하여 인증 프로세스를 수행
-  거래가 완료되기 전, 결제 세부 정보가 정확한지 서버에서 유효성 검사 진행
- 유효성 검사가 완료되면 거래가 완료되고 사용자에게 구매 성공 알림 전송

 <br>

###  - **페이지네이션**
 - 서버 API
     - 커서 기반 페이지네이션
     - 마지막 페이지일 때, cursor를 '0'으로 받아와 네트워크 요청 중지
 - 네이버 쇼핑 API   
      - 오프셋 기반 페이지네이션

<br>

###  - **메모리 관리**
 - RxSwift에서 DisposeBag을 사용하여 메모리 누수 방지
- 각 ViewModel 마다 자신만의 DisposeBag을 갖고 있어, 해당 ViewModel이 메모리에서 해제될 때, RxSwift 스트림도 함께 정리되도록 구현
-  클로저 내부에서 ViewModel이나 View에 대한 강한참조가 생기지 않도록 [weak self] 를 사용하여 메모리 순환참조 방지
  
<br><br>


# 👿 트러블슈팅 😈

##  Refresh Token 갱신


### **문제 1**:  **토큰이 만료되면 앱 종료 후, 재로그인하여 토큰갱신**  

- **원인**: 네트워킹 방식이 기본적인 API 요청과 응답을 처리하도록 설계. 토큰 만료 또는 리프레시 메커니즘에 대한 특별한 처리하지 않음.

- **해결**:  419 상태 코드 처리 로직 추가로 토큰 자동 갱신   
  

### **문제 2**:   **Refresh Token을 갱신했지만 기능이 실행되지 않음**

- **원인**: 토큰 갱신 후, 기존 요청을 자동으로 재실행하지 않음    
👉 **사용자가 해당 기능을 두 번 클릭하여 실행 시켜야하는 문제 발생**  


- **해결**:   토큰 갱신 후, 요청 메서드를 다시 실행하도록 코드 수정(메서드내에 코드 구현)   

### **문제 3**:  메서드 내의 코드가 비대해지고, 관리가 힘들어짐

- **해결**:   Alamofire의 RequestInterceptor를 사용하여 토큰이 만료되었을 때 자동으로 갱신하고, 기존 요청을 다시 시도


###  네트워크 통신 메서드에 적용
```swift
 func postNetwork<T: Decodable>(api: PostRouter, model: T.Type) -> Single<(statusCode: Int, data: T?)> {
        return Single.create { observer in

            AF.request(api, interceptor: MyNetworkInterceptor())
                .validate(statusCode: 200..<300)
                .responseDecodable(of: T.self) { response in
                    
                    guard let statuscode = response.response?.statusCode else {
                        observer(.success((statusCode: 500, data: nil)))
                        return
                    }
                    switch response.result {
                    case .success(let value):
                        
                        observer(.success((statuscode, value)))
                        
                    case .failure(let error):

                        observer(.success((statuscode, nil)))   
                    }
                }
            return Disposables.create()
        }
    }

```
<br>
<br>

## UserDefaults 값 저장 에러

### **문제**: 
- 로그인 시, 액세스 토큰 저장 방법 `UserDefault.accessToken = "token"`,   
- 토큰 갱신 시, 액세스 토큰 저장 방법(Key값은 동일) `UserDefaults.standard.setValue(token, forKey: "newToken")`
- Key값만 같다면 값이 갱신될 것이라고 생각했지만, 갱신이 되지 않아 무한 리콜 발생   

### **해결**: 
- UserDefault 속성 래퍼가 해당 값을 UserDefaults.standard와 제대로 동기화하지 않거나 UserDefaults를 업데이트하는 서로 다른 방법을 혼합하는 경우 **Old Value**(이전 값)가 반환  
- 그러므로 토큰 갱신시에도,  `UserDefault.accessToken` 에 값을 대입하는 형식으로 해결   


<br> <br> 


# 🤔 회고

### - 네트워크 로직 구성에 대한 고민
- 제네릭을 사용해 다양한 API를 처리하고 있지만, 유저, 토큰, 포스트와 같은 API 라우터가 분리되어 있어 코드 중복이 발생


### - 향후 계획
- 네트워크 요청 로직을 더욱 개선해 코드 중복을 최소화하고, 보다 유연한 API 구조를 적용할 예정.
- 페이지네이션 최적화를 통해 더 큰 데이터셋에서도 성능 저하 없는 사용자 경험(UX)을 제공
- 네트워크 오류 처리 시 사용자 경험을 개선하기 위한 추가적인 에러 핸들링 로직 도입 계획.





