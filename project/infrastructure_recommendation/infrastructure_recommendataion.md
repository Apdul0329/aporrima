# Infrastructure Recommendation

## Contents
1. [multiple_regression_model.py](#multiple_regression_modelpy)
2. [scaler_set.py](#scaler_setpy)
3. [optimizer_set.py](#optimizer_setpy)
4. [address_to_long_and_lat.py](#address_to_long_and_latpy)
5. [geoDataFrame_init.py](#geoDataFrame init)
6. [geoDataFrame_using.py](#geoDataFrame additional function)
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

### Usage
```python
from address_to_long_and_lat import address_to_latlon

# 함수 실행 후 Kakao Map API의 앱 키를 입력해야 함
address_to_latlon('경기도 용인시 수지구 죽전로 152')
```

## geoDataFrame_init.py

### Description

> csv파일 또는 shp 파일 등을 읽는 것부터 기본적인 데이터 처리(위도 경도 값을 통한 geometry 생성, h3 생성 등)를 모듈화
> 

### Parameters

- `file_lo` : 파일 위치
- `en` : 인코딩 방식 설정 (default : en=cp949)
- `input_df` : 작업할 dataFrame (geoDataFrame도 가능)
- `lat_column`, `lon_column` : 각각 위도와 경도 column명 (default : lat=‘lat’, lon=‘lon’)
- `crs` : 좌표계 설정 (default : crs=4326)
- `res` : h3 라이브러리의 resolution (default : res=8)
- `k` : h3 라이브러리의 k (default : k=11)

### Usage

```python
import geoDataFrame_init

#readfile_to_gdf
gdf1= geoDataFrame_init.readfile_to_gdf(file_lo ,en)
gdf2 = geoDataFrame_init.readfile_to_gdf(file_lo)

#fill_geometry
gdf1 = geoDataFrame_init.fill_geometry(input_df,'위도 column 명','경도 column 명',4326)
gdf2 = geoDataFrame_init.fill_geometry(input_df)

#geo_to_lat_lon
gdf1 = geoDataFrame_init.geo_to_lat_lon(input_df,4326)
gdf2 = geoDataFrame_init.geo_to_lat_lon(input_df)

#make_h3
gdf1 = geoDataFrame_init.make_h3(input_df,'위도 column 명','경도 column 명',4326,8,10)
gdf2 = geoDataFrame_init.make_h3(input_df)
```

## geoDataFrame_using.py

### Description

> geoDataFrame를 사용하여 지도를 표시하거나 두 개의 geoDataFrame를 비교하여 겹치는 데이터를 찾는 함수 모듈화
> 

### Parameters

- `df_list` : map에 표시할 geoDataFrame 리스트 (geoDataFrame 1개도 가능 리스트X)
- `lat`, `lon` : 각각 지도의 중심이 되는 위도와 경도 값
- `tiles` , `zoom_start` : folium라이브러리의 tiles, zoom_start (default : tiles="OpenStreetMap",zoom_start=11)
- `lat_column`, `lon_column` : 각각 위도와 경도 column명 (default : lat = ‘lat’, lon = ‘lon’)
- `df_a` : 속하는지 확인할 geoDataFrame
- `df_b` : 비교 대상이 되는 geoDataFrame
- `crs` : 좌표계 설정 (default : crs=4326)

### Usage

```python
import geoDataFrame_init

#display_gdf_map
display(geoDataFrame_using.display_gdf_map(df_list,lat,lon,"OpenStreetMap",11))
display(geoDataFrame_using.display_gdf_map(df_list,lat,lon))
display(geoDataFrame_using.display_gdf_map(df,lat,lon))

#check_intersect
gdf1 = geoDataFrame_init.check_intersect(df_a, df_b,4326)
gdf2 = geoDataFrame_init.check_intersect(df_a, df_b)

```
