# !/bin/bash

FTP_URL=ftp://geoftp.ibge.gov.br/organizacao_do_territorio/malhas_territoriais/malhas_de_setores_censitarios__divisoes_intramunicipais/censo_2010/setores_censitarios_shp/

# download zips from IBGE FTP
mkdir -p dados/zips && cd "$_"
wget --continue \
     -nd --cut-dirs=3 \
     --recursive -Asetores_censitarios.zip $FTP_URL

# expand shapefiles from zips
mkdir -p dados/sirgas-2000 && cd "$_"
unzip '../zips/*.zip'

# change spatial reference to EPSG 4326
mkdir -p dados/epsg-4326 && cd "$_"
for shapefile in ../sirgas-2000/*.shp;
do
  echo "Reprojecting `basename -s .shp $shapefile` to EPSG 4326 ...";
  ogr2ogr -t_srs EPSG:4326 `basename -s .shp $shapefile`.shp ${shapefile}
done

# convert to TopoJSON format
mkdir -p dados/topojson && cd "$_"
for shapefile in ../epsg-4326/*.shp;
do
  echo "Coverting `basename -s .shp $shapefile` to TopoJSON format...";
  topojson --id-property "CD_GEOCODI" -p "CD_GEOCODB" -o `basename -s .shp $shapefile`.json -- $shapefile
done
