
# 🎁 Share.D 
- 선물 고민을 덜 수 있게 다양한 카테고리 제공과 선물에 대한 사람들의 의견을 공유하는 어플   


<br> <br> 
   ![poster](./ShareDPic.png)

<br> <br> 
# 🙋‍♀️ 프로젝트 주요 기능 
- 회원가입, 로그인
- 추천 선물 카테고리
- 선물 상세화면 및 질문 작성
- 커뮤니티 기능 (사람들과 경험 공유 가능)
- 게시글에 좋아요, 댓글 기능
- 내가 좋아요한, 구매한 목록 
- 선물 결제 기능

<br> <br> 

# 🧑🏻‍💻 프로젝트 개발환경
- 1인 개발(iOS)
- 개발기간 : 2024.08.14 ~ 2024.09.01 (약 2주)
- iOS 최소 버전: iOS 15.0+   


<br> <br> 

   
# 🛠 프로젝트 기술스택
- 아키텍처 및 디자인 패턴: MVVM(Model-View-ViewModel)
- 반응형 프로그래밍: RxSwift(Input, Output 패턴)
- 네트워크 통신 및 API: Alamofire, iamport-iOS
- UI 및 이미지 처리: UIKit, PhotosUI, Kingfisher

<br> <br> 

# 👉  상세 기능 구현 설명

###   - **네트워크 로직 관리**
- URLRequestConvertible로 라우터 패턴을 구성하기 위해 Alamofire 사용
- 각 API 엔드포인트의 URL, 헤더 및 매개변수를 중앙 집중식으로 관리할 수 있어 확장성 및 유지관리성이 향상
- 제네릭 타입 활용하여 다양한 Decodable 모델에 대응
- Single을 통한 비동기 처리
 
<br>

###  - **네트워크 에러 상태코드 처리**
- 네트워크 결과에 따른 처리 결과 > 뷰모델에서 핸들링
- 일반적인 오류 처리를 위한 BaseViewModel에 judgeStatusCode메서드 구현
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
- 에러 처리 유연성을 위한 함수 재정의
    - 일반적인 경우가 아닌 특정 페이지에 한정된 오류 시나리오의 경우 개별 ViewModel 클래스가 judgeStatusCode(statusCode:title:) 메서드를 재정의
- 오류 처리 방법이 일관된고, 유저에게 보여줄 에러문과 그 외의 에러문 역시 쉽게 구별 가능.

<br>

###  - **토큰 관리**
 - Access 토큰과 Refresh 토큰을 UserDefaults에 저장
 - Alamofire의 `RequestInterceptor`  를 사용하여 토큰 재발급 후, 사용자가 실행한 동작 자동으로 재실행하도록 구현

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
     - 마지막 페이지일 때, cursor를 0으로 받아와 네트워크 요청 X
 - 네이버 쇼핑 API   
      - 오프셋 기반 페이지네이션

<br><br>



# 👿 트러블슈팅 😈

##  Refresh Token 갱신

###  - 해결 과정 Flow

### **문제 1**:  **토큰이 만료되면 앱 종료 후, 재로그인하여 토큰갱신**  

- **원인**: 네트워킹 방식이 기본적인 API 요청과 응답을 처리하도록 설계. 토큰 만료 또는 리프레시 메커니즘에 대한 특별한 처리하지 않음.

- **해결**:  특정 상태 코드,  419(액세스 토큰 만료)를 처리하는 코드를 네트워크 메서드에 직접 추가   
    👉 네트워크 메서드가 토큰을 새로 고치거나 오류를 반환(다른 에러코드일 경우)    
    👉  토큰 만료로 인해 사용자가 경험하는 앱 종료 후, 재로그인 감소  

### **문제2**:   **리프레시 토큰을 활용하여, 액세스 토큰 갱신까지는 성공이지만 기능이 실행 X.**

- **원인**: 토큰을 갱신했다고 해서, 해당 메서드를 자동으로 재실행 X  
👉 **사용자가 해당 기능을 두 번 클릭하여 실행 시켜야하는 문제 발생**  


- **해결**:   토큰 갱신 후, 요청 메서드를 다시 실행하도록 코드 수정   

### **문제3**:  메서드 내의 코드가 비대해지고, 관리가 힘들어짐

- **해결**:   Alamofire의 RequestInterceptor 사용    
👉 토큰 갱신과 관련된 로직 중앙화 가능   
 👉 **adapt Function**으로 저장된 액세스 토큰을 가져와, 요청의 HTTP 헤더 중 Authorization 필드에 추가   
 👉 헤더에 토큰을 추가한 후, completion(.success(request))를 호출하여 수정된 request를 성공적으로 반환   
👉 **retry Function**의 경우(토큰 만료(HTTP 419)), 토큰 갱신 API를 호출하여 새 토큰을 받아온 후, 해당 요청을 다시 시도  


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

1. **문제**: 
로그인 시, 액세스 토큰 저장 방법   
`UserDefault.accessToken = "token"`,   
토큰 갱신 시, 액세스 토큰 저장 방법(Key값은 동일) `UserDefaults.standard.setValue(token, forKey: "newToken")`
Key값만 같다면 값이 갱신될 것이라고 생각했지만, 갱신이 되지 않아 무한 리콜 발생   

2. **해결**: UserDefault 속성 래퍼가 해당 값을 UserDefaults.standard와 제대로 동기화하지 않거나 UserDefaults를 업데이트하는 서로 다른 방법을 혼합하는 경우 **Old Value**가 발생  
그러므로 토큰 갱신시에도,  `UserDefault.accessToken` 에 값을 대입하는 형식으로 해결   





