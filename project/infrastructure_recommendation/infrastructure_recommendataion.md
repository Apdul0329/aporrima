# Infrastructure Recommendation

## Contents
1. [multiple_regression_model.py](#multiple-regression-modelpy)
2. [scaler_set.py](#scaler-setpy)
3. [optimizer_set.py](#optimizer-setpy)
4. [address_to_long_and_lat.py](#address-to-long-and-latpy)
## multiple_regression_model.py

### Description

> Pytorch의 nn.module을 상속하는 다중선형회귀 모델 클래스를 모듈화함
> 클래스 생성자를 통해 모델을 생성 시, 독립변수의 개수를 나타내는 num을 초기화해야 함

### Usage
```python
from multiple_regression_model import RegressionModel

num = ...
model = RegressionModel(num)
```

## scaler_set.py

### Description

> Pytorch의 Tensor를 자료형으로 갖는 독립변수 x, 종속변수 y를 매개변수로 받아 sklearn 라이브러리의 scaler를 적용을 함수로 모듈화함.
> sklearn 라이브러리의 스케일러 중 StandardScaler, MinMaxScaler, RobustScaler, Normalizer, QuantileTransformer를 모듈화함

### Usage
```python
import scaler_set

# sklearn의 StandardScaler를 통한 정규화 예시
train_x, train_y = scaler_set.standard(x=train_x, y=train_y)

# sklearn의 MinMaxScaler를 통한 정규화 예시
train_x, train_y = scaler_set.min_max(x=train_x, y=train_y)

# sklearn의 RobustScaler를 통한 정규화 예시
train_x, train_y = scaler_set.robust(x=train_x, y=train_y)

# sklearn의 Normalizer를 통한 정규화 예시
train_x, train_y = scaler_set.normalize(x=train_x, y=train_y)

# sklearn의 QuantileTransformer를 통한 정규화 예시
train_x, train_y = scaler_set.quantile(x=train_x, y=train_y)
```

## optimizer_set.py

### Description
> Pytorch의 nn.MSELoss() 손실함수와 optim.SGD()(경사하강법)을 통해 모델 최적화를 하는 함수 모듈화 함
> 매개 변수로 torch.nn.Module 타입의 model / Tensor 타입의 x, y / float 타입의 epoch와 lr을 받음

### Usage
```python
from multiple_regression_model import RegressionModel
import scaler_set
import optimizer_set

# 다중선형회귀분석 모델 객체 생성 예시
num = ...
model = RegressionModel(num)

# scaler_set 모듈의 standard()를 통한 데이터 스케일링 예시 
train_x, train_y = scaler_set.standard(x=train_x, y=train_y)

# optimizer_set 모듈의 sgd()릍 통한 최적화 예시
optimizer_set.sgd(model=model, x=train_x, y=train_y, lr=0.01)
```

## address_to_long_and_lat.py

### Description

> Kakao Map API를 사용하여 지오코딩으로 주소(지번 주소, 도로명 주소)를 위경도로 바꿔주는 함수 모듈화 함
> 매개 변수로 string 타입의 address를 받음
```python
from address_to_long_and_lat import address_to_latlon

# 함수 실행 후 Kakao Map API의 앱 키를 입력해야 함
address_to_latlon('경기도 용인시 수지구 죽전로 152')
```
