import geopandas as gpd
import pandas as pd
from fiona.crs import from_epsg
from shapely.geometry import Point, Polygon
from h3 import h3

#파일을  geoDataFrame로 읽음
def readfile_to_gdf(file_lo,en='cp949'):
    shp_file = gpd.read_file(file_lo, encoding=en)
    result = gpd.GeoDataFrame(shp_file)
    return result

#DataFrame의 gemetry 칼럼을 위도 경도 칼럼을 사용하여 생성 및 수정
def fill_geometry(input_df, lat_column='lat', lon_column='lon',crs=4326):
    geo = gpd.points_from_xy(input_df[lat_column], input_df[lon_column])
    geodf= gpd.GeoDataFrame(input_df, geometry=geo, crs=from_epsg(crs))
    return geodf

#geometry을 사용하여 위도 경도 칼럼 생성
def geo_to_lat_lon(input_df,crs=4326):
    df = input_df.copy()
    df['center_point'] = df['geometry'].geometry.centroid #geometry에서 중앙 좌표 가져옴
    df['center_point'] = df['center_point'].to_crs(crs) #해당 칼럼 좌표계 4329로 설정
    df['lon'] = df['center_point'].map(lambda x: x.xy[0][0])
    df['lat'] = df['center_point'].map(lambda x: x.xy[1][0])
    return df


#h3 폴리곤 생성
def to_polygon(l): 
    return Polygon(h3.h3_to_geo_boundary(l, geo_json=True))

#geoDataFrame의 geometry를 사용하여 h3 생성
def make_h3(input_df, lat_column='lat', lon_column='lon', crs='4326', res=8, k=10):
    df_h3 = h3.geo_to_h3(input_df[lat_column], input_df[lon_column], resolution=res)
    neighbors = h3.k_ring(df_h3, k=k)
    new_df = gpd.GeoDataFrame({'h3': list(neighbors)})
    new_df['geometry'] = new_df['h3'].apply(to_polygon)
    new_df = new_df.set_crs(crs)
    return new_df

