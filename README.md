# EJPhotoStorage


###나만의 사진 보관함

이미지를 검색하여 나만의 사진보관함을 만듭니다 
사진 보관함에서 카메라롤에 저장도 가능합니다

---

### 기능 

첫번째 화면 : 검색 페이지
- 검색 : 검색창에서 원하는 키워드를 입력해주세요
- 결과 : 검색 결과를 터치하면 상세화면이 보입니다
- 저장 : 상세화면엣 저장 버튼을 누르면 해당 이미지가 저장됩니다

두번째 화면 : 나만의 보관함
- 보관 이미지 : 내가 저장한 이미지들을 보관함에 모아보세요
- 상세화면 : 이미지를 누르면 상세화면이 보입니다
- 저장 : 보관한 이미지가 카메라롤에 저장됩니다


### 화면


### 구성

Design Patter : MVC 패턴 사용

View 
- Main.Stroyboard : 5가지 주요 Scene이 있습니다
- ResultDetailCollectionViewCell.xib : 검색 결과의 상세화면을 보여주는 collectionview 셀 xib
- PhotoDetailCollectionViewCell.xib : 보관함 이미지 상세화면으 보여주는 collectionview 셀 xib
- 그 외의 Cell UIView들
> ResultCollectionViewCell
> ResultDetailCollectionViewCell
> StorageCollectionViewCell
> PhotoDetailCollectionViewCell

Controller
- BasicViewController : 모든 ViewController의 베이스가 되는 VC. AlertViewController를 선언
- MainViewController : 검색하고 결과를 보여주는 ViewController
- MainDetailViewController : 검색 결과의 상세화면을 보여주는 ViewController
- StorageViewController : 보관함을 관리하는 ViewController
- StorageDetailViewController : 보관함의 상세화면으 보여주는 ViewController

Model
- 네트워크 서비스를 담당하는 모델
> ImageOperations
> NetworkManager

- API 결과 모델
> SearchOperator
> SearchResult
> Meta
> Document


Extensions
- Extension : 
