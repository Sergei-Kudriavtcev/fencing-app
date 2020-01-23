<?xml version="1.0" encoding="UTF-8"?>
<!-- 
Fencing Time
By Daniel Berke
(C) Copyright by Daniel Berke 
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.fencingtime.com">
  <xsl:variable name="fileVersion2">4.4</xsl:variable>

  <!-- Convert FRED DivisionIDs to division and country -->	
  <xsl:template name="FredDivIDToDivAndCountry">
    <xsl:param name="fid" />
    <Division>
      <xsl:choose>
        <xsl:when test="$fid='54'">USFA|Alabama</xsl:when>   
        <xsl:when test="$fid='13'">USFA|Alaska</xsl:when>   
        <xsl:when test="$fid='46'">USFA|Arizona</xsl:when>   
        <xsl:when test="$fid='63'">USFA|Ark-La-Miss</xsl:when>   
        <xsl:when test="$fid='47'">USFA|Border TX</xsl:when>   
        <xsl:when test="$fid='25'">USFA|Capitol</xsl:when>   
        <xsl:when test="$fid='3'">USFA|Central CA</xsl:when>   
        <xsl:when test="$fid='55'">USFA|Central FL</xsl:when>   
        <xsl:when test="$fid='26'">USFA|Central PA</xsl:when>   
        <xsl:when test="$fid='48'">USFA|Colorado</xsl:when>   
        <xsl:when test="$fid='18'">USFA|Columbus OH</xsl:when>   
        <xsl:when test="$fid='39'">USFA|Connecticut</xsl:when>   
        <xsl:when test="$fid='56'">USFA|Gateway FL</xsl:when>   
        <xsl:when test="$fid='57'">USFA|Georgia</xsl:when>   
        <xsl:when test="$fid='58'">USFA|Gold Coast</xsl:when>   
        <xsl:when test="$fid='82'">USFA|Green Mt.</xsl:when>   
        <xsl:when test="$fid='64'">USFA|Gulf Coast</xsl:when>
        <xsl:when test="$fid='27'">USFA|Harrisburg</xsl:when>
        <xsl:when test="$fid='15'">USFA|Hawaii</xsl:when>
        <xsl:when test="$fid='40'">USFA|Huds-Berks</xsl:when>
        <xsl:when test="$fid='33'">USFA|Illinois</xsl:when>
        <xsl:when test="$fid='19'">USFA|Indiana</xsl:when>
        <xsl:when test="$fid='2'">USFA|Inland Emp</xsl:when>
        <xsl:when test="$fid='34'">USFA|Iowa</xsl:when>
        <xsl:when test="$fid='49'">USFA|Kansas</xsl:when>
        <xsl:when test="$fid='22'">USFA|Kentucky</xsl:when>
        <xsl:when test="$fid='41'">USFA|Long Island</xsl:when>
        <xsl:when test="$fid='65'">USFA|Louisiana</xsl:when>
        <xsl:when test="$fid='28'">USFA|Maryland</xsl:when> 
        <xsl:when test="$fid='24'">USFA|Metro NYC</xsl:when>
        <xsl:when test="$fid='20'">USFA|Michigan</xsl:when> 
        <xsl:when test="$fid='35'">USFA|Minnesota</xsl:when> 
        <xsl:when test="$fid='4'">USFA|Mt. Valley</xsl:when>
        <xsl:when test="$fid='69'">USFA|National</xsl:when>  
        <xsl:when test="$fid='50'">USFA|Nebr-S.Dak</xsl:when>
        <xsl:when test="$fid='14'">USFA|Nevada</xsl:when>   
        <xsl:when test="$fid='42'">USFA|New England</xsl:when>
        <xsl:when test="$fid='29'">USFA|New Jersey</xsl:when> 
        <xsl:when test="$fid='51'">USFA|New Mexico</xsl:when> 
        <xsl:when test="$fid='59'">USFA|N. Carolina</xsl:when>
        <xsl:when test="$fid='5'">USFA|North Coast</xsl:when>
        <xsl:when test="$fid='66'">USFA|North TX</xsl:when>   
        <xsl:when test="$fid='43'">USFA|Northeast</xsl:when>  
        <xsl:when test="$fid='294'">USFA|Northeast PA</xsl:when>
        <xsl:when test="$fid='6'">USFA|Northern CA</xsl:when>
        <xsl:when test="$fid='21'">USFA|Northern OH</xsl:when>
        <xsl:when test="$fid='67'">USFA|Oklahoma</xsl:when>   
        <xsl:when test="$fid='7'">USFA|Orange Coast</xsl:when>
        <xsl:when test="$fid='11'">USFA|Oregon</xsl:when>   
        <xsl:when test="$fid='30'">USFA|Philadelphia</xsl:when>
        <xsl:when test="$fid='52'">USFA|Plains TX</xsl:when>   
        <xsl:when test="$fid='8'">USFA|San Bern'do</xsl:when> 
        <xsl:when test="$fid='9'">USFA|San Diego</xsl:when>   
        <xsl:when test="$fid='60'">USFA|S. Carolina</xsl:when> 
        <xsl:when test="$fid='31'">USFA|S. Jersey</xsl:when>   
        <xsl:when test="$fid='68'">USFA|South TX</xsl:when>
        <xsl:when test="$fid='10'">USFA|Southern CA</xsl:when> 
        <xsl:when test="$fid='23'">USFA|Southwest OH</xsl:when>
        <xsl:when test="$fid='36'">USFA|St. Louis</xsl:when> 
        <xsl:when test="$fid='61'">USFA|Tennessee</xsl:when>
        <xsl:when test="$fid='12'">USFA|Utah-S.Idaho</xsl:when>
        <xsl:when test="$fid='62'">USFA|Virginia</xsl:when>
        <xsl:when test="$fid='44'">USFA|West-Rock</xsl:when>
        <xsl:when test="$fid='45'">USFA|Western NY</xsl:when>
        <xsl:when test="$fid='32'">USFA|Western PA</xsl:when>
        <xsl:when test="$fid='1'">USFA|Western WA</xsl:when>
        <xsl:when test="$fid='37'">USFA|Wisconsin</xsl:when>
        <xsl:when test="$fid='53'">USFA|Wyoming</xsl:when>
        
        <xsl:when test="$fid='70'">CFF|BC</xsl:when>
        <xsl:when test="$fid='71'">CFF|AB</xsl:when>
        <xsl:when test="$fid='72'">CFF|SK</xsl:when>
        <xsl:when test="$fid='73'">CFF|MB</xsl:when>
        <xsl:when test="$fid='74'">CFF|YT</xsl:when>
        <xsl:when test="$fid='75'">CFF|ON</xsl:when>
        <xsl:when test="$fid='76'">CFF|NB</xsl:when>
        <xsl:when test="$fid='77'">CFF|PE</xsl:when>
        <xsl:when test="$fid='78'">CFF|NU</xsl:when>
        <xsl:when test="$fid='79'">CFF|QC</xsl:when>
        <xsl:when test="$fid='80'">CFF|NS</xsl:when>
        <xsl:when test="$fid='81'">CFF|NL</xsl:when>
      </xsl:choose>
    </Division>	
    <Country>
      <xsl:choose>
        <xsl:when test="$fid='70'">CAN</xsl:when>
        <xsl:when test="$fid='71'">CAN</xsl:when>
        <xsl:when test="$fid='72'">CAN</xsl:when>
        <xsl:when test="$fid='73'">CAN</xsl:when>
        <xsl:when test="$fid='74'">CAN</xsl:when>
        <xsl:when test="$fid='75'">CAN</xsl:when>
        <xsl:when test="$fid='76'">CAN</xsl:when>
        <xsl:when test="$fid='77'">CAN</xsl:when>
        <xsl:when test="$fid='78'">CAN</xsl:when>
        <xsl:when test="$fid='79'">CAN</xsl:when>
        <xsl:when test="$fid='80'">CAN</xsl:when>
        <xsl:when test="$fid='81'">CAN</xsl:when>

        <xsl:when test="$fid='83'">AUS</xsl:when>
        <xsl:when test="$fid='84'">MEX</xsl:when>
        <xsl:when test="$fid='85'">FRA</xsl:when>
        <xsl:when test="$fid='86'">GBR</xsl:when>
        <xsl:when test="$fid='87'">GER</xsl:when>
        <xsl:when test="$fid='90'">CAN</xsl:when>
        <xsl:when test="$fid='139'">CHN</xsl:when>
        <xsl:when test="$fid='184'">IRL</xsl:when>
        <xsl:when test="$fid='185'">ISR</xsl:when>
        <xsl:when test="$fid='186'">ITA</xsl:when>
        <xsl:when test="$fid='188'">JPN</xsl:when>
        <xsl:when test="$fid='242'">PUR</xsl:when>
        <xsl:when test="$fid='245'">RUS</xsl:when>
        <xsl:when test="$fid='264'">ESP</xsl:when>
        <xsl:when test="$fid='269'">SWE</xsl:when>
        <xsl:when test="$fid='270'">SUI</xsl:when>
        <xsl:when test="$fid='101'">AFG</xsl:when>
        <xsl:when test="$fid='102'">ALB</xsl:when>
        <xsl:when test="$fid='103'">ALG</xsl:when>
        <xsl:when test="$fid='104'">ASA</xsl:when>
        <xsl:when test="$fid='105'">AND</xsl:when>
        <xsl:when test="$fid='106'">ANG</xsl:when>
        <xsl:when test="$fid='107'">ANT</xsl:when>
        <xsl:when test="$fid='108'">ARG</xsl:when>
        <xsl:when test="$fid='109'">ARM</xsl:when>
        <xsl:when test="$fid='110'">ARU</xsl:when>
        <xsl:when test="$fid='111'">AUT</xsl:when>
        <xsl:when test="$fid='112'">AZE</xsl:when>
        <xsl:when test="$fid='113'">BAH</xsl:when>
        <xsl:when test="$fid='114'">BRN</xsl:when>
        <xsl:when test="$fid='115'">BAN</xsl:when>
        <xsl:when test="$fid='116'">BAR</xsl:when>
        <xsl:when test="$fid='117'">BLR</xsl:when>
        <xsl:when test="$fid='118'">BEL</xsl:when>
        <xsl:when test="$fid='119'">BIZ</xsl:when>
        <xsl:when test="$fid='120'">BER</xsl:when>
        <xsl:when test="$fid='121'">BEN</xsl:when>
        <xsl:when test="$fid='122'">BHU</xsl:when>
        <xsl:when test="$fid='123'">BOL</xsl:when>
        <xsl:when test="$fid='124'">BIH</xsl:when>
        <xsl:when test="$fid='125'">BOT</xsl:when>
        <xsl:when test="$fid='126'">BRA</xsl:when>
        <xsl:when test="$fid='127'">IVB</xsl:when>
        <xsl:when test="$fid='128'">BRU</xsl:when>
        <xsl:when test="$fid='129'">BUL</xsl:when>
        <xsl:when test="$fid='130'">BUR</xsl:when>
        <xsl:when test="$fid='131'">BDI</xsl:when>
        <xsl:when test="$fid='132'">CAM</xsl:when>
        <xsl:when test="$fid='133'">CMR</xsl:when>
        <xsl:when test="$fid='134'">CPV</xsl:when>
        <xsl:when test="$fid='135'">CAY</xsl:when>
        <xsl:when test="$fid='136'">CAF</xsl:when>
        <xsl:when test="$fid='137'">CHA</xsl:when>
        <xsl:when test="$fid='138'">CHI</xsl:when>
        <xsl:when test="$fid='140'">COL</xsl:when>
        <xsl:when test="$fid='141'">COM</xsl:when>
        <xsl:when test="$fid='142'">CGO</xsl:when>
        <xsl:when test="$fid='144'">COK</xsl:when>
        <xsl:when test="$fid='145'">CRC</xsl:when>
        <xsl:when test="$fid='146'">CIV</xsl:when>
        <xsl:when test="$fid='147'">CRO</xsl:when>
        <xsl:when test="$fid='148'">CUB</xsl:when>
        <xsl:when test="$fid='149'">CYP</xsl:when>
        <xsl:when test="$fid='150'">CZE</xsl:when>
        <xsl:when test="$fid='151'">DEN</xsl:when>
        <xsl:when test="$fid='152'">DJI</xsl:when>
        <xsl:when test="$fid='153'">DMA</xsl:when>
        <xsl:when test="$fid='154'">DOM</xsl:when>
        <xsl:when test="$fid='155'">ECU</xsl:when>
        <xsl:when test="$fid='156'">EGY</xsl:when>
        <xsl:when test="$fid='157'">ESA</xsl:when>
        <xsl:when test="$fid='158'">GEQ</xsl:when>
        <xsl:when test="$fid='159'">ERI</xsl:when>
        <xsl:when test="$fid='160'">EST</xsl:when>
        <xsl:when test="$fid='161'">ETH</xsl:when>
        <xsl:when test="$fid='162'">FIJ</xsl:when>
        <xsl:when test="$fid='163'">FIN</xsl:when>
        <xsl:when test="$fid='164'">GAB</xsl:when>
        <xsl:when test="$fid='165'">GAM</xsl:when>
        <xsl:when test="$fid='166'">GEO</xsl:when>
        <xsl:when test="$fid='167'">GHA</xsl:when>
        <xsl:when test="$fid='168'">GRE</xsl:when>
        <xsl:when test="$fid='169'">GRN</xsl:when>
        <xsl:when test="$fid='170'">GUM</xsl:when>
        <xsl:when test="$fid='171'">GUA</xsl:when>
        <xsl:when test="$fid='172'">GUI</xsl:when>
        <xsl:when test="$fid='173'">GBS</xsl:when>
        <xsl:when test="$fid='174'">GUY</xsl:when>
        <xsl:when test="$fid='175'">HAI</xsl:when>
        <xsl:when test="$fid='176'">HON</xsl:when>
        <xsl:when test="$fid='177'">HKG</xsl:when>
        <xsl:when test="$fid='178'">HUN</xsl:when>
        <xsl:when test="$fid='179'">ISL</xsl:when>
        <xsl:when test="$fid='180'">IND</xsl:when>
        <xsl:when test="$fid='181'">INA</xsl:when>
        <xsl:when test="$fid='182'">IRI</xsl:when>
        <xsl:when test="$fid='183'">IRQ</xsl:when>
        <xsl:when test="$fid='187'">JAM</xsl:when>
        <xsl:when test="$fid='189'">JOR</xsl:when>
        <xsl:when test="$fid='190'">KAZ</xsl:when>
        <xsl:when test="$fid='191'">KEN</xsl:when>
        <xsl:when test="$fid='192'">PRK</xsl:when>
        <xsl:when test="$fid='193'">KOR</xsl:when>
        <xsl:when test="$fid='194'">KUW</xsl:when>
        <xsl:when test="$fid='195'">KGZ</xsl:when>
        <xsl:when test="$fid='196'">LAO</xsl:when>
        <xsl:when test="$fid='197'">LAT</xsl:when>
        <xsl:when test="$fid='198'">LIB</xsl:when>
        <xsl:when test="$fid='199'">LES</xsl:when>
        <xsl:when test="$fid='200'">LBR</xsl:when>
        <xsl:when test="$fid='201'">LBA</xsl:when>
        <xsl:when test="$fid='202'">LIE</xsl:when>
        <xsl:when test="$fid='203'">LTU</xsl:when>
        <xsl:when test="$fid='204'">LUX</xsl:when>
        <xsl:when test="$fid='205'">MKD</xsl:when>
        <xsl:when test="$fid='206'">MAD</xsl:when>
        <xsl:when test="$fid='207'">MAW</xsl:when>
        <xsl:when test="$fid='208'">MAS</xsl:when>
        <xsl:when test="$fid='209'">MDV</xsl:when>
        <xsl:when test="$fid='210'">MLI</xsl:when>
        <xsl:when test="$fid='211'">MLT</xsl:when>
        <xsl:when test="$fid='212'">MTN</xsl:when>
        <xsl:when test="$fid='213'">MRI</xsl:when>
        <xsl:when test="$fid='214'">FSM</xsl:when>
        <xsl:when test="$fid='215'">MDA</xsl:when>
        <xsl:when test="$fid='216'">MON</xsl:when>
        <xsl:when test="$fid='217'">MGL</xsl:when>
        <xsl:when test="$fid='218'">MAR</xsl:when>
        <xsl:when test="$fid='219'">MOZ</xsl:when>
        <xsl:when test="$fid='220'">MYA</xsl:when>
        <xsl:when test="$fid='221'">NAM</xsl:when>
        <xsl:when test="$fid='222'">NRU</xsl:when>
        <xsl:when test="$fid='223'">NEP</xsl:when>
        <xsl:when test="$fid='224'">NED</xsl:when>
        <xsl:when test="$fid='225'">AHO</xsl:when>
        <xsl:when test="$fid='226'">NZL</xsl:when>
        <xsl:when test="$fid='227'">NCA</xsl:when>
        <xsl:when test="$fid='228'">NIG</xsl:when>
        <xsl:when test="$fid='229'">NGR</xsl:when>
        <xsl:when test="$fid='230'">NOR</xsl:when>
        <xsl:when test="$fid='231'">OMA</xsl:when>
        <xsl:when test="$fid='232'">PAK</xsl:when>
        <xsl:when test="$fid='233'">PLW</xsl:when>
        <xsl:when test="$fid='234'">PLE</xsl:when>
        <xsl:when test="$fid='235'">PAN</xsl:when>
        <xsl:when test="$fid='236'">PNG</xsl:when>
        <xsl:when test="$fid='237'">PAR</xsl:when>
        <xsl:when test="$fid='238'">PER</xsl:when>
        <xsl:when test="$fid='239'">PHI</xsl:when>
        <xsl:when test="$fid='240'">POL</xsl:when>
        <xsl:when test="$fid='241'">POR</xsl:when>
        <xsl:when test="$fid='243'">QAT</xsl:when>
        <xsl:when test="$fid='244'">ROU</xsl:when>
        <xsl:when test="$fid='246'">RWA</xsl:when>
        <xsl:when test="$fid='247'">SKN</xsl:when>
        <xsl:when test="$fid='248'">LCA</xsl:when>
        <xsl:when test="$fid='249'">VIN</xsl:when>
        <xsl:when test="$fid='250'">SAM</xsl:when>
        <xsl:when test="$fid='251'">SMR</xsl:when>
        <xsl:when test="$fid='252'">STP</xsl:when>
        <xsl:when test="$fid='253'">KSA</xsl:when>
        <xsl:when test="$fid='254'">SEN</xsl:when>
        <xsl:when test="$fid='256'">SEY</xsl:when>
        <xsl:when test="$fid='257'">SLE</xsl:when>
        <xsl:when test="$fid='258'">SIN</xsl:when>
        <xsl:when test="$fid='259'">SVK</xsl:when>
        <xsl:when test="$fid='260'">SLO</xsl:when>
        <xsl:when test="$fid='261'">SOL</xsl:when>
        <xsl:when test="$fid='262'">SOM</xsl:when>
        <xsl:when test="$fid='263'">RSA</xsl:when>
        <xsl:when test="$fid='265'">SRI</xsl:when>
        <xsl:when test="$fid='266'">SUD</xsl:when>
        <xsl:when test="$fid='267'">SUR</xsl:when>
        <xsl:when test="$fid='268'">SWZ</xsl:when>
        <xsl:when test="$fid='271'">SYR</xsl:when>
        <xsl:when test="$fid='272'">TPE</xsl:when>
        <xsl:when test="$fid='273'">TJK</xsl:when>
        <xsl:when test="$fid='274'">TAN</xsl:when>
        <xsl:when test="$fid='275'">THA</xsl:when>
        <xsl:when test="$fid='276'">TOG</xsl:when>
        <xsl:when test="$fid='277'">TGA</xsl:when>
        <xsl:when test="$fid='278'">TRI</xsl:when>
        <xsl:when test="$fid='279'">TUN</xsl:when>
        <xsl:when test="$fid='280'">TUR</xsl:when>
        <xsl:when test="$fid='281'">TKM</xsl:when>
        <xsl:when test="$fid='282'">UGA</xsl:when>
        <xsl:when test="$fid='283'">UKR</xsl:when>
        <xsl:when test="$fid='284'">UAE</xsl:when>
        <xsl:when test="$fid='285'">URU</xsl:when>
        <xsl:when test="$fid='286'">UZB</xsl:when>
        <xsl:when test="$fid='287'">VAN</xsl:when>
        <xsl:when test="$fid='288'">VEN</xsl:when>
        <xsl:when test="$fid='289'">VIE</xsl:when>
        <xsl:when test="$fid='290'">ISV</xsl:when>
        <xsl:when test="$fid='291'">YEM</xsl:when>
        <xsl:when test="$fid='292'">ZAM</xsl:when>
        <xsl:when test="$fid='293'">ZIM</xsl:when>
                
                <!-- TODO: Add these when FRED knows them
        <xsl:when test="$fid='xxx'">COD</xsl:when>
        <xsl:when test="$fid='xxx'">KIR</xsl:when>
        <xsl:when test="$fid='xxx'">MHL</xsl:when>
        <xsl:when test="$fid='xxx'">MNE</xsl:when>
        <xsl:when test="$fid='xxx'">SRB</xsl:when>
        <xsl:when test="$fid='xxx'">TLS</xsl:when>
        <xsl:when test="$fid='xxx'">TUV</xsl:when>
                -->
          <xsl:otherwise>USA</xsl:otherwise>
      </xsl:choose>
    </Country>
  </xsl:template>

  <!-- Convert Division & Country abbreviations to FRED DivisionIDs -->	
  <xsl:template name="DivAbbrToFred">
    <xsl:param name="divAbbr" />
    <xsl:param name="natAbbr" />
    
    <xsl:variable name="sanBernardino">USFA|San Bern&#39;do</xsl:variable>
    <xsl:choose>
      <xsl:when test="$divAbbr='USFA|Western WA'">1</xsl:when>   
      <xsl:when test="$divAbbr='USFA|Inland Emp'">2</xsl:when>    
      <xsl:when test="$divAbbr='USFA|Central CA'">3</xsl:when>
      <xsl:when test="$divAbbr='USFA|Mt. Valley'">4</xsl:when>
      <xsl:when test="$divAbbr='USFA|North Coast'">5</xsl:when>
      <xsl:when test="$divAbbr='USFA|Northern CA'">6</xsl:when>
      <xsl:when test="$divAbbr='USFA|Orange Coast'">7</xsl:when>
      <xsl:when test="$divAbbr=$sanBernardino">8</xsl:when>  
      <xsl:when test="$divAbbr='USFA|San Diego'">9</xsl:when>
      <xsl:when test="$divAbbr='USFA|Southern CA'">10</xsl:when>
      <xsl:when test="$divAbbr='USFA|Oregon'">11</xsl:when>
      <xsl:when test="$divAbbr='USFA|Utah-S.Idaho'">12</xsl:when>
      <xsl:when test="$divAbbr='USFA|Alaska'">13</xsl:when>
      <xsl:when test="$divAbbr='USFA|Nevada'">14</xsl:when>
      <xsl:when test="$divAbbr='USFA|Hawaii'">15</xsl:when>
      <xsl:when test="$divAbbr='USFA|Columbus OH'">18</xsl:when>
      <xsl:when test="$divAbbr='USFA|Indiana'">19</xsl:when>
      <xsl:when test="$divAbbr='USFA|Michigan'">20</xsl:when>
      <xsl:when test="$divAbbr='USFA|Northern OH'">21</xsl:when>
      <xsl:when test="$divAbbr='USFA|Kentucky'">22</xsl:when>
      <xsl:when test="$divAbbr='USFA|Southwest OH'">23</xsl:when>
      <xsl:when test="$divAbbr='USFA|Metro NYC'">24</xsl:when>
      <xsl:when test="$divAbbr='USFA|Capitol'">25</xsl:when>
      <xsl:when test="$divAbbr='USFA|Central PA'">26</xsl:when>
      <xsl:when test="$divAbbr='USFA|Harrisburg'">27</xsl:when>
      <xsl:when test="$divAbbr='USFA|Maryland'">28</xsl:when>
      <xsl:when test="$divAbbr='USFA|New Jersey'">29</xsl:when>
      <xsl:when test="$divAbbr='USFA|Philadelphia'">30</xsl:when>
      <xsl:when test="$divAbbr='USFA|S. Jersey'">31</xsl:when>
      <xsl:when test="$divAbbr='USFA|Western PA'">32</xsl:when>
      <xsl:when test="$divAbbr='USFA|Illinois'">33</xsl:when>
      <xsl:when test="$divAbbr='USFA|Iowa'">34</xsl:when>
      <xsl:when test="$divAbbr='USFA|Minnesota'">35</xsl:when>
      <xsl:when test="$divAbbr='USFA|St. Louis'">36</xsl:when>
      <xsl:when test="$divAbbr='USFA|Wisconsin'">37</xsl:when>
      <xsl:when test="$divAbbr='USFA|Connecticut'">39</xsl:when>
      <xsl:when test="$divAbbr='USFA|Huds-Berks'">40</xsl:when>
      <xsl:when test="$divAbbr='USFA|Long Island'">41</xsl:when>
      <xsl:when test="$divAbbr='USFA|New England'">42</xsl:when>
      <xsl:when test="$divAbbr='USFA|Northeast'">43</xsl:when>
      <xsl:when test="$divAbbr='USFA|West-Rock'">44</xsl:when>
      <xsl:when test="$divAbbr='USFA|Western NY'">45</xsl:when>
      <xsl:when test="$divAbbr='USFA|Arizona'">46</xsl:when>
      <xsl:when test="$divAbbr='USFA|Border TX'">47</xsl:when>
      <xsl:when test="$divAbbr='USFA|Colorado'">48</xsl:when>
      <xsl:when test="$divAbbr='USFA|Kansas'">49</xsl:when>
      <xsl:when test="$divAbbr='USFA|Nebr-S.Dak'">50</xsl:when>
      <xsl:when test="$divAbbr='USFA|New Mexico'">51</xsl:when>
      <xsl:when test="$divAbbr='USFA|Plains TX'">52</xsl:when>
      <xsl:when test="$divAbbr='USFA|Wyoming'">53</xsl:when>
      <xsl:when test="$divAbbr='USFA|Alabama'">54</xsl:when>
      <xsl:when test="$divAbbr='USFA|Central FL'">55</xsl:when>
      <xsl:when test="$divAbbr='USFA|Gateway FL'">56</xsl:when>
      <xsl:when test="$divAbbr='USFA|Georgia'">57</xsl:when>
      <xsl:when test="$divAbbr='USFA|Gold Coast'">58</xsl:when>
      <xsl:when test="$divAbbr='USFA|N. Carolina'">59</xsl:when>
      <xsl:when test="$divAbbr='USFA|S. Carolina'">60</xsl:when>
      <xsl:when test="$divAbbr='USFA|Tennessee'">61</xsl:when>
      <xsl:when test="$divAbbr='USFA|Virginia'">62</xsl:when>
      <xsl:when test="$divAbbr='USFA|Ark-La-Miss'">63</xsl:when>
      <xsl:when test="$divAbbr='USFA|Gulf Coast'">64</xsl:when>
      <xsl:when test="$divAbbr='USFA|Louisiana'">65</xsl:when>
      <xsl:when test="$divAbbr='USFA|North TX'">66</xsl:when>
      <xsl:when test="$divAbbr='USFA|Oklahoma'">67</xsl:when>
      <xsl:when test="$divAbbr='USFA|South TX'">68</xsl:when>
      <xsl:when test="$divAbbr='USFA|Green Mt.'">82</xsl:when>
      <xsl:when test="$divAbbr='USFA|Northeast PA'">294</xsl:when>

      <!-- Map Canadian divisions to Canada -->
      <xsl:when test="$divAbbr='CFF|AB'">90</xsl:when>
      <xsl:when test="$divAbbr='CFF|BC'">90</xsl:when>
      <xsl:when test="$divAbbr='CFF|MB'">90</xsl:when>
      <xsl:when test="$divAbbr='CFF|NB'">90</xsl:when>
      <xsl:when test="$divAbbr='CFF|NL'">90</xsl:when>
      <xsl:when test="$divAbbr='CFF|NS'">90</xsl:when>
      <xsl:when test="$divAbbr='CFF|ON'">90</xsl:when>
      <xsl:when test="$divAbbr='CFF|PE'">90</xsl:when>
      <xsl:when test="$divAbbr='CFF|QC'">90</xsl:when>
      <xsl:when test="$divAbbr='CFF|SK'">90</xsl:when>
      <xsl:when test="$divAbbr='CFF|YT'">90</xsl:when>
      <xsl:when test="$divAbbr='CFF|NW'">90</xsl:when>
      <xsl:when test="$divAbbr='CFF|NU'">90</xsl:when>
            
      <!-- Map countries to their proper nation ID -->
      <xsl:when test="$natAbbr='AUS'">83</xsl:when>
      <xsl:when test="$natAbbr='MEX'">84</xsl:when>
      <xsl:when test="$natAbbr='FRA'">85</xsl:when>
      <xsl:when test="$natAbbr='GBR'">86</xsl:when>
      <xsl:when test="$natAbbr='GER'">87</xsl:when>
      <xsl:when test="$natAbbr='CAN'">90</xsl:when>
      <xsl:when test="$natAbbr='CHN'">139</xsl:when>
      <xsl:when test="$natAbbr='IRL'">184</xsl:when>
      <xsl:when test="$natAbbr='ISR'">185</xsl:when>
      <xsl:when test="$natAbbr='ITA'">186</xsl:when>
      <xsl:when test="$natAbbr='JPN'">188</xsl:when>
      <xsl:when test="$natAbbr='PUR'">242</xsl:when>
      <xsl:when test="$natAbbr='RUS'">245</xsl:when>
      <xsl:when test="$natAbbr='ESP'">264</xsl:when>
      <xsl:when test="$natAbbr='SWE'">269</xsl:when>
      <xsl:when test="$natAbbr='SUI'">270</xsl:when>
      <xsl:when test="$natAbbr='AFG'">101</xsl:when>
      <xsl:when test="$natAbbr='ALB'">102</xsl:when>
      <xsl:when test="$natAbbr='ALG'">103</xsl:when>
      <xsl:when test="$natAbbr='ASA'">104</xsl:when>
      <xsl:when test="$natAbbr='AND'">105</xsl:when>
      <xsl:when test="$natAbbr='ANG'">106</xsl:when>
      <xsl:when test="$natAbbr='ANT'">107</xsl:when>
      <xsl:when test="$natAbbr='ARG'">108</xsl:when>
      <xsl:when test="$natAbbr='ARM'">109</xsl:when>
      <xsl:when test="$natAbbr='ARU'">110</xsl:when>
      <xsl:when test="$natAbbr='AUT'">111</xsl:when>
      <xsl:when test="$natAbbr='AZE'">112</xsl:when>
      <xsl:when test="$natAbbr='BAH'">113</xsl:when>
      <xsl:when test="$natAbbr='BRN'">114</xsl:when>
      <xsl:when test="$natAbbr='BAN'">115</xsl:when>
      <xsl:when test="$natAbbr='BAR'">116</xsl:when>
      <xsl:when test="$natAbbr='BLR'">117</xsl:when>
      <xsl:when test="$natAbbr='BEL'">118</xsl:when>
      <xsl:when test="$natAbbr='BIZ'">119</xsl:when>
      <xsl:when test="$natAbbr='BER'">120</xsl:when>
      <xsl:when test="$natAbbr='BEN'">121</xsl:when>
      <xsl:when test="$natAbbr='BHU'">122</xsl:when>
      <xsl:when test="$natAbbr='BOL'">123</xsl:when>
      <xsl:when test="$natAbbr='BIH'">124</xsl:when>
      <xsl:when test="$natAbbr='BOT'">125</xsl:when>
      <xsl:when test="$natAbbr='BRA'">126</xsl:when>
      <xsl:when test="$natAbbr='IVB'">127</xsl:when>
      <xsl:when test="$natAbbr='BRU'">128</xsl:when>
      <xsl:when test="$natAbbr='BUL'">129</xsl:when>
      <xsl:when test="$natAbbr='BUR'">130</xsl:when>
      <xsl:when test="$natAbbr='BDI'">131</xsl:when>
      <xsl:when test="$natAbbr='CAM'">132</xsl:when>
      <xsl:when test="$natAbbr='CMR'">133</xsl:when>
      <xsl:when test="$natAbbr='CPV'">134</xsl:when>
      <xsl:when test="$natAbbr='CAY'">135</xsl:when>
      <xsl:when test="$natAbbr='CAF'">136</xsl:when>
      <xsl:when test="$natAbbr='CHA'">137</xsl:when>
      <xsl:when test="$natAbbr='CHI'">138</xsl:when>
      <xsl:when test="$natAbbr='COL'">140</xsl:when>
      <xsl:when test="$natAbbr='COM'">141</xsl:when>
      <xsl:when test="$natAbbr='CGO'">142</xsl:when>
      <xsl:when test="$natAbbr='COK'">144</xsl:when>
      <xsl:when test="$natAbbr='CRC'">145</xsl:when>
      <xsl:when test="$natAbbr='CIV'">146</xsl:when>
      <xsl:when test="$natAbbr='CRO'">147</xsl:when>
      <xsl:when test="$natAbbr='CUB'">148</xsl:when>
      <xsl:when test="$natAbbr='CYP'">149</xsl:when>
      <xsl:when test="$natAbbr='CZE'">150</xsl:when>
      <xsl:when test="$natAbbr='DEN'">151</xsl:when>
      <xsl:when test="$natAbbr='DJI'">152</xsl:when>
      <xsl:when test="$natAbbr='DMA'">153</xsl:when>
      <xsl:when test="$natAbbr='DOM'">154</xsl:when>
      <xsl:when test="$natAbbr='ECU'">155</xsl:when>
      <xsl:when test="$natAbbr='EGY'">156</xsl:when>
      <xsl:when test="$natAbbr='ESA'">157</xsl:when>
      <xsl:when test="$natAbbr='GEQ'">158</xsl:when>
      <xsl:when test="$natAbbr='ERI'">159</xsl:when>
      <xsl:when test="$natAbbr='EST'">160</xsl:when>
      <xsl:when test="$natAbbr='ETH'">161</xsl:when>
      <xsl:when test="$natAbbr='FIJ'">162</xsl:when>
      <xsl:when test="$natAbbr='FIN'">163</xsl:when>
      <xsl:when test="$natAbbr='GAB'">164</xsl:when>
      <xsl:when test="$natAbbr='GAM'">165</xsl:when>
      <xsl:when test="$natAbbr='GEO'">166</xsl:when>
      <xsl:when test="$natAbbr='GHA'">167</xsl:when>
      <xsl:when test="$natAbbr='GRE'">168</xsl:when>
      <xsl:when test="$natAbbr='GRN'">169</xsl:when>
      <xsl:when test="$natAbbr='GUM'">170</xsl:when>
      <xsl:when test="$natAbbr='GUA'">171</xsl:when>
      <xsl:when test="$natAbbr='GUI'">172</xsl:when>
      <xsl:when test="$natAbbr='GBS'">173</xsl:when>
      <xsl:when test="$natAbbr='GUY'">174</xsl:when>
      <xsl:when test="$natAbbr='HAI'">175</xsl:when>
      <xsl:when test="$natAbbr='HON'">176</xsl:when>
      <xsl:when test="$natAbbr='HKG'">177</xsl:when>
      <xsl:when test="$natAbbr='HUN'">178</xsl:when>
      <xsl:when test="$natAbbr='ISL'">179</xsl:when>
      <xsl:when test="$natAbbr='IND'">180</xsl:when>
      <xsl:when test="$natAbbr='INA'">181</xsl:when>
      <xsl:when test="$natAbbr='IRI'">182</xsl:when>
      <xsl:when test="$natAbbr='IRQ'">183</xsl:when>
      <xsl:when test="$natAbbr='JAM'">187</xsl:when>
      <xsl:when test="$natAbbr='JOR'">189</xsl:when>
      <xsl:when test="$natAbbr='KAZ'">190</xsl:when>
      <xsl:when test="$natAbbr='KEN'">191</xsl:when>
      <xsl:when test="$natAbbr='PRK'">192</xsl:when>
      <xsl:when test="$natAbbr='KOR'">193</xsl:when>
      <xsl:when test="$natAbbr='KUW'">194</xsl:when>
      <xsl:when test="$natAbbr='KGZ'">195</xsl:when>
      <xsl:when test="$natAbbr='LAO'">196</xsl:when>
      <xsl:when test="$natAbbr='LAT'">197</xsl:when>
      <xsl:when test="$natAbbr='LIB'">198</xsl:when>
      <xsl:when test="$natAbbr='LES'">199</xsl:when>
      <xsl:when test="$natAbbr='LBR'">200</xsl:when>
      <xsl:when test="$natAbbr='LBA'">201</xsl:when>
      <xsl:when test="$natAbbr='LIE'">202</xsl:when>
      <xsl:when test="$natAbbr='LTU'">203</xsl:when>
      <xsl:when test="$natAbbr='LUX'">204</xsl:when>
      <xsl:when test="$natAbbr='MKD'">205</xsl:when>
      <xsl:when test="$natAbbr='MAD'">206</xsl:when>
      <xsl:when test="$natAbbr='MAW'">207</xsl:when>
      <xsl:when test="$natAbbr='MAS'">208</xsl:when>
      <xsl:when test="$natAbbr='MDV'">209</xsl:when>
      <xsl:when test="$natAbbr='MLI'">210</xsl:when>
      <xsl:when test="$natAbbr='MLT'">211</xsl:when>
      <xsl:when test="$natAbbr='MTN'">212</xsl:when>
      <xsl:when test="$natAbbr='MRI'">213</xsl:when>
      <xsl:when test="$natAbbr='FSM'">214</xsl:when>
      <xsl:when test="$natAbbr='MDA'">215</xsl:when>
      <xsl:when test="$natAbbr='MON'">216</xsl:when>
      <xsl:when test="$natAbbr='MGL'">217</xsl:when>
      <xsl:when test="$natAbbr='MAR'">218</xsl:when>
      <xsl:when test="$natAbbr='MOZ'">219</xsl:when>
      <xsl:when test="$natAbbr='MYA'">220</xsl:when>
      <xsl:when test="$natAbbr='NAM'">221</xsl:when>
      <xsl:when test="$natAbbr='NRU'">222</xsl:when>
      <xsl:when test="$natAbbr='NEP'">223</xsl:when>
      <xsl:when test="$natAbbr='NED'">224</xsl:when>
      <xsl:when test="$natAbbr='AHO'">225</xsl:when>
      <xsl:when test="$natAbbr='NZL'">226</xsl:when>
      <xsl:when test="$natAbbr='NCA'">227</xsl:when>
      <xsl:when test="$natAbbr='NIG'">228</xsl:when>
      <xsl:when test="$natAbbr='NGR'">229</xsl:when>
      <xsl:when test="$natAbbr='NOR'">230</xsl:when>
      <xsl:when test="$natAbbr='OMA'">231</xsl:when>
      <xsl:when test="$natAbbr='PAK'">232</xsl:when>
      <xsl:when test="$natAbbr='PLW'">233</xsl:when>
      <xsl:when test="$natAbbr='PLE'">234</xsl:when>
      <xsl:when test="$natAbbr='PAN'">235</xsl:when>
      <xsl:when test="$natAbbr='PNG'">236</xsl:when>
      <xsl:when test="$natAbbr='PAR'">237</xsl:when>
      <xsl:when test="$natAbbr='PER'">238</xsl:when>
      <xsl:when test="$natAbbr='PHI'">239</xsl:when>
      <xsl:when test="$natAbbr='POL'">240</xsl:when>
      <xsl:when test="$natAbbr='POR'">241</xsl:when>
      <xsl:when test="$natAbbr='QAT'">243</xsl:when>
      <xsl:when test="$natAbbr='ROU'">244</xsl:when>
      <xsl:when test="$natAbbr='RWA'">246</xsl:when>
      <xsl:when test="$natAbbr='SKN'">247</xsl:when>
      <xsl:when test="$natAbbr='LCA'">248</xsl:when>
      <xsl:when test="$natAbbr='VIN'">249</xsl:when>
      <xsl:when test="$natAbbr='SAM'">250</xsl:when>
      <xsl:when test="$natAbbr='SMR'">251</xsl:when>
      <xsl:when test="$natAbbr='STP'">252</xsl:when>
      <xsl:when test="$natAbbr='KSA'">253</xsl:when>
      <xsl:when test="$natAbbr='SEN'">254</xsl:when>
      <xsl:when test="$natAbbr='SEY'">256</xsl:when>
      <xsl:when test="$natAbbr='SLE'">257</xsl:when>
      <xsl:when test="$natAbbr='SIN'">258</xsl:when>
      <xsl:when test="$natAbbr='SVK'">259</xsl:when>
      <xsl:when test="$natAbbr='SLO'">260</xsl:when>
      <xsl:when test="$natAbbr='SOL'">261</xsl:when>
      <xsl:when test="$natAbbr='SOM'">262</xsl:when>
      <xsl:when test="$natAbbr='RSA'">263</xsl:when>
      <xsl:when test="$natAbbr='SRI'">265</xsl:when>
      <xsl:when test="$natAbbr='SUD'">266</xsl:when>
      <xsl:when test="$natAbbr='SUR'">267</xsl:when>
      <xsl:when test="$natAbbr='SWZ'">268</xsl:when>
      <xsl:when test="$natAbbr='SYR'">271</xsl:when>
      <xsl:when test="$natAbbr='TPE'">272</xsl:when>
      <xsl:when test="$natAbbr='TJK'">273</xsl:when>
      <xsl:when test="$natAbbr='TAN'">274</xsl:when>
      <xsl:when test="$natAbbr='THA'">275</xsl:when>
      <xsl:when test="$natAbbr='TOG'">276</xsl:when>
      <xsl:when test="$natAbbr='TGA'">277</xsl:when>
      <xsl:when test="$natAbbr='TRI'">278</xsl:when>
      <xsl:when test="$natAbbr='TUN'">279</xsl:when>
      <xsl:when test="$natAbbr='TUR'">280</xsl:when>
      <xsl:when test="$natAbbr='TKM'">281</xsl:when>
      <xsl:when test="$natAbbr='UGA'">282</xsl:when>
      <xsl:when test="$natAbbr='UKR'">283</xsl:when>
      <xsl:when test="$natAbbr='UAE'">284</xsl:when>
      <xsl:when test="$natAbbr='URU'">285</xsl:when>
      <xsl:when test="$natAbbr='UZB'">286</xsl:when>
      <xsl:when test="$natAbbr='VAN'">287</xsl:when>
      <xsl:when test="$natAbbr='VEN'">288</xsl:when>
      <xsl:when test="$natAbbr='VIE'">289</xsl:when>
      <xsl:when test="$natAbbr='ISV'">290</xsl:when>
      <xsl:when test="$natAbbr='YEM'">291</xsl:when>
      <xsl:when test="$natAbbr='ZAM'">292</xsl:when>
      <xsl:when test="$natAbbr='ZIM'">293</xsl:when>
            
      <!-- TODO: Add these when FRED knows them
      <xsl:when test="$natAbbr='COD'">xxx</xsl:when>
      <xsl:when test="$natAbbr='KIR'">xxx</xsl:when>
      <xsl:when test="$natAbbr='MHL'">xxx</xsl:when>
      <xsl:when test="$natAbbr='MNE'">xxx</xsl:when>
      <xsl:when test="$natAbbr='SRB'">xxx</xsl:when>
      <xsl:when test="$natAbbr='TLS'">xxx</xsl:when>
      <xsl:when test="$natAbbr='TUV'">xxx</xsl:when>
        -->
            
      <!-- Everything else is DivisionID = National -->
      <xsl:otherwise>69</xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
