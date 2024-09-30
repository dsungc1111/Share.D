
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
- 개발기간
    - 2024.08.14 ~ 2024.09.01(약 2주)
- iOS 최소 버전
    - iOS 15.0+   


<br> <br> 

   
# 🛠 프로젝트 기술스택
- 아키텍처 및 디자인 패턴
    - MVVM: Model-View-ViewModel 패턴
    - RxSwift Input, Output pattern: 반응형 프로그래밍을 활용한 데이터 흐름 처리
- 네트워크 통신 및 API
    - Alamofire: HTTP 네트워킹 라이브러리
    - iamport-iOS: 결제 모듈
- UI 및 이미지 처리
    - UIKit: iOS 앱 UI 구성 라이브러리
    - PhotosUI: 사진 및 미디어 관련 UI 구성
    - Kingfisher: 이미지 다운로드 및 캐싱 라이브러리

<br> <br> 


# 👿 트러블슈팅 😈

##  Refresh Token 갱신

###  - 해결 과정 Flow

1. 네트워킹 방식이 기본적인 API 요청과 응답을 처리하도록 설계. 토큰 만료 또는 리프레시 메커니즘에 대한 특별한 처리 X.       
👉 **토큰이 만료되면 앱 종료 후, 재로그인하여 토큰갱신**  
👉 좋은 UX 저해, 지속적인 작업에 방해
 

2.  특정 상태 코드,  419(액세스 토큰 만료)를 처리하는 코드를 네트워크 메서드에 직접 추가   
     👉 네트워크 메서드가 토큰을 새로 고치거나 오류를 반환(다른 에러코드일 경우)    
     👉  토큰 만료로 인해 사용자가 경험하는 앱 종료 후, 재로그인 감소  
     👉  But, 리프레시 토큰을 활용하여, 액세스 토큰 갱신까지는 성공이지만 그런데 왜 기능이 실행되지 않을까?   
     👉 토큰을 갱신했다고 해서, 해당 메서드를 자동으로 재실행 시켜주는 것은 아니므로, **사용자가 두 번 해당 메서드를 클릭하여 실행 시켜야하는 문제가 다시 발생**  


3. 토큰 갱신 후, 요청 메서드를 다시 실행하도록 코드 수정   
👉 메서드 내의 코드가 비대해지고, 관리가 힘들어짐

4. Alamofire의 RequestInterceptor 사용    
👉 토큰 갱신과 관련된 로직 중앙화 가능   

- 토큰 갱신과 관련된 로직 중앙화 가능
- **adapt Function**으로 저장된 액세스 토큰을 가져와, 요청의 HTTP 헤더 중 Authorization 필드에 추가
- 헤더에 토큰을 추가한 후, completion(.success(request))를 호출하여 수정된 request를 성공적으로 반환
- **retry Function**의 경우(토큰 만료(HTTP 419)), 토큰 갱신 API를 호출하여 새 토큰을 받아온 후, 해당 요청을 다시 시도  


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

- 토큰의 키값은 모두 같을 때, 
- UserDefault.accessToken = "token" **VS** UserDefaults.standard.setValue(newToken, forKey: "newToken")


```swift
@propertyWrapper
struct UserDefault<T> {
    
    let key: String
    let defaultValue: T
    
    var wrappedValue: T {
        get {
            UserDefaults.standard.string(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: key)
        }
    }
}

final class UserDefaultManager {
    
    private enum UserDefaultKey: String {
        case access
        case refresh
        case userNickname
        case userId
        case profile
    }
    
    
    static let shared = UserDefaultManager()
    
    private init() {}
    
    @UserDefault(key: UserDefaultKey.access.rawValue, defaultValue: "")
    static var accessToken
    
    @UserDefault(key: UserDefaultKey.refresh.rawValue, defaultValue: "")
    static var refreshToken
    
    @UserDefault(key: UserDefaultKey.userNickname.rawValue, defaultValue: "")
    static var userNickname
    
    @UserDefault(key: UserDefaultKey.userId.rawValue, defaultValue: "")
    static var userId
    
    @UserDefault(key: UserDefaultKey.profile.rawValue, defaultValue: "")
    static var profileImage
}
```
- 최초 로그인 시, UserDefault.accessToken = "token" 를 활용하여, 토큰 저장
- 리프레시 코드 실행시, UserDefaults.standard.setValue(newToken, forKey: "newToken")로 토큰 갱신
- **key**값만 같다면, 어떤 방법을 활용하던, 값이 갱신될 것이라고 생각했지만, 갱신이 되지 않아 무제한 리콜 발생
-  print했을 때, 값은 같게 나오지만 접근하는 메모리의 주소가 달라 갱신이 안됨
- 토큰 갱신시에도,  UserDefault.accessToken 에 값을 대입하는 형식으로 해결
- UserDefault를 정의해 놓았기 때문에, 이를 구현해놓은 UserDefaultsManager파일 이외의 파일에서 
UserDefaults.standard.setValue코드를 굳이 사용할 이유가 없음.




