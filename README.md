O IBGE disponibiliza para [arquivos shape de setores censitários em seu FTP](ftp://geoftp.ibge.gov.br/malhas_digitais/censo_2010/setores_censitarios). Não há maneira de baixar todos os arquivos de uma só vez, é preciso acessar um a um. Uma solução alternativa é usar o programa de linha de comando [wget](http://gnuwin32.sourceforge.net/packages/wget.htm), que pode ser instalado das seguintes maneiras:

* Windows: [Instalador executável](https://eternallybored.org/misc/wget/)
* linux: `apt-get install wget`
* OSX: `brew install wget` (necessita do gerenciador de pacotes [brew](http://brew.sh/))

# Como baixar os arquivos

Crie um diretório local e seguinte rode o comando para fazer um espelho de todos os shapefiles do Censo 2010:

```
wget --continue \
     --cut-dirs=3 \
     --recursive \
    ftp://geoftp.ibge.gov.br/malhas_digitais/censo_2010/setores_censitarios/
```

Para baixar apenas os setores em um único diretório:

```
wget --continue \
     -nd --cut-dirs=3 \
     --recursive -Asetores_censitarios.zip \
     ftp://geoftp.ibge.gov.br/malhas_digitais/censo_2010/setores_censitarios/
```
