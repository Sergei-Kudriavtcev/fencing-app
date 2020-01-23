<?xml version="1.0" encoding="utf-8"?>
<!-- 
Fencing Time
By Daniel Berke
(C) Copyright by Daniel Berke 
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ft="http://www.fencingtime.com">
  <xsl:output indent="yes" />
  <xsl:variable name="fileVersion">4.3</xsl:variable>

  <!-- Standard parameters -->
  <xsl:param name="localPath"   />
  <xsl:param name="flagPath"    />
  <xsl:param name="fontSize"    />
  <xsl:param name="screenHeight" />
  <xsl:param name="langCode"    />
  <xsl:param name="bgClass"     />

  <!-- Page-specific parameters -->
  <xsl:param name="showStrips"    />
  <xsl:param name="showRefs"      />
  <xsl:param name="showClubs"     />
  <xsl:param name="showDivs"      />
  <xsl:param name="showCountries" />
  <xsl:param name="showRatings"   />
  <xsl:param name="showTimes"     />
  <xsl:param name="showUnfinishedBoutRefs" />

  <xsl:param name="mainTableStartSize" />
  <xsl:param name="mainTableEndSize"   />
  <xsl:param name="mainTreeEndSize"    />
  <xsl:param name="totalNumColumns"    />

  <xsl:param name="specificPartNum" />

  <xsl:variable name="localized" select="document(concat('Lang\', $langCode, '.xml'))/ft:LocalizedText" />

  <xsl:variable name="showAffil"   select="$showCountries  = 'true' or $showDivs = 'true' or $showClubs = 'true'" />

  <xsl:variable name="numParts">
    <xsl:choose>
      <xsl:when test="$mainTableStartSize > 128">8</xsl:when>
      <xsl:when test="$mainTableStartSize > 8">4</xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="linesPerPod" select="$mainTableStartSize * 2 div $numParts" />

  <xsl:template match="/">
    <html xmlns="http://www.w3.org/1999/xhtml">
      <head>
        <link rel="stylesheet" type="text/css" href="{$localPath}/Styles/default.css" />
      </head>

      <body class="{$bgClass}" style="font-size: {$fontSize}em;">
        <div class="dePage {$bgClass}">
          <xsl:variable name="elimType" select="/Elimination/ElimType" />
          <xsl:for-each select="/Elimination/Tableaus/Tableau">
            <xsl:variable name="actualStartSize">
              <xsl:choose>
                <xsl:when test="position() = 1">
                  <xsl:value-of select="$mainTableStartSize"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="StartSize"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <xsl:variable name="actualEndSize">
              <xsl:choose>
                <xsl:when test="position() = 1">
                  <xsl:value-of select="$mainTableEndSize"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="EndSize"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>

            <xsl:call-template name="RenderSingleElimTableau">
              <xsl:with-param name="startTableSize" select="$actualStartSize" />
              <xsl:with-param name="endTableSize" select="$actualEndSize" />
            </xsl:call-template>
          </xsl:for-each>
        </div>
      </body>
    </html>
  </xsl:template>
            
            
  <!-- Template to render DE tableau -->
  <xsl:template name="RenderSingleElimTableau">
    <xsl:param name="startTableSize" />
    <xsl:param name="endTableSize" />

    <xsl:if test="($specificPartNum and position() = 1) or (not($specificPartNum) and 
                    ((count(Tables/Table[1]/Bouts/ElimBout/TopCompetitor) &gt; 0)    or
                     (count(Tables/Table[1]/Bouts/ElimBout/BottomCompetitor) &gt; 0) or
                     ($showStrips = 'true' and count(Tables//Bouts/ElimBout[Strip != '']) &gt; 0) or
                     ($showTimes  = 'true' and count(Tables//Bouts/ElimBout[StartTime != '']) &gt; 0)))">
      <xsl:if test="position() != 1">
        <br/>
      </xsl:if>

      <table class="elimTableau">
        <xsl:if test="$specificPartNum">
          <xsl:attribute name="style">
            height: <xsl:value-of select="$screenHeight - 64" />px; font-size: 1.5em;
          </xsl:attribute>
        </xsl:if>

        <!-- Create column widths -->
        <xsl:call-template name="RenderTableauColumnWidths">
          <xsl:with-param name="numCols" select="$totalNumColumns" />
          <xsl:with-param name="percent" select="96 div $totalNumColumns" />
        </xsl:call-template>

        <!-- Create column headers -->
        <tr>
          <xsl:call-template name="RenderTableauHeader">
            <xsl:with-param name="tables"     select="Tables" />
            <xsl:with-param name="curColSize" select="$startTableSize" />
            <xsl:with-param name="sizeDelta"  select="0.5" />
            <xsl:with-param name="numTables"  select="$totalNumColumns - 1" />
          </xsl:call-template>
        </tr>

        <!-- Create tableau rows -->
        <xsl:call-template name="RenderSingleElimTableRow">
          <xsl:with-param name="tableSize"  select="$startTableSize" />
          <xsl:with-param name="endColSize" select="$endTableSize" />
          <xsl:with-param name="curRowNum"  select="0" />
        </xsl:call-template>
      </table>
    </xsl:if>
  </xsl:template>


  <!-- Create table col elements -->
  <xsl:template name="RenderTableauColumnWidths">
    <xsl:param name="numCols" />
    <xsl:param name="percent" />

    <xsl:if test="$numCols &gt; 0">
      <col width="{$percent}%" />
      <xsl:call-template name="RenderTableauColumnWidths">
        <xsl:with-param name="numCols" select="$numCols - 1" />
        <xsl:with-param name="percent" select="$percent" />
      </xsl:call-template>
    </xsl:if>
  </xsl:template>


  <!-- Create headers for each column of the tableau -->
  <xsl:template name="RenderTableauHeader">
    <xsl:param name="tables" />
    <xsl:param name="curColSize" />
    <xsl:param name="sizeDelta" />
    <xsl:param name="numTables" />

    <xsl:if test="$numTables &gt;= 0">
      <td class="tableauColumnTitle">
        <xsl:if test="$tables/Table[Size=$curColSize]/Name">
          <xsl:call-template name="TranslateTableName">
            <xsl:with-param name="tableName" select="$tables/Table[Size=$curColSize]/Name" />
          </xsl:call-template>
        </xsl:if>
        <xsl:if test="not($tables/Table[Size=$curColSize]/Name)">
          <xsl:text xml:space="preserve">&#160;</xsl:text>
        </xsl:if>
      </td>

      <xsl:call-template name="RenderTableauHeader">
        <xsl:with-param name="tables"     select="$tables" />
        <xsl:with-param name="curColSize" select="$curColSize * $sizeDelta" />
        <xsl:with-param name="sizeDelta"  select="$sizeDelta" />
        <xsl:with-param name="numTables"  select="$numTables - 1" />
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="TranslateTableName">
    <xsl:param name="tableName" />
    <xsl:choose>
      <xsl:when test="$tableName = 'Fence-off for Third'"><xsl:value-of select="$localized/ft:LocText[@id='fo3']" /></xsl:when>
      <xsl:when test="$tableName = 'Finals'"><xsl:value-of select="$localized/ft:LocText[@id='finals']" /></xsl:when>
      <xsl:when test="$tableName = 'Semifinals'"><xsl:value-of select="$localized/ft:LocText[@id='semifinals']" /></xsl:when>

      <xsl:when test="$tableName = 'Table of 8 (Pl. 9-16)'"><xsl:value-of select="$localized/ft:LocText[@id='table9_16']" /></xsl:when>
      <xsl:when test="$tableName = 'Table of 4 (Pl. 9-12)'"><xsl:value-of select="$localized/ft:LocText[@id='table9_12']" /></xsl:when>
      <xsl:when test="$tableName = 'Table of 2 (Pl. 9-10)'"><xsl:value-of select="$localized/ft:LocText[@id='table9_10']" /></xsl:when>
      <xsl:when test="$tableName = 'Table of 2 (Pl. 3-4)'"><xsl:value-of select="$localized/ft:LocText[@id='table3_4']" /></xsl:when>
      <xsl:when test="$tableName = 'Table of 4 (Pl. 5-8)'"><xsl:value-of select="$localized/ft:LocText[@id='table5_8']" /></xsl:when>
      <xsl:when test="$tableName = 'Table of 2 (Pl. 5-6)'"><xsl:value-of select="$localized/ft:LocText[@id='table5_6']" /></xsl:when>
      <xsl:when test="$tableName = 'Table of 2 (Pl. 7-8)'"><xsl:value-of select="$localized/ft:LocText[@id='table7_8']" /></xsl:when>
      <xsl:when test="$tableName = 'Table of 2 (Pl. 11-12)'"><xsl:value-of select="$localized/ft:LocText[@id='table11_12']" /></xsl:when>
      <xsl:when test="$tableName = 'Table of 4 (Pl. 13-16)'"><xsl:value-of select="$localized/ft:LocText[@id='table13_16']" /></xsl:when>
      <xsl:when test="$tableName = 'Table of 2 (Pl. 13-14)'"><xsl:value-of select="$localized/ft:LocText[@id='table13_14']" /></xsl:when>
      <xsl:when test="$tableName = 'Table of 2 (Pl. 15-16)'"><xsl:value-of select="$localized/ft:LocText[@id='table15_16']" /></xsl:when>

      <xsl:when test="$tableName = 'Table A (32)'"><xsl:value-of select="$localized/ft:LocText[@id='tableA32']" /></xsl:when>
      <xsl:when test="$tableName = 'Table A (16)'"><xsl:value-of select="$localized/ft:LocText[@id='tableA16']" /></xsl:when>
      <xsl:when test="$tableName = 'Table B (16)'"><xsl:value-of select="$localized/ft:LocText[@id='tableB16']" /></xsl:when>
      <xsl:when test="$tableName = 'Table B (8)'"><xsl:value-of select="$localized/ft:LocText[@id='tableB8']" /></xsl:when>
      <xsl:when test="$tableName = 'Table C (8)'"><xsl:value-of select="$localized/ft:LocText[@id='tableC8']" /></xsl:when>
      <xsl:when test="$tableName = 'Table D (16)'"><xsl:value-of select="$localized/ft:LocText[@id='tableD16']" /></xsl:when>
      <xsl:when test="$tableName = 'Table D (8)'"><xsl:value-of select="$localized/ft:LocText[@id='tableD8']" /></xsl:when>
      <xsl:when test="$tableName = 'Table E (16)'"><xsl:value-of select="$localized/ft:LocText[@id='tableE16']" /></xsl:when>
      <xsl:when test="$tableName = 'Table E (8)'"><xsl:value-of select="$localized/ft:LocText[@id='tableE8']" /></xsl:when>
      <xsl:when test="$tableName = 'Table F (8)'"><xsl:value-of select="$localized/ft:LocText[@id='tableF8']" /></xsl:when>
      <xsl:when test="$tableName = 'Table G (8)'"><xsl:value-of select="$localized/ft:LocText[@id='tableG8']" /></xsl:when>
      <xsl:when test="$tableName = 'Table H (8)'"><xsl:value-of select="$localized/ft:LocText[@id='tableH8']" /></xsl:when>

      <xsl:when test="starts-with($tableName, 'Table of ')">
        <xsl:value-of select="$localized/ft:LocText[@id='tableOf']" />&#160;
        <xsl:value-of select="substring-after($tableName, 'Table of ')" />
      </xsl:when>
      
      <xsl:otherwise><xsl:value-of select="$tableName" /></xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  
  <!-- Create a blank row in the table -->
  <xsl:template name="RenderTableauBlankRow">
    <xsl:param name="numCols" />

    <xsl:if test="$numCols &gt; 0">
      <td><xsl:text xml:space="preserve">&#160;</xsl:text></td>
      
      <xsl:call-template name="RenderTableauBlankRow">
        <xsl:with-param name="numCols" select="$numCols - 1" />
      </xsl:call-template>
    </xsl:if>
  </xsl:template>


  <!-- Render a row in a single-elim tableau -->
  <xsl:template name="RenderSingleElimTableRow">
    <xsl:param name="tableSize" />
    <xsl:param name="endColSize" />
    <xsl:param name="curRowNum" />

    <xsl:if test="$curRowNum &lt; $tableSize * 2">
      <xsl:variable name="partNum" select="floor($curRowNum div $linesPerPod)" />

      <xsl:if test="not($specificPartNum > 0) or $partNum = $specificPartNum - 1">
        <tr>
          <xsl:if test="floor(($curRowNum div $linesPerPod) mod 2) = 1">
            <xsl:attribute name="class">tableauAltRow</xsl:attribute>
          </xsl:if>

          <xsl:call-template name="RenderRowCells">
            <xsl:with-param name="startColSize" select="$tableSize" />
            <xsl:with-param name="endColSize"   select="$endColSize" />
            <xsl:with-param name="curRowNum"    select="$curRowNum" />
            <xsl:with-param name="curColSize"   select="$tableSize" />
            <xsl:with-param name="curColPower"  select="1" />
          </xsl:call-template>
        </tr>
      </xsl:if>

      <xsl:call-template name="RenderSingleElimTableRow">
        <xsl:with-param name="tableSize"  select="$tableSize" />
        <xsl:with-param name="endColSize" select="$endColSize" />
        <xsl:with-param name="curRowNum"  select="$curRowNum + 1" />
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  
  <xsl:template name="RenderRowCells">
    <xsl:param name="startColSize" />
    <xsl:param name="endColSize" />
    <xsl:param name="curRowNum" />
    <xsl:param name="curColSize" />
    <xsl:param name="curColPower" />

    <xsl:if test="$curColSize &gt;= $endColSize">
      <td>
        <xsl:variable name="boutIndex"   select="floor($curRowNum div ($curColPower * 4)) + 1" />
        <xsl:variable name="bout"        select="Tables/Table[Size=$curColSize]/Bouts/ElimBout[$boutIndex]" />
        <xsl:variable name="prevBoutTop" select="Tables/Table[Size=($curColSize*2)]/Bouts/ElimBout[($boutIndex*2)-1]" />
        <xsl:variable name="prevBoutBot" select="Tables/Table[Size=($curColSize*2)]/Bouts/ElimBout[$boutIndex*2]" />

        <xsl:choose>
          <!-- ============== Top name cell ============== -->
          <xsl:when test="($curRowNum - ($curColPower - 1)) mod ($curColPower * 4) = 0">
            <xsl:attribute name="class">tableauNameCell tableauBorderBottom</xsl:attribute>
            <xsl:choose>
              <!-- If a name is present, print it -->
              <xsl:when test="$bout/TopCompetitor">
                <xsl:call-template name="RenderNameCell">
                  <xsl:with-param name="seed"   select="$bout/TopSeed" />
                  <xsl:with-param name="name"   select="$bout/TopCompetitor/Name" />
                  <xsl:with-param name="rating" select="$bout/TopCompetitor/Rating" />
                </xsl:call-template>
              </xsl:when>
              
              <!-- If a bye is present, print it -->
              <xsl:when test="$bout/TopBye = 'true'">
                <xsl:call-template name="RenderNameCell">
                  <xsl:with-param name="seed" select="$bout/TopSeed" />
                  <xsl:with-param name="bye"  select="'true'" />
                </xsl:call-template>
              </xsl:when>

              <!-- Draw winner name when in rightmost column -->
              <xsl:when test="$curColSize = $endColSize and $prevBoutTop/Winner/Name != ''">
                <xsl:call-template name="RenderNameCell">
                  <xsl:with-param name="seed"   select="$prevBoutTop/WinnerSeed" />
                  <xsl:with-param name="name"   select="$prevBoutTop/Winner/Name" />
                  <xsl:with-param name="rating" select="$prevBoutTop/Winner/Rating" />
                  <xsl:with-param name="bye"    select="$prevBoutTop/WinnerBye" />
                </xsl:call-template>
              </xsl:when>

              <!-- If a start time or strip is present, print it -->
              <xsl:when test="$prevBoutTop/Strip != '' or $prevBoutTop/StartTime != ''">
                <xsl:call-template name="RenderTimeStripCell">
                  <xsl:with-param name="strip" select="$prevBoutTop/Strip" />
                  <xsl:with-param name="time"  select="$prevBoutTop/StartTime" />
                </xsl:call-template>
              </xsl:when>
            </xsl:choose>

            <!-- Blank to force cell to draw if empty -->
            <xsl:text xml:space="preserve">&#160;</xsl:text>
          </xsl:when>

          <!-- ============== Top score cell ============== -->
          <xsl:when test="($curRowNum - $curColPower) mod ($curColPower * 4) = 0">
            <!-- No right border in last column -->
            <xsl:if test="$curColSize != $mainTreeEndSize">
              <xsl:attribute name="class">tableauBorderRight</xsl:attribute>
            </xsl:if>
            
            <xsl:choose>
              <!-- Draw score if not first table -->
              <xsl:when test="$curColSize != $startColSize">
                <xsl:call-template name="RenderScoreRefCell">
                  <xsl:with-param name="score"       select="$prevBoutTop/Score" />
                  <xsl:with-param name="referee1"    select="$prevBoutTop/Referee1" />
                  <xsl:with-param name="referee2"    select="$prevBoutTop/Referee2" />
                  <xsl:with-param name="referee3"    select="$prevBoutTop/Referee3" />
                  <xsl:with-param name="referee4"    select="$prevBoutTop/Referee4" />
                  <xsl:with-param name="teamMatchID" select="$prevBoutTop/TeamMatchID" />
                </xsl:call-template>
              </xsl:when> 

              <!-- Draw affiliations in first table -->
              <xsl:when test="$curColSize = $startColSize and $showAffil">
                <span class="tableauCompAffil">
                  <xsl:call-template name="BuildAffiliations">
                    <xsl:with-param name="showClub"     select="$showClubs" />
                    <xsl:with-param name="clubAbbr"     select="$bout/TopCompetitor/ClubAbbr" />
                    <xsl:with-param name="showDiv"      select="$showDivs" />
                    <xsl:with-param name="divAbbr"      select="$bout/TopCompetitor/DivAbbr" />
                    <xsl:with-param name="showCountry"  select="$showCountries" />
                    <xsl:with-param name="countryAbbr"  select="$bout/TopCompetitor/CountryAbbr" />
                    <xsl:with-param name="flagPath"     select="$flagPath" />
                  </xsl:call-template>
                </span>
              </xsl:when>
            </xsl:choose>
            
            <!-- Blank to force cell to draw if empty -->
            <xsl:text xml:space="preserve">&#160;</xsl:text>
          </xsl:when>
          
          <!-- ============== Vertical connector cell ============== -->
          <xsl:when test="($curRowNum - ($curColPower - 1)) mod ($curColPower * 4) &lt; ($curColPower * 2) and ($curRowNum &gt; $curColPower)">
            <!-- No verticals in last column -->
            <xsl:if test="$curColSize != $mainTreeEndSize">
              <xsl:attribute name="class">tableauBorderRight</xsl:attribute>
            </xsl:if>

            <!-- Blank to force cell to draw -->
            <xsl:text xml:space="preserve">&#160;</xsl:text>
          </xsl:when>

          <!-- ============== Bottom name cell ============== -->
          <xsl:when test="($curRowNum - ($curColPower - 1 + ($curColPower * 2))) mod ($curColPower * 4) = 0">
            <!-- No verticals in last column -->
            <xsl:if test="$curColSize = $mainTreeEndSize">
              <xsl:attribute name="class">tableauNameCell tableauBorderBottom</xsl:attribute>
            </xsl:if>
            <xsl:if test="$curColSize != $mainTreeEndSize">
              <xsl:attribute name="class">tableauNameCell tableauBorderBottomRight</xsl:attribute>
            </xsl:if>

            <xsl:choose>
              <!-- If a name is present, print it -->
              <xsl:when test="$bout/BottomCompetitor">
                <xsl:call-template name="RenderNameCell">
                  <xsl:with-param name="seed"   select="$bout/BottomSeed" />
                  <xsl:with-param name="name"   select="$bout/BottomCompetitor/Name" />
                  <xsl:with-param name="rating" select="$bout/BottomCompetitor/Rating" />
                </xsl:call-template>
              </xsl:when>
            
              <!-- If a bye is present, print it -->
              <xsl:when test="$bout/BottomBye = 'true'">
                <xsl:call-template name="RenderNameCell">
                  <xsl:with-param name="seed" select="$bout/BottomSeed" />
                  <xsl:with-param name="bye"  select="'true'" />
                </xsl:call-template>
              </xsl:when>

              <!-- Draw winner name when in rightmost column -->
              <xsl:when test="$curColSize = $endColSize and $prevBoutBot/Winner/Name != ''">
                <xsl:call-template name="RenderNameCell">
                  <xsl:with-param name="seed"   select="$prevBoutBot/WinnerSeed" />
                  <xsl:with-param name="name"   select="$prevBoutBot/Winner/Name" />
                  <xsl:with-param name="rating" select="$prevBoutBot/Winner/Rating" />
                  <xsl:with-param name="bye"    select="$prevBoutBot/WinnerBye" />
                </xsl:call-template>
              </xsl:when>

              <!-- If a start time or strip is present, print it -->
              <xsl:when test="$prevBoutBot/Strip != '' or $prevBoutBot/StartTime != ''">
                <xsl:call-template name="RenderTimeStripCell">
                  <xsl:with-param name="strip" select="$prevBoutBot/Strip" />
                  <xsl:with-param name="time"  select="$prevBoutBot/StartTime" />
                </xsl:call-template>
              </xsl:when>
            </xsl:choose>

            <!-- Blank to force cell to draw if empty -->
            <xsl:text xml:space="preserve">&#160;</xsl:text>
          </xsl:when>

          <!-- ============== Bottom score cell ============== -->
          <xsl:when test="($curRowNum - ($curColPower + ($curColPower * 2))) mod ($curColPower * 4) = 0">
            <xsl:choose>
              <!-- Draw score if not first table -->
              <xsl:when test="$curColSize != $startColSize">
                <xsl:call-template name="RenderScoreRefCell">
                  <xsl:with-param name="score"       select="$prevBoutBot/Score" />
                  <xsl:with-param name="referee1"    select="$prevBoutBot/Referee1" />
                  <xsl:with-param name="referee2"    select="$prevBoutBot/Referee2" />
                  <xsl:with-param name="referee3"    select="$prevBoutBot/Referee3" />
                  <xsl:with-param name="referee4"    select="$prevBoutBot/Referee4" />
                  <xsl:with-param name="teamMatchID" select="$prevBoutBot/TeamMatchID" />
                </xsl:call-template>
              </xsl:when>

              <!-- Draw affiliations in first table -->
              <xsl:when test="$curColSize = $startColSize and $showAffil">
                <xsl:if test="$bout/BottomBye = 'false'">
                  <span class="tableauCompAffil">
                    <xsl:call-template name="BuildAffiliations">
                      <xsl:with-param name="showClub"     select="$showClubs" />
                      <xsl:with-param name="clubAbbr"     select="$bout/BottomCompetitor/ClubAbbr" />
                      <xsl:with-param name="showDiv"      select="$showDivs" />
                      <xsl:with-param name="divAbbr"      select="$bout/BottomCompetitor/DivAbbr" />
                      <xsl:with-param name="showCountry"  select="$showCountries" />
                      <xsl:with-param name="countryAbbr"  select="$bout/BottomCompetitor/CountryAbbr" />
                      <xsl:with-param name="flagPath"     select="$flagPath" />
                    </xsl:call-template>
                  </span>
                </xsl:if>
              </xsl:when>
            </xsl:choose>

            <!-- Blank to force cell to draw if empty -->
            <xsl:text xml:space="preserve">&#160;</xsl:text>
          </xsl:when>
        </xsl:choose>
      </td>

      <xsl:call-template name="RenderRowCells">
        <xsl:with-param name="startColSize" select="$startColSize" />
        <xsl:with-param name="endColSize"   select="$endColSize" />
        <xsl:with-param name="curRowNum"    select="$curRowNum" />
        <xsl:with-param name="curColSize"   select="$curColSize div 2" />
        <xsl:with-param name="curColPower"  select="$curColPower * 2" />
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  
  <xsl:template name="RenderNameCell">
    <xsl:param name="seed" />
    <xsl:param name="name" />
    <xsl:param name="rating" />
    <xsl:param name="bye" />

    <!-- If name or bye present, print seed -->
    <xsl:if test="($name or $bye = 'true') and $seed != ''">
        <span class="tableauSeed">
        <xsl:text>(</xsl:text>
        <xsl:value-of select="$seed" />
        <xsl:text xml:space="preserve">) </xsl:text>
      </span>
    </xsl:if>

    <!-- If a name is present, print it -->
    <xsl:if test="$name">
      <span class="tableauCompName">
        <xsl:value-of select="$name" />
      </span>
      <xsl:if test="$showRatings = 'true'">
        <xsl:text xml:space="preserve"> - </xsl:text>
        <span class="tableauCompRating">
          <xsl:value-of select="$rating" />
        </span>
      </xsl:if>
    </xsl:if>

    <!-- If a bye is present, print it -->
    <xsl:if test="$bye = 'true'">
      <span class="tableauCompName">-BYE-</span>
    </xsl:if>
  </xsl:template>

  
  <xsl:template name="RenderTimeStripCell">
    <xsl:param name="time"  />
    <xsl:param name="strip" />
    
    <span class="tableauTimeStrip">
      <xsl:if test="$showStrips = 'true' and $strip != ''">
        <xsl:value-of select="$localized/ft:LocText[@id='onStrip']" />&#160;<xsl:value-of select="$strip" />&#160;
      </xsl:if>
      <xsl:if test="$showTimes = 'true' and $time != ''">
        <xsl:value-of select="$localized/ft:LocText[@id='atTime']" />&#160;<xsl:value-of select="$time" />
      </xsl:if>
    </span>
  </xsl:template>

  
  <xsl:template name="RenderScoreRefCell">
    <xsl:param name="score" />
    <xsl:param name="referee1" />
    <xsl:param name="referee2" />
    <xsl:param name="referee3" />
    <xsl:param name="referee4" />
    <xsl:param name="teamMatchID" />

    <xsl:value-of select="$score" />

    <xsl:if test="$showRefs = 'true' and ($score != '' or $showUnfinishedBoutRefs = 'true') and ($referee1 or $referee2 or $referee3 or $referee4)">
      <br />
      <span class="tableauReferee">
        <xsl:if test="$referee1">
          <xsl:call-template name="RenderReferee">
            <xsl:with-param name="referee"  select="$referee1" />
            <xsl:with-param name="isVideo"  select="false()" />
            <xsl:with-param name="isAssist" select="false()" />
          </xsl:call-template>
        </xsl:if>
        <xsl:if test="$referee2">
          <xsl:if test="$referee1"><br /></xsl:if>
          <xsl:call-template name="RenderReferee">
            <xsl:with-param name="referee"  select="$referee2" />
            <xsl:with-param name="isVideo"  select="boolean($teamMatchID = 0)" />
            <xsl:with-param name="isAssist" select="false()" />
          </xsl:call-template>
        </xsl:if>
        <xsl:if test="$referee3">
          <xsl:if test="$referee1 or $referee2"><br /></xsl:if>
          <xsl:call-template name="RenderReferee">
            <xsl:with-param name="referee"  select="$referee3" />
            <xsl:with-param name="isVideo"  select="false()" />
            <xsl:with-param name="isAssist" select="true()" />
          </xsl:call-template>
        </xsl:if>
        <xsl:if test="$referee4">
          <xsl:if test="$referee1 or $referee2 or $referee3"><br /></xsl:if>
          <xsl:call-template name="RenderReferee">
            <xsl:with-param name="referee"  select="$referee4" />
            <xsl:with-param name="isVideo"  select="false()" />
            <xsl:with-param name="isAssist" select="true()" />
          </xsl:call-template>
        </xsl:if>
      </span>
    </xsl:if>
  </xsl:template>

  <xsl:template name="RenderReferee">
    <xsl:param name="referee" />
    <xsl:param name="isVideo" />
    <xsl:param name="isAssist" />

    <xsl:choose>
      <xsl:when test="$isVideo">
        <xsl:value-of select="$localized/ft:LocText[@id='video']" />:&#160;
      </xsl:when>
      <xsl:when test="$isAssist">
        <xsl:value-of select="$localized/ft:LocText[@id='assist']" />:&#160;
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$localized/ft:LocText[@id='ref']" />:&#160;
      </xsl:otherwise>
    </xsl:choose>

    <xsl:value-of select="$referee/Name" />&#160;

    <xsl:call-template name="BuildAffiliations">
      <xsl:with-param name="showClub"     select="$showClubs" />
      <xsl:with-param name="clubAbbr"     select="$referee/ClubAbbr" />
      <xsl:with-param name="showDiv"      select="$showDivs" />
      <xsl:with-param name="divAbbr"      select="$referee/DivAbbr" />
      <xsl:with-param name="showCountry"  select="$showCountries" />
      <xsl:with-param name="countryAbbr"  select="$referee/CountryAbbr" />
      <xsl:with-param name="flagPath"     select="$flagPath" />
    </xsl:call-template>
  </xsl:template>


  <xsl:template name="ComputePower">
    <xsl:param name="startSize" />
    <xsl:param name="endSize" />
    <xsl:param name="curPower" />

    <xsl:if test="$startSize = $endSize">
      <xsl:value-of select="$curPower" />
    </xsl:if>
    <xsl:if test="$startSize &gt; $endSize">
      <xsl:call-template name="ComputePower">
        <xsl:with-param name="startSize" select="$startSize div 2" />
        <xsl:with-param name="endSize" select="$endSize" />
        <xsl:with-param name="curPower" select="$curPower * 2" />
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
  
  <xsl:include href="Transform\Common.xslt" />

</xsl:stylesheet>
