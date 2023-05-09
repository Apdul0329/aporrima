import geopandas as gpd
import folium


# geoDataFrame를 map에 그림 (여러개의 geoDataFrame를 그리는 것도 가능)
def display_gdf_map(df_list,lat,lon,tiles="OpenStreetMap",zoom_start=11):
    m = folium.Map(location=[lat, lon], tiles=tiles, zoom_start=zoom_start)
    if not(isinstance(df_list, list)):
        folium.GeoJson(df_list).add_to(m)
    else :
        for i in range(len(df_list)):
            folium.GeoJson(df_list[i]).add_to(m)
    return m

    
#B geoDataFrame에 속하는 A geoDataFrame만 찾는 함수
def check_intersect(df_a, df_b,crs=4326):
    crs = str(crs)
    df_a = df_a.to_crs(epsg=crs)
    df_b = df_b.to_crs(epsg=crs)
    result = gpd.sjoin(df_a, df_b, how='inner', op="intersects")
    return result
