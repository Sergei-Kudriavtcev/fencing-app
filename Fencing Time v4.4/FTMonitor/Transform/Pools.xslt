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
  <xsl:param name="localPath"  />
  <xsl:param name="flagPath"   />
  <xsl:param name="fontSize"   />
  <xsl:param name="langCode"   />
  <xsl:param name="bgClass"    />

  <!-- Page-specific parameters -->
  <xsl:param name="showStrips"    />
  <xsl:param name="showRefs"      />
  <xsl:param name="showClubs"     />
  <xsl:param name="showDivs"      />
  <xsl:param name="showCountries" />
  <xsl:param name="showRatings"   />
  <xsl:param name="showTimes"     />
  <xsl:param name="specificPoolNum" />
  <xsl:param name="screenWidth" />
  
  <xsl:variable name="localized" select="document(concat('Lang\', $langCode, '.xml'))/ft:LocalizedText" />
  <xsl:variable name="showAffil" select="$showCountries  = 'true' or $showDivs = 'true' or $showClubs = 'true'" />
  
  <xsl:template match="/">
    <html xmlns="http://www.w3.org/1999/xhtml">
      <head>
        <link rel="stylesheet" type="text/css" href="{$localPath}/Styles/default.css" />
      </head>

      <body class="{$bgClass}" style="font-size: {$fontSize}em;">
        <div class="page">
          <xsl:variable name="poolNum" select="number($specificPoolNum)" />
          <div>
            <xsl:choose>
              <xsl:when test="$poolNum > 0">
                <xsl:for-each select="/ArrayOfPool/Pool[$poolNum]">
                  <xsl:call-template name="RenderPool" />
                </xsl:for-each>
              </xsl:when>
              <xsl:otherwise>
                <xsl:for-each select="/ArrayOfPool/Pool">
                  <xsl:call-template name="RenderPool" />
                </xsl:for-each>
              </xsl:otherwise>
            </xsl:choose>
          </div>
        </div>
      </body>
    </html>
  </xsl:template>

  <xsl:template name="RenderPool">
    <h2><xsl:value-of select="$localized/ft:LocText[@id='PoolNum']" /><xsl:value-of select="PoolNum" /></h2>
    <xsl:if test="($showStrips = 'true' and StripNum != '') or PoolTime != ''">
      <span class="poolStripTime">
        <xsl:if test="$showStrips = 'true' and StripNum != ''">
          <xsl:value-of select="$localized/ft:LocText[@id='onStrip']" />&#160;
          <xsl:value-of select="StripNum" />&#160;
        </xsl:if>
        <xsl:if test="$showTimes = 'true' and PoolTime != ''">
          <xsl:value-of select="$localized/ft:LocText[@id='atTime']" />&#160;
          <xsl:value-of select="PoolTime" />
        </xsl:if>
      </span>
    </xsl:if>
    
    <xsl:variable name="nameWidth"       select="number($screenWidth) * 0.325" />
    <xsl:variable name="spacerWidth"     select="number($screenWidth) * 0.01"  />
    <xsl:variable name="scoreGridWidth"  select="number($screenWidth) * 0.33"  />
    <xsl:variable name="resultGridWidth" select="number($screenWidth) * 0.325" />
    <xsl:variable name="scoreColWidth"   select="$scoreGridWidth div count(Competitors/PoolCompetitor)" />
    <xsl:variable name="resultColWidth"  select="$resultGridWidth div 6" />

    <table class="pool">
      <tr class="poolHeader">
        <th style="width: {$nameWidth}px;"></th>
        <th style="width: {$spacerWidth}px;">#</th>

        <!-- Score columns for each competitor -->
        <xsl:for-each select="Competitors/PoolCompetitor">
          <th style="width: {$scoreColWidth}px;">
            <xsl:value-of select="Position" />
          </th>
        </xsl:for-each>

        <th style="width: {$spacerWidth}px;"></th>
        <th style="width: {$resultColWidth}px;">V</th>
        <th style="width: {$resultColWidth}px;">V/M</th>
        <th style="width: {$resultColWidth}px;"><xsl:value-of select="$localized/ft:LocText[@id='TS']" /></th>
        <th style="width: {$resultColWidth}px;"><xsl:value-of select="$localized/ft:LocText[@id='TR']" /></th>
        <th style="width: {$resultColWidth}px;">Ind</th>
        <th style="width: {$resultColWidth}px;">Pl</th>
      </tr>

      <!-- Create a row for each competitor -->
      <xsl:for-each select="Competitors/PoolCompetitor">
        <xsl:variable name="thisComp" select="." />
        
        <tr style="height: {$scoreColWidth}px; font-size: {$fontSize * 1.25}em;">
          <xsl:attribute name="class">
            <xsl:choose>
              <xsl:when test="IsWithdrawn = 'true'">poolWithdrawn</xsl:when>
              <xsl:when test="IsExcluded = 'true'">poolExcluded</xsl:when>
              <xsl:when test="IsNoShow = 'true'">poolNoShow</xsl:when>
              <xsl:when test="position() mod 2 = 0">poolEvenRow</xsl:when>
              <xsl:otherwise>poolOddRow</xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>

          <!-- Name, rating, and affiliations -->
          <td class="poolNameCol">
            <xsl:value-of select="Name" />
            <xsl:if test="$showRatings = 'true' and Rating != ''">
              <xsl:text xml:space="preserve"> - </xsl:text>
              <xsl:value-of select="Rating" />
            </xsl:if>
            <xsl:if test="IsWithdrawn = 'true'">&#160;<xsl:value-of select="$localized/ft:LocText[@id='WithdrewParen']" /></xsl:if>
            <xsl:if test="IsExcluded = 'true'">&#160;<xsl:value-of select="$localized/ft:LocText[@id='ExcludedParen']" /></xsl:if>
            <xsl:if test="IsNoShow = 'true'">&#160;<xsl:value-of select="$localized/ft:LocText[@id='NoShowParen']" /></xsl:if>
            <xsl:if test="$showAffil">
              <br/>
              <span class="poolAffil">
                <xsl:call-template name="BuildAffiliations">
                  <xsl:with-param name="showClub"     select="$showClubs" />
                  <xsl:with-param name="clubAbbr"     select="ClubAbbr" />
                  <xsl:with-param name="showDiv"      select="$showDivs" />
                  <xsl:with-param name="divAbbr"      select="DivAbbr" />
                  <xsl:with-param name="showCountry"  select="$showCountries" />
                  <xsl:with-param name="countryAbbr"  select="CountryAbbr" />
                  <xsl:with-param name="flagPath"     select="$flagPath" />
                </xsl:call-template>
              </span>
            </xsl:if>
          </td>

          <!-- Position -->
          <xsl:variable name="rowPos" select="Position" />
          <td class="poolPosCol">
            <xsl:value-of select="$rowPos" />
          </td>

          <!-- Create score column for each opponent -->
          <xsl:for-each select="../../Competitors/PoolCompetitor">
            <xsl:variable name="colPos" select="Position" />
            <td>
              <xsl:variable name="scoreVal" select="$thisComp/Scores/string[number($colPos)]" />
              <xsl:choose>
                <xsl:when test="$colPos = $rowPos">   <!-- Filler on the diagonal -->
                  <xsl:attribute name="class">poolScoreFill</xsl:attribute>
                </xsl:when>
                <xsl:when test="starts-with($scoreVal, 'V')">
                  <xsl:attribute name="class">poolScoreVictory</xsl:attribute>
                  <xsl:value-of select="$scoreVal" />
                </xsl:when>
                <xsl:when test="starts-with($scoreVal, 'D')">
                  <xsl:attribute name="class">poolScoreDefeat</xsl:attribute>
                  <xsl:value-of select="$scoreVal" />
                </xsl:when>
                <xsl:when test="$scoreVal = 'W' or $thisComp/IsWithdrawn = 'true'">
                  <xsl:attribute name="class">poolWithdrawn</xsl:attribute>
                </xsl:when>
                <xsl:when test="$scoreVal = 'X' or $thisComp/IsExcluded = 'true' ">
                  <xsl:attribute name="class">poolExcluded</xsl:attribute>
                </xsl:when>
                <xsl:when test="$scoreVal = 'NS' or $thisComp/IsNoShow = 'true' ">
                  <xsl:attribute name="class">poolNoShow</xsl:attribute>
                </xsl:when>
              </xsl:choose>
            </td>                          
          </xsl:for-each>

          <td class="poolSpacerCol" />
          
          <!-- Result columns -->
          <td class="poolResultCol">
            <xsl:value-of select="$thisComp/Victories" />
          </td>
          <td class="poolResultCol">
            <xsl:value-of select="$thisComp/WinPercent" />
          </td>
          <td class="poolResultCol">
            <xsl:value-of select="$thisComp/TouchesScored" />
          </td>
          <td class="poolResultCol">
            <xsl:value-of select="$thisComp/TouchesReceived" />
          </td>
          <td class="poolResultCol">
            <xsl:value-of select="$thisComp/Indicator" />
          </td>
          <td class="poolResultCol">
            <xsl:if test="$thisComp/Place != 0">
              <xsl:value-of select="$thisComp/Place" />
            </xsl:if>
          </td>
        </tr>
      </xsl:for-each>
    </table>

    <!-- Referees -->
    <xsl:if test="$showRefs = 'true' and Referees/Referee">
      <div>
        <span class="poolRefsHeader"><xsl:value-of select="$localized/ft:LocText[@id='Referees']" /></span>
        <br/>
        <xsl:for-each select="Referees/Referee">
          <span class="poolRefs">
            <xsl:value-of select="Name" />
          </span>
          <br/>
          <xsl:if test="$showAffil">
            <span class="poolAffil">
              <xsl:call-template name="BuildAffiliations">
                <xsl:with-param name="showClub"     select="$showClubs" />
                <xsl:with-param name="clubAbbr"     select="ClubAbbr" />
                <xsl:with-param name="showDiv"      select="$showDivs" />
                <xsl:with-param name="divAbbr"      select="DivAbbr" />
                <xsl:with-param name="showCountry"  select="$showCountries" />
                <xsl:with-param name="countryAbbr"  select="CountryAbbr" />
                <xsl:with-param name="flagPath"     select="$flagPath" />
              </xsl:call-template>
              <br/>
            </span>
          </xsl:if>
        </xsl:for-each>
      </div>
    </xsl:if>
  </xsl:template>
  
  <xsl:include href="Transform\Common.xslt" />
</xsl:stylesheet>
