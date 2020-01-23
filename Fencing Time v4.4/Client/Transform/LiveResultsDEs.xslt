<?xml version="1.0" encoding="UTF-8" ?>
<!-- 
Fencing Time
By Daniel Berke
(C) Copyright by Daniel Berke 
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ft="http://www.fencingtime.com">
  <xsl:variable name="fileVersion4">4.4</xsl:variable>

  <!-- Template to render DE tableau -->
  <xsl:template name="RenderTableau">
    <xsl:variable name="elimType" select="ft:Scores/ft:Elimination/@ElimType" />
    
    <div>
      <xsl:for-each select="ft:Scores/ft:Elimination/ft:Tree">
        <xsl:sort select="@Order" data-type="number" />
        <xsl:call-template name="RenderElimTableau">
          <xsl:with-param name="startTableSize" select="@StartSize" />
          <xsl:with-param name="endTableSize"   select="@EndSize" />
        </xsl:call-template>
      </xsl:for-each>
    
      <p>
        <xsl:for-each select="ft:Scores//ft:TeamMatch">
          <xsl:call-template name="RenderTeamMatch" />
        </xsl:for-each>
      </p>
    </div>
  </xsl:template>
  
  <!-- Template to render DE tableau -->
  <xsl:template name="RenderElimTableau">
    <xsl:param name="startTableSize" />
    <xsl:param name="endTableSize" />

    <div>
      <!-- Count number of columns -->
      <xsl:variable name="numCols">
        <xsl:call-template name="CountCols">
          <xsl:with-param name="startSize" select="$startTableSize" />                
          <xsl:with-param name="endSize"   select="$endTableSize" />  
          <xsl:with-param name="curCount"  select="0" />
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="linesPerPod" select="ft:Table[1]/@Size * 2 div ft:Table[1]/@NumParts" />
      
      <xsl:if test="$startTableSize &gt; 16 and $numCols &gt; 2">
        <div class="viewSelectDiv">
          <xsl:value-of select="$localized/ft:LocText[@id='ViewFrom']" />
          <select class="viewSelect">
            <xsl:call-template name="CreateSelectOptions">
              <xsl:with-param name="tableSize" select="$startTableSize" />
              <xsl:with-param name="endSize"   select="$endTableSize" />
            </xsl:call-template>
          </select>
        </div>
      </xsl:if>
      
      <table class="elimTableau">
        <xsl:attribute name="style">
          <xsl:choose>
            <xsl:when test="$numCols = 2">width: 40%;</xsl:when>
            <xsl:when test="$numCols = 3">width: 60%;</xsl:when>
            <xsl:when test="$numCols = 4">width: 80%;</xsl:when>
            <xsl:otherwise>width: 100%;</xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <!-- Create column widths -->
        <xsl:if test="$numCols &lt; 5">
          <xsl:call-template name="RenderTableauColumnWidths">
            <xsl:with-param name="numCols" select="$numCols" />
            <xsl:with-param name="percent" select="100 div $numCols" />
          </xsl:call-template>
        </xsl:if>
        <xsl:if test="$numCols &gt;= 5">
          <xsl:call-template name="RenderTableauColumnWidths">
            <xsl:with-param name="numCols" select="5" />
            <xsl:with-param name="percent" select="20" />
          </xsl:call-template>
        </xsl:if>
        
        <!-- Create column headers -->
        <tr>
          <xsl:call-template name="RenderTableauHeader">
            <xsl:with-param name="tables"     select="ft:Table" />
            <xsl:with-param name="curColSize" select="$startTableSize" />
            <xsl:with-param name="sizeDelta"  select="0.5" />
            <xsl:with-param name="numTables"  select="$numCols - 1" />
          </xsl:call-template>
        </tr>

        <!-- Create blank row -->
        <tr>
          <xsl:call-template name="RenderTableauBlankRow">
            <xsl:with-param name="numCols" select="$numCols" />
          </xsl:call-template>
        </tr>

        <!-- Create tableau rows -->
        <xsl:call-template name="RenderElimTableRow">
          <xsl:with-param name="tableSize"   select="$startTableSize" />
          <xsl:with-param name="endColSize"  select="$endTableSize" />
          <xsl:with-param name="curRowNum"   select="0" />
          <xsl:with-param name="linesPerPod" select="$linesPerPod" />
        </xsl:call-template>
      </table>
    </div>
    <br />
  </xsl:template>
  
  <!-- Create options for dropdown list -->
  <xsl:template name="CreateSelectOptions">
    <xsl:param name="tableSize" />
    <xsl:param name="endSize" />
    
    <xsl:if test="$tableSize &gt; 8 and $tableSize &gt; $endSize">
      <option><xsl:value-of select="$localized/ft:LocText[@id='TableOf']" /><xsl:text xml:space="preserve">&#160;</xsl:text><xsl:value-of select="$tableSize" /></option>
      <xsl:call-template name="CreateSelectOptions">
        <xsl:with-param name="tableSize" select="$tableSize div 2" />
        <xsl:with-param name="endSize"   select="$endSize" />
      </xsl:call-template>
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
        <xsl:if test="$tables[@Size=$curColSize]/@Name">
          <xsl:value-of select="$tables[@Size=$curColSize]/@Name" />
        </xsl:if>
        <xsl:if test="not($tables[@Size=$curColSize]/@Name)">
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


  <!-- Render a row in a tableau -->
  <xsl:template name="RenderElimTableRow">
    <xsl:param name="tableSize" />
    <xsl:param name="endColSize" />
    <xsl:param name="curRowNum" />
    <xsl:param name="linesPerPod" />

    <xsl:if test="$curRowNum &lt; $tableSize * 2">
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
          <xsl:with-param name="linesPerPod"  select="$linesPerPod" />
        </xsl:call-template>
      </tr>

      <xsl:call-template name="RenderElimTableRow">
        <xsl:with-param name="tableSize"   select="$tableSize" />
        <xsl:with-param name="endColSize"  select="$endColSize" />
        <xsl:with-param name="curRowNum"   select="$curRowNum + 1" />
        <xsl:with-param name="linesPerPod" select="$linesPerPod" />
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
  
  
  <xsl:template name="RenderRowCells">
    <xsl:param name="startColSize" />
    <xsl:param name="endColSize" />
    <xsl:param name="curRowNum" />
    <xsl:param name="curColSize" />
    <xsl:param name="curColPower" />
    <xsl:param name="linesPerPod" />

    <xsl:if test="$curColSize &gt;= $endColSize">
      <td>
        <xsl:variable name="boutIndex"   select="floor($curRowNum div ($curColPower * 4)) + 1" />
        <xsl:variable name="bout"        select="ft:Table[@Size=$curColSize]/ft:Bout[$boutIndex]" />
        <xsl:variable name="prevBoutTop" select="ft:Table[@Size=($curColSize*2)]/ft:Bout[($boutIndex*2)-1]" />
        <xsl:variable name="prevBoutBot" select="ft:Table[@Size=($curColSize*2)]/ft:Bout[$boutIndex*2]" />

        <xsl:choose>
          <!-- ============== Top name cell ============== -->
          <xsl:when test="($curRowNum - ($curColPower - 1)) mod ($curColPower * 4) = 0">
            <xsl:attribute name="class">tableauNameCell tableauBorderBottom</xsl:attribute>
            <xsl:choose>
              <!-- If a name is present, print it -->
              <xsl:when test="$bout/ft:TopCompetitor">
                <xsl:call-template name="RenderNameCell">
                  <xsl:with-param name="seed"    select="$bout/@TopSeed" />
                  <xsl:with-param name="name"    select="$bout/ft:TopCompetitor/@Name" />
                  <xsl:with-param name="club"    select="$bout/ft:TopCompetitor/@Club" />
                  <xsl:with-param name="div"     select="$bout/ft:TopCompetitor/@Division" />
                  <xsl:with-param name="country" select="$bout/ft:TopCompetitor/@Country" />
                </xsl:call-template>
              </xsl:when>
              
              <!-- If a bye is present, print it -->
              <xsl:when test="$bout/@TopBye = 'True'">
                <xsl:call-template name="RenderNameCell">
                  <xsl:with-param name="seed" select="$bout/@TopSeed" />
                  <xsl:with-param name="bye"  select="'True'" />
                </xsl:call-template>
              </xsl:when>

              <!-- Draw winner name when in rightmost column -->
              <xsl:when test="$curColSize = $endColSize and $prevBoutTop/ft:Winner/@Name != ''">
                <xsl:call-template name="RenderNameCell">
                  <xsl:with-param name="seed"    select="$prevBoutTop/@WinnerSeed" />
                  <xsl:with-param name="name"    select="$prevBoutTop/ft:Winner/@Name" />
                  <xsl:with-param name="bye"     select="$prevBoutTop/@WinnerBye" />
                  <xsl:with-param name="club"    select="$prevBoutTop/ft:Winner/@Club" />
                  <xsl:with-param name="div"     select="$prevBoutTop/ft:Winner/@Division" />
                  <xsl:with-param name="country" select="$prevBoutTop/ft:Winner/@Country" />
                </xsl:call-template>
              </xsl:when>
              
              <!-- If a start time or strip is present, print it -->
              <xsl:when test="$prevBoutTop/@Strip != '' or $prevBoutTop/@StartTime != ''">
                <xsl:call-template name="RenderTimeStripCell">
                  <xsl:with-param name="strip"  select="$prevBoutTop/@Strip" />
                  <xsl:with-param name="time"   select="$prevBoutTop/@StartTime" />
                </xsl:call-template>
              </xsl:when>
            </xsl:choose>

            <!-- Blank to force cell to draw if empty -->
            <xsl:text xml:space="preserve">&#160;</xsl:text>
          </xsl:when>

          <!-- ============== Top score cell ============== -->
          <xsl:when test="($curRowNum - $curColPower) mod ($curColPower * 4) = 0">
            <!-- No right border in last column -->
            <xsl:if test="$curColSize != $endColSize">
              <xsl:attribute name="class">tableauBorderRight</xsl:attribute>
            </xsl:if>
            
            <xsl:choose>
              <!-- Draw score if not first table -->
              <xsl:when test="$curColSize != $startColSize">
                <xsl:call-template name="RenderScoreRefCell">
                  <xsl:with-param name="score"       select="$prevBoutTop/@Score" />
                  <xsl:with-param name="referee1"    select="$prevBoutTop/ft:Referee1" />
                  <xsl:with-param name="referee2"    select="$prevBoutTop/ft:Referee2" />
                  <xsl:with-param name="referee3"    select="$prevBoutTop/ft:Referee3" />
                  <xsl:with-param name="referee4"    select="$prevBoutTop/ft:Referee4" />
                  <xsl:with-param name="teamMatchID" select="$prevBoutTop/ft:TeamMatch/@ID" />
                  <xsl:with-param name="wdx"         select="$prevBoutTop/@AnyWDX" />
                  <xsl:with-param name="boutID"      select="$prevBoutTop/@ID" />
                  <xsl:with-param name="live"        select="$prevBoutTop/@Live" />
                </xsl:call-template>
              </xsl:when>
            </xsl:choose>
            
            <!-- Blank to force cell to draw if empty -->
            <xsl:text xml:space="preserve">&#160;</xsl:text>
          </xsl:when>

          <!-- ============== Vertical connector cell ============== -->
          <xsl:when test="($curRowNum - ($curColPower - 1)) mod ($curColPower * 4) &lt; ($curColPower * 2) and
                          ($curRowNum &gt; $curColPower)">
            <!-- No verticals in last column -->
            <xsl:if test="$curColSize != $endColSize">
              <xsl:attribute name="class">tableauBorderRight</xsl:attribute>
            </xsl:if>

            <!-- Blank to force cell to draw -->
            <xsl:text xml:space="preserve">&#160;</xsl:text>
          </xsl:when>

          <!-- ============== Bottom name cell ============== -->
          <xsl:when test="($curRowNum - ($curColPower - 1 + ($curColPower * 2))) mod ($curColPower * 4) = 0">
            <!-- No verticals in last column -->
            <xsl:if test="$curColSize != $endColSize">
              <xsl:attribute name="class">tableauNameCell tableauBorderBottomRight</xsl:attribute>
            </xsl:if>
            <xsl:if test="$curColSize = $endColSize">
              <xsl:attribute name="class">tableauNameCell tableauBorderBottom</xsl:attribute>
            </xsl:if>

            <xsl:choose>
              <!-- If a name is present, print it -->
              <xsl:when test="$bout/ft:BottomCompetitor">
                <xsl:call-template name="RenderNameCell">
                  <xsl:with-param name="seed"    select="$bout/@BottomSeed" />
                  <xsl:with-param name="name"    select="$bout/ft:BottomCompetitor/@Name" />
                  <xsl:with-param name="club"    select="$bout/ft:BottomCompetitor/@Club" />
                  <xsl:with-param name="div"     select="$bout/ft:BottomCompetitor/@Division" />
                  <xsl:with-param name="country" select="$bout/ft:BottomCompetitor/@Country" />
                </xsl:call-template>
              </xsl:when>
            
              <!-- If a bye is present, print it -->
              <xsl:when test="$bout/@BottomBye = 'True'">
                <xsl:call-template name="RenderNameCell">
                  <xsl:with-param name="seed" select="$bout/@BottomSeed" />
                  <xsl:with-param name="bye"  select="'True'" />
                </xsl:call-template>
              </xsl:when>

              <!-- Draw winner name when in rightmost column -->
              <xsl:when test="$curColSize = $endColSize and $prevBoutBot/ft:Winner/@Name != ''">
                <xsl:call-template name="RenderNameCell">
                  <xsl:with-param name="seed"    select="$prevBoutBot/@WinnerSeed" />
                  <xsl:with-param name="name"    select="$prevBoutBot/ft:Winner/@Name" />
                  <xsl:with-param name="bye"     select="$prevBoutBot/@WinnerBye" />
                  <xsl:with-param name="club"    select="$prevBoutBot/ft:Winner/@Club" />
                  <xsl:with-param name="div"     select="$prevBoutBot/ft:Winner/@Division" />
                  <xsl:with-param name="country" select="$prevBoutBot/ft:Winner/@Country" />
                </xsl:call-template>
              </xsl:when>
              
              <!-- If a start time or strip is present, print it -->
              <xsl:when test="$prevBoutBot/@Strip != '' or $prevBoutBot/@StartTime != ''">
                <xsl:call-template name="RenderTimeStripCell">
                  <xsl:with-param name="strip"  select="$prevBoutBot/@Strip" />
                  <xsl:with-param name="time"   select="$prevBoutBot/@StartTime" />
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
                  <xsl:with-param name="score"       select="$prevBoutBot/@Score" />
                  <xsl:with-param name="referee1"    select="$prevBoutBot/ft:Referee1" />
                  <xsl:with-param name="referee2"    select="$prevBoutBot/ft:Referee2" />
                  <xsl:with-param name="referee3"    select="$prevBoutBot/ft:Referee3" />
                  <xsl:with-param name="referee4"    select="$prevBoutBot/ft:Referee4" />
                  <xsl:with-param name="teamMatchID" select="$prevBoutBot/ft:TeamMatch/@ID" />
                  <xsl:with-param name="wdx"         select="$prevBoutBot/@AnyWDX" />
                  <xsl:with-param name="boutID"      select="$prevBoutBot/@ID" />
                  <xsl:with-param name="live"        select="$prevBoutBot/@Live" />
                </xsl:call-template>
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
        <xsl:with-param name="linesPerPod"  select="$linesPerPod" />
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
  
  
  <xsl:template name="RenderNameCell">
    <xsl:param name="seed" />
    <xsl:param name="name" />
    <xsl:param name="bye" />
    <xsl:param name="club" />
    <xsl:param name="div" />
    <xsl:param name="country" />

    <!-- If name or bye present, print seed -->
    <xsl:if test="($name or $bye = 'True') and $seed != ''">
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
      <span class="tableauCompAffil">
        <br />
        <xsl:call-template name="BuildAffiliations">
          <xsl:with-param name="clubAbbr"     select="$club" />
          <xsl:with-param name="divAbbr"      select="$div" />
          <xsl:with-param name="countryAbbr"  select="$country" />
        </xsl:call-template>
      </span>
      
    </xsl:if>

    <!-- If a bye is present, print it -->
    <xsl:if test="$bye = 'True'">
      <span class="tableauCompName">-BYE-</span>
    </xsl:if>
  </xsl:template>

  
  <xsl:template name="RenderTimeStripCell">
    <xsl:param name="strip" />
    <xsl:param name="time" />
   
    <span class="tableauTimeStrip">
      <xsl:if test="$strip != ''">
        &#160;<xsl:value-of select="$localized/ft:LocText[@id='OnStrip']" />&#160;<xsl:value-of select="$strip" />
      </xsl:if>
      <xsl:if test="$time != ''">
        &#160;<xsl:value-of select="$localized/ft:LocText[@id='At']" />&#160;<xsl:value-of select="$time" />
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
    <xsl:param name="wdx" />
    <xsl:param name="boutID" />
    <xsl:param name="live" />
    
    <xsl:value-of select="$score" />
    
    <xsl:if test="$teamMatchID">
      <br />
      <span class="tableauMatchDetailsLink">
        <a href="#teamMatch{$teamMatchID}">[<xsl:value-of select="$localized/ft:LocText[@id='MatchDetails']" />]</a>
      </span>
    </xsl:if>
    
    <xsl:if test="not($teamMatchID) and ($referee1 or $referee2 or $referee3 or $referee4)">
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
            <xsl:with-param name="isVideo"  select="true()" />
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
    
    <xsl:variable name="liveUrl" select="/ft:EventSnapshot/ft:EventInfo/@MaskUrl" />
    <xsl:if test="$live and $liveUrl and $liveUrl != ''">
      <xsl:if test="$score != '' or $teamMatchID or $referee1 or $referee2 or $referee3 or $referee4">
        <br />
      </xsl:if>
      <span class="tableauMatchDetailsLink">
        <xsl:if test="$live = 'I'">
          <a href="{$liveUrl}/fightlive.html?id={$boutID}&amp;t=live&amp;l=en" target="_blank">[<xsl:value-of select="$localized/ft:LocText[@id='LiveScores']" />]</a>
        </xsl:if>
        <xsl:if test="$live = 'T'">
          <a href="{$liveUrl}/fightlive.html?id={$boutID}&amp;t=teamlive&amp;l=en" target="_blank">[<xsl:value-of select="$localized/ft:LocText[@id='LiveScores']" />]</a>
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
        <xsl:value-of select="$localized/ft:LocText[@id='Video']" />:&#160;
      </xsl:when>
      <xsl:when test="$isAssist">
        <xsl:value-of select="$localized/ft:LocText[@id='Assist']" />:&#160;
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$localized/ft:LocText[@id='Ref']" />:&#160;
      </xsl:otherwise>
    </xsl:choose>
    
    <xsl:value-of select="$referee/@Name" />&#160;

    <xsl:call-template name="BuildAffiliations">
      <xsl:with-param name="clubAbbr"     select="$referee/@Club" />
      <xsl:with-param name="divAbbr"      select="$referee/@Division" />
      <xsl:with-param name="countryAbbr"  select="$referee/@Country" />
    </xsl:call-template>
  </xsl:template>
  
  
  <xsl:template name="CountCols">
    <xsl:param name="startSize" />                
    <xsl:param name="endSize" />
    <xsl:param name="curCount" />
   
    <xsl:if test="$startSize &lt; $endSize">
      <xsl:value-of select="$curCount" />  
    </xsl:if>
    <xsl:if test="$startSize &gt;= $endSize">
      <xsl:call-template name="CountCols">
        <xsl:with-param name="startSize" select="$startSize div 2" />                
        <xsl:with-param name="endSize" select="$endSize" />  
        <xsl:with-param name="curCount" select="$curCount + 1" />
      </xsl:call-template>
    </xsl:if>               
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
  
</xsl:stylesheet>
