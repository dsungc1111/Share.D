
# 🎁 Share.D  
- Share.D는 선물을 고민하는 사용자들에게 다양한 카테고리별 추천을 제공하고, 선물 선택에 대해 다른 사용자들과 의견을 교환할 수 있는 커뮤니티 기능을 갖춘 앱입니다
-  선물 결제까지 지원하여 사용자의 선물 선택 과정에서 발생하는 불편함을 최소화합니다


<br> <br> 
   ![poster](./sss.png)

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
- iOS 최소 버전: iOS 16.0+   


<br> <br> 

   
# 🛠 프로젝트 기술스택
- 아키텍처 및 디자인 패턴: MVVM, Router﹒Input/Output 패턴
- 반응형 프로그래밍: RxSwift,RxCocoa
- 네트워크 통신 및 API: Alamofire, WebView
- UI 및 이미지 처리: UIKit, PhotosUI, Kingfisher, SnapKit


<br> <br> 

# 👉  상세 기능 구현 설명

###   네트워크 
- Alamofire를 사용해 URLRequestConvertible로 라우터 패턴을 구성하여 각 API 엔드포인트의 URL, 헤더 및 매개변수를 중앙에서 관리하며, 제네릭 타입을 활용해 다양한 Decodable 모델에 유연하게 대응하여 확장성과 유지보수성을 향상
- BaseViewModel에서 공통적인 네트워크 응답 코드를 처리하고, 각 ViewModel은 필요에 따라 메서드를 재정의하여 API별로 맞춤형 메시지를 제공
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

###  **토큰 관리**
 - Access 토큰과 Refresh 토큰을 UserDefaults에 저장.  
 - Alamofire의 `RequestInterceptor`를 사용해 토큰 만료 시 자동으로 재발급하고, 사용자의 작업이 자동으로 재실행되도록 처리

<br>

###  **결제**
- 아이엠포트 라이브러리를 활용하여 인증 결제 진행
- 결제가 성공적으로 처리된 후, 서버와 통신하여 인증 프로세스를 수행
-  거래가 완료되기 전, 결제 세부 정보가 정확한지 서버에서 유효성 검사 진행
- 유효성 검사가 완료되면 거래가 완료되고 사용자에게 구매 성공 알림 전송

 <br>

###  **페이지네이션**
 - 커서 기반 페이지네이션(서버 API): 마지막 데이터의 고유 식별자를 기준으로 다음 페이지를 요청
 - 오프셋 기반 페이지네이션(네이버 API): 페이지 번호, 데이터 수에 따라 데이터를 나누어 요청

<br>

###  **메모리 관리**
- 각 ViewModel 마다 자신만의 DisposeBag을 갖고 있어, 해당 ViewModel이 메모리에서 해제될 때, RxSwift 스트림도 함께 정리되도록 구현
-  클로저 내부에서 ViewModel이나 View에 대한 강한참조가 생기지 않도록 [weak self] 를 사용하여 메모리 순환참조 방지
  
<br><br>


# 👿 트러블슈팅 

### **문제 상황** - Refresh Token을 갱신했지만 사용자가 실행한 기능이 자동으로 재실행되지 않는 상황

### **해결** - Alamofire의 RequestInterceptor를 사용하여 토큰 만료시 갱신, 그리고 기존 요청 재실행을 하나의 통합된 로직으로 처리


###  RequestInterceptor를 채택한 NetworkInterceptor 적용
```swift
 func postNetwork<T: Decodable>(api: PostRouter, model: T.Type) -> Single<(statusCode: Int, data: T?)> {
        return Single.create { observer in

            AF.request(api, interceptor: NetworkInterceptor())
                .validate(statusCode: 200..<300)
                .responseDecodable(of: T.self) { response in
                    
                   ...
                }
            return Disposables.create()
        }
    }

```
<br>
<br>

### **문제 상황** - 토큰 갱신 실패
- 로그인 시, 액세스 토큰 저장 방법 `UserDefaultsManager.accessToken = "token"`,   
- 토큰 갱신 시, 액세스 토큰 저장 방법(Key값은 동일) `UserDefaults.standard.setValue(token, forKey: "newToken")`
- Key값만 같다면 값이 갱신될 것이라고 생각했지만, 갱신이 되지 않아 무한 리콜 발생   

### **해결** - UserDefaults 저장 로직 통일
- UserDefault 속성 래퍼가 해당 값을 UserDefaults.standard와 제대로 동기화하지 않거나 UserDefaults를 업데이트하는 서로 다른 방법을 혼합하는 경우 **Old Value**(이전 값)가 반환  
- 그러므로 토큰 갱신시에도,  `UserDefault.accessToken` 에 값을 대입하는 형식으로 해결   


<br> <br> 


# 🤔 회고

### - 네트워크 로직 구성에 대한 고민
- 제네릭을 사용해 다양한 API를 처리하고 있지만, 유저, 토큰, 포스트와 같은 API 라우터가 분리되어 있어 코드 중복이 발생
- 여러 ViewController에서 비슷한 방식으로 화면을 전환해야 할 때, 화면 전환 로직을 한 번만 정의해 두면 중복 코드를 제거해야할 필요성을 느낌


### - 향후 계획
- 네트워크 요청 로직을 더욱 개선해 코드 중복을 최소화하고, 보다 유연한 API 구조를 적용할 예정
- 페이지네이션 최적화를 통해 더 큰 데이터셋에서도 성능 저하 없는 사용자 경험(UX)을 제공
- 네트워크 오류 처리 시 사용자 경험을 개선하기 위한 추가적인 에러 핸들링 로직 도입 계획
