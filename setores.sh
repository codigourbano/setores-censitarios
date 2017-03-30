# !/bin/bash

################################################
# setores.sh - Command line utility for IBGE data
################################################
usage="setores <sector id pattern>";


FORMAT_NAME="ESRI Shapefile";
DATA_DIR=./data;
FTP_URL=ftp://geoftp.ibge.gov.br/organizacao_do_territorio/malhas_territoriais/malhas_de_setores_censitarios__divisoes_intramunicipais/censo_2010/setores_censitarios_shp/

BR_STATE[11]="RO";
BR_STATE[12]="AC";
BR_STATE[13]="AM";
BR_STATE[15]="PA";
BR_STATE[16]="AP";
BR_STATE[17]="TO";
BR_STATE[21]="MA";
BR_STATE[22]="PI";
BR_STATE[23]="CE";
BR_STATE[24]="RN";
BR_STATE[25]="PB";
BR_STATE[26]="PE";
BR_STATE[27]="AL";
BR_STATE[28]="SE";
BR_STATE[29]="BA";
BR_STATE[31]="MG";
BR_STATE[32]="ES";
BR_STATE[33]="RJ";
BR_STATE[35]="SP";
BR_STATE[41]="PR";
BR_STATE[42]="SC";
BR_STATE[43]="RS";
BR_STATE[50]="MS";
BR_STATE[51]="MT";
BR_STATE[52]="GO";
BR_STATE[53]="DF";

# Parse options
while getopts ":f:" opt; do
  case $opt in
    f ) FORMAT_NAME=$OPTARG;;
    \? ) echo $usage
          exit 1;;
  esac
done

shift $(($OPTIND - 1));

# Parameters
pattern="$1";
state=${pattern:0:2};

# TODO Check for valid formats

# Download sector's zipfiles
#
# params: $statePrefix - prefix of state to be downloaded
function downloadSectors {
  local statePrefix
  statePrefix=$(echo "$1" | tr '[:upper:]' '[:lower:]');
  mkdir -p $DATA_DIR/source;

  (cd $DATA_DIR/source; wget --continue \
       -nd --cut-dirs=3 \
       --recursive -A "$statePrefix*setores_censitarios.zip" $FTP_URL;)
}

downloadSectors;

mkdir -p $DATA_DIR
rm "$DATA_DIR/$pattern.*"
for zipfile in $DATA_DIR/source/*.zip;
do
  echo "Extracting sectors with id $pattern ...";
  ogr2ogr -append  \
    -where "CD_GEOCODI LIKE '$pattern%'" \
    -t_srs EPSG:4326 \
    $DATA_DIR/$pattern.shp \
    /vsizip/${zipfile}
done
