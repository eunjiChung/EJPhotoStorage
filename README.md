# EJPhotoStorage


### 나만의 사진 보관함:fireworks:
github: https://github.com/eunjiChung/EJPhotoStorage.git

이미지를 검색하여 나만의 사진보관함을 만듭니다 
사진 보관함에서 카메라롤에 저장도 가능합니다



## 기능 

첫번째 화면 : 검색 페이지
- 검색 : 검색창에서 원하는 키워드를 입력해주세요
- 결과 : 검색 결과를 터치하면 상세화면이 보입니다
- 저장 : 상세화면엣 저장 버튼을 누르면 해당 이미지가 저장됩니다

두번째 화면 : 나만의 보관함
- 보관 이미지 : 내가 저장한 이미지들을 보관함에 모아보세요
- 상세화면 : 이미지를 누르면 상세화면이 보입니다
- 저장 : 보관한 이미지가 카메라롤에 저장됩니다



## 화면
![메인화면](./EJPhotoStorage/main.jpeg) ![상세화면](./EJPhotoStorage/detail.jpeg) ![보관함](./EJPhotoStorage/storage.jpeg)


## 사용한 CocoaPod Library
- ESPullToRefresh : CollectionView를 refresh하고 infiniteScrolling을 가능하게 해준다

## 구성

### Design Patter : MVC 패턴 사용

### View 
- Main.Stroyboard : 5가지 주요 Scene이 있습니다
- ResultDetailCollectionViewCell.xib : 검색 결과의 상세화면을 보여주는 collectionview 셀 xib
- PhotoDetailCollectionViewCell.xib : 보관함 이미지 상세화면으 보여주는 collectionview 셀 xib
- 그 외의 Cell UIView들
> 1. ResultCollectionViewCell
> 2. ResultDetailCollectionViewCell
> 3. StorageCollectionViewCell
> 4. PhotoDetailCollectionViewCell

### Controller
- BasicViewController : 모든 ViewController의 베이스가 되는 VC. AlertViewController를 선언
- MainViewController : 검색하고 결과를 보여주는 ViewController
- MainDetailViewController : 검색 결과의 상세화면을 보여주는 ViewController
- StorageViewController : 보관함을 관리하는 ViewController
- StorageDetailViewController : 보관함의 상세화면으 보여주는 ViewController

### Model
- EJLibrary : API path, AppKey 같은 주요 정보와 Constraint 사이즈 조정, Request 요청을 위한 파라미터 가공 등 잡다한 것을 담당하는 Singleton 라이브러리

- 네트워크 서비스를 담당하는 모델
> 1. ImageOperations : Operation으로 이미지 검색과 동영상 검색 요청 수행하는 Thread 생성 후 관리. 이미지 링크로 이미지를 다운로드하는 ImageDownload도 포함. ImageCache를 포함한다
> 2. NetworkManager : URLSession으로 네트워크 통신하는 class 

- API 결과 모델
> 1. SearchOperator : 검색에 대한 전체적인 기능 수행, 파라미터 저장을 담당. Data를 decode하고, 이미지 검색 결과와 동영상 검색 결과를 합친다
> 2. SearchResult : Meta와 Documets 정보를 가지는 최상위 Decodable 클래스
> 3. Meta : 페이지 정보를 전달하는 구조체
> 4. Documents : 이미지 검색, 동영상 검색 요청으로 얻은 data 중 이미지 url과 datetime을 공통으로 가지고, 나머지는 자유롭게 저장하는 클래스


### Extensions
- Extension : UIImageView에서 직접 이미지를 다운로드하고 캐싱할 수 있도록 extension해줌













